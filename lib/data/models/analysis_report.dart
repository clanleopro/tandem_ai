enum FindingStatus { match, deviation, omission, needsReview }

class FindingItem {
  final String topic;
  final String referenceStandardSpec;
  final String liftPlanSpec;
  final String result;
  final FindingStatus status;
  final String severity;
  final String? referenceCitation;
  final String? liftPlanCitation;
  final String? differenceExplanation;
  final String? whatToCheck;

  const FindingItem({
    required this.topic,
    required this.referenceStandardSpec,
    required this.liftPlanSpec,
    required this.result,
    required this.status,
    this.severity = 'info',
    this.referenceCitation,
    this.liftPlanCitation,
    this.differenceExplanation,
    this.whatToCheck,
  });

  factory FindingItem.fromJson(Map<String, dynamic> json) {
    String citation(String page, String evidence) => [
      json[page]?.toString() ?? '',
      json[evidence]?.toString() ?? '',
    ].where((text) => text.isNotEmpty).join('\n');
    return FindingItem(
      topic: json['title']?.toString() ?? 'Finding',
      referenceStandardSpec: json['standard_evidence']?.toString() ?? '',
      liftPlanSpec: json['plan_evidence']?.toString() ?? '',
      result: json['description']?.toString() ?? '',
      // Severity alone cannot establish a match or a deviation.
      status: FindingStatus.needsReview,
      severity: json['severity']?.toString() ?? 'info',
      referenceCitation: citation('standard_page', 'standard_evidence'),
      liftPlanCitation: citation('plan_page', 'plan_evidence'),
      differenceExplanation: json['description']?.toString(),
      whatToCheck: json['recommendation']?.toString(),
    );
  }
}

class AnalysisReport {
  final String id;
  final String projectId;
  final String projectName;
  final DateTime generatedAt;
  final String referenceFileName;
  final String liftPlanFileName;
  final String title;
  final String overallStatus;
  final List<String> limitations;
  final String purpose;
  final String summaryText;
  final List<String> summaryBullets;
  final String safetyImpactNote;
  final List<FindingItem> findings;
  final List<String> suggestedNextSteps;
  final String scopeAndNotes;
  final String disclaimer;

  const AnalysisReport({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.generatedAt,
    required this.referenceFileName,
    required this.liftPlanFileName,
    required this.purpose,
    required this.summaryText,
    required this.summaryBullets,
    required this.safetyImpactNote,
    required this.findings,
    required this.suggestedNextSteps,
    required this.scopeAndNotes,
    this.title = 'Document Audit Report',
    this.overallStatus = 'needs_review',
    this.limitations = const [],
    this.disclaimer = 'AI-assisted preliminary review. Requires qualified human review and does not certify or approve a lift.',
  });

  String get overallStatusLabel => overallStatus
      .split('_')
      .where((word) => word.isNotEmpty)
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');

  factory AnalysisReport.fromApiResponse(
    Map<String, dynamic> response, {
    required String projectId,
    required String projectName,
    required String referenceFileName,
    required String liftPlanFileName,
  }) {
    final data = response['data'];
    if (response['success'] != true || data is! Map<String, dynamic>) {
      throw FormatException(
        response['message']?.toString() ?? 'Invalid report response.',
      );
    }
    if (data['summary'] is! String || data['findings'] is! List) {
      throw const FormatException('The report is missing required fields.');
    }
    final findings = (data['findings'] as List).map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Invalid finding in report.');
      }
      return FindingItem.fromJson(item);
    }).toList();
    final rawLimitations = data['limitations'];
    final limitations = rawLimitations is List
        ? rawLimitations.map((item) => item.toString()).toList()
        : <String>[];
    final now = DateTime.now();
    return AnalysisReport(
      id: 'report_${now.microsecondsSinceEpoch}',
      projectId: projectId,
      projectName: projectName,
      generatedAt: now,
      referenceFileName: referenceFileName,
      liftPlanFileName: liftPlanFileName,
      title: data['title']?.toString() ?? 'Document Audit Report',
      overallStatus: data['overall_status']?.toString() ?? 'needs_review',
      limitations: limitations,
      purpose: 'Compare the submitted document against the supplied reference.',
      summaryText: data['summary'] as String,
      summaryBullets: findings.map((item) => item.topic).toList(),
      safetyImpactNote:
          'Review the findings and limitations before drawing conclusions.',
      findings: findings,
      suggestedNextSteps: findings
          .map((item) => item.whatToCheck ?? '')
          .where((text) => text.isNotEmpty)
          .toSet()
          .toList(),
      scopeAndNotes: limitations.map((text) => '• $text').join('\n\n'),
    );
  }
}
