class ProjectModel {
  final String id;
  final String name;
  final String category;
  final DateTime updatedAt;
  final String? sourceDocumentId;
  final String? liftPlanDocumentId;
  final bool hasReport;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.category,
    required this.updatedAt,
    this.sourceDocumentId,
    this.liftPlanDocumentId,
    this.hasReport = false,
  });

  ProjectModel copyWith({
    String? id,
    String? name,
    String? category,
    DateTime? updatedAt,
    String? sourceDocumentId,
    String? liftPlanDocumentId,
    bool? hasReport,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      updatedAt: updatedAt ?? this.updatedAt,
      sourceDocumentId: sourceDocumentId ?? this.sourceDocumentId,
      liftPlanDocumentId: liftPlanDocumentId ?? this.liftPlanDocumentId,
      hasReport: hasReport ?? this.hasReport,
    );
  }
}

