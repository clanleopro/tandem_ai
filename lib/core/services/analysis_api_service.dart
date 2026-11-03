// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';

// import '../../data/models/analysis_report.dart';
// import '../../data/models/document_item.dart';
// import '../network/api_endpoints.dart';

// class AnalysisApiService {
//   final String baseUrl;

//   AnalysisApiService({
//     this.baseUrl = const String.fromEnvironment(
//       'API_BASE_URL',
//       defaultValue: ApiEndpoints.defaultBaseUrl,
//     ),
//   });

//   http.Client? _client;
//   bool _disposed = false;

//   Future<AnalysisReport> analyze({
//     required DocumentItem referenceDoc,
//     required Uint8List referenceBytes,
//     required DocumentItem planDoc,
//     required Uint8List planBytes,
//     required String projectId,
//     required String projectName,
//   }) async {
//     if (_disposed) {
//       throw Exception('AnalysisApiService has been disposed.');
//     }

//     if (_client != null) {
//       throw Exception('An analysis is already running.');
//     }

//     if (referenceBytes.isEmpty || planBytes.isEmpty) {
//       throw Exception('Both PDF documents must contain data.');
//     }

//     final client = http.Client();
//     _client = client;

//     try {
//       final base = baseUrl.replaceAll(RegExp(r'/+$'), '');
//       final uri = Uri.parse('$base/api/v1/analyses');

//       final request = http.MultipartRequest('POST', uri)
//         ..headers['Accept'] = 'application/json'
//         ..files.add(
//           http.MultipartFile.fromBytes(
//             'referenceStandard',
//             referenceBytes,
//             filename: referenceDoc.fileName,
//             contentType: MediaType('application', 'pdf'),
//           ),
//         )
//         ..files.add(
//           http.MultipartFile.fromBytes(
//             'documentToReview',
//             planBytes,
//             filename: planDoc.fileName,
//             contentType: MediaType('application', 'pdf'),
//           ),
//         );

//       // Covers sending the request and reading the complete response.
//       final response = await (() async {
//         final streamed = await client.send(request);
//         return await http.Response.fromStream(streamed);
//       })().timeout(const Duration(minutes: 3));

//       dynamic decoded;

//       try {
//         decoded = jsonDecode(response.body);
//       } catch (_) {
//         throw Exception(
//           'The server returned an invalid response '
//           '(HTTP ${response.statusCode}).',
//         );
//       }

//       if (response.statusCode < 200 || response.statusCode >= 300) {
//         final message = decoded is Map && decoded['message'] is String
//             ? decoded['message'] as String
//             : 'Document analysis failed '
//                   '(HTTP ${response.statusCode}).';

//         throw Exception(message);
//       }

//       if (decoded is! Map<String, dynamic>) {
//         throw Exception('The server returned an unexpected report format.');
//       }

//       return AnalysisReport.fromApiResponse(
//         decoded,
//         projectId: projectId,
//         projectName: projectName,
//         referenceFileName: referenceDoc.fileName,
//         liftPlanFileName: planDoc.fileName,
//       );
//     } on TimeoutException {
//       throw Exception(
//         'Analysis timed out. Please try again with smaller PDFs.',
//       );
//     } on http.ClientException {
//       throw Exception('Could not connect to the analysis server.');
//     } finally {
//       client.close();

//       if (identical(_client, client)) {
//         _client = null;
//       }
//     }
//   }

//   void dispose() {
//     _disposed = true;
//     _client?.close();
//     _client = null;
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../data/models/analysis_report.dart';
import '../../data/models/document_item.dart';
import '../network/api_endpoints.dart';

class AnalysisApiService {
  final String baseUrl;

  AnalysisApiService({
    this.baseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: ApiEndpoints.defaultBaseUrl,
    ),
  });

  http.Client? _client;
  bool _disposed = false;

  Future<AnalysisReport> analyze({
    required DocumentItem referenceDoc,
    required Uint8List referenceBytes,
    required DocumentItem planDoc,
    required Uint8List planBytes,
    required String projectId,
    required String projectName,
  }) async {
    if (_disposed) {
      throw Exception('AnalysisApiService has been disposed.');
    }

    if (_client != null) {
      throw Exception('An analysis is already running.');
    }

    if (referenceBytes.isEmpty || planBytes.isEmpty) {
      throw Exception('Both PDF documents must contain data.');
    }

    const maxFileSize = 25 * 1024 * 1024;

    if (referenceBytes.length > maxFileSize ||
        planBytes.length > maxFileSize) {
      throw Exception('Each PDF must be 25 MB or smaller.');
    }

    final client = http.Client();
    _client = client;

    try {
      final base = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
      final uri = Uri.parse('$base/api/v1/analyses');

      final request = http.MultipartRequest('POST', uri)
        ..headers['Accept'] = 'application/json'
        ..files.add(
          http.MultipartFile.fromBytes(
            'referenceStandard',
            referenceBytes,
            filename: referenceDoc.fileName,
            contentType: MediaType('application', 'pdf'),
          ),
        )
        ..files.add(
          http.MultipartFile.fromBytes(
            'documentToReview',
            planBytes,
            filename: planDoc.fileName,
            contentType: MediaType('application', 'pdf'),
          ),
        );

      // Timeout includes uploading and reading the complete response.
      final response = await (() async {
        final streamedResponse = await client.send(request);
        return await http.Response.fromStream(streamedResponse);
      })().timeout(
        const Duration(minutes: 3),
      );

      final dynamic decoded;

      try {
        decoded = jsonDecode(response.body);
      } on FormatException {
        throw Exception(
          'The server returned invalid JSON '
          '(HTTP ${response.statusCode}).',
        );
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = decoded is Map && decoded['message'] is String
            ? decoded['message'] as String
            : 'Document analysis failed '
                '(HTTP ${response.statusCode}).';

        throw Exception(message);
      }

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException(
          'The server returned an unexpected response format.',
        );
      }

      if (decoded['success'] != true) {
        throw Exception(
          decoded['message']?.toString() ??
              'Document analysis failed.',
        );
      }

      final data = decoded['data'];

      if (data is! Map<String, dynamic>) {
        throw const FormatException(
          'The response does not contain valid analysis data.',
        );
      }

      // New response:
      // {
      //   "success": true,
      //   "data": {
      //     "analysisId": "...",
      //     "report": {
      //       "title": "...",
      //       "summary": "...",
      //       "findings": [...]
      //     }
      //   }
      // }
      //
      // Also supports the older response where data is the report.
      final reportData = data.containsKey('report')
          ? data['report']
          : data;

      if (reportData is! Map<String, dynamic>) {
        throw const FormatException(
          'The response does not contain a valid report.',
        );
      }

      // Normalize the response for the existing report model.
      return AnalysisReport.fromApiResponse(
        {
          'success': true,
          'data': reportData,
        },
        projectId: projectId,
        projectName: projectName,
        referenceFileName: referenceDoc.fileName,
        liftPlanFileName: planDoc.fileName,
      );
    } on TimeoutException {
      throw Exception(
        'Analysis timed out. Please try again with smaller PDFs.',
      );
    } on http.ClientException {
      throw Exception(
        'Could not connect to the analysis server at $baseUrl.',
      );
    } finally {
      client.close();

      if (identical(_client, client)) {
        _client = null;
      }
    }
  }

  void dispose() {
    _disposed = true;
    _client?.close();
    _client = null;
  }
}