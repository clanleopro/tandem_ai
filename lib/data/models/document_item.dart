class DocumentItem {
  final String id;
  final String fileName;
  final String extension;
  final String sizeString;
  final String description;
  final bool isReferenceStandard;
  final DateTime uploadedAt;

  const DocumentItem({
    required this.id,
    required this.fileName,
    required this.extension,
    required this.sizeString,
    required this.description,
    required this.isReferenceStandard,
    required this.uploadedAt,
  });

  DocumentItem copyWith({
    String? id,
    String? fileName,
    String? extension,
    String? sizeString,
    String? description,
    bool? isReferenceStandard,
    DateTime? uploadedAt,
  }) {
    return DocumentItem(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      extension: extension ?? this.extension,
      sizeString: sizeString ?? this.sizeString,
      description: description ?? this.description,
      isReferenceStandard: isReferenceStandard ?? this.isReferenceStandard,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}

