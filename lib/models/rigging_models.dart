enum FindingStatus { violation, warning, compliant }

enum FindingSeverity { critical, high, medium, low }

class RiggingStandard {
  final String id;
  final String code;
  final String title;
  final String category;
  final String organization;
  final int clausesCount;
  final String uploadedAt;
  final String fileSize;
  final String keyRequirementsSummary;
  final List<String> tags;
  final bool isDefault;

  const RiggingStandard({
    required this.id,
    required this.code,
    required this.title,
    required this.category,
    required this.organization,
    required this.clausesCount,
    required this.uploadedAt,
    required this.fileSize,
    required this.keyRequirementsSummary,
    required this.tags,
    this.isDefault = false,
  });

  RiggingStandard copyWith({
    String? id,
    String? code,
    String? title,
    String? category,
    String? organization,
    int? clausesCount,
    String? uploadedAt,
    String? fileSize,
    String? keyRequirementsSummary,
    List<String>? tags,
    bool? isDefault,
  }) {
    return RiggingStandard(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      category: category ?? this.category,
      organization: organization ?? this.organization,
      clausesCount: clausesCount ?? this.clausesCount,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      fileSize: fileSize ?? this.fileSize,
      keyRequirementsSummary:
          keyRequirementsSummary ?? this.keyRequirementsSummary,
      tags: tags ?? this.tags,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class ProjectFile {
  final String id;
  final String fileName;
  final String liftDescription;
  final String craneModel;
  final double totalLoadWeightTons;
  final String slingConfiguration;
  final String engineerInCharge;
  final String revision;
  final String uploadedAt;
  final String fileSize;

  const ProjectFile({
    required this.id,
    required this.fileName,
    required this.liftDescription,
    required this.craneModel,
    required this.totalLoadWeightTons,
    required this.slingConfiguration,
    required this.engineerInCharge,
    required this.revision,
    required this.uploadedAt,
    required this.fileSize,
  });
}

class AuditFinding {
  final String id;
  final String clauseRef;
  final String clauseTitle;
  final String standardRequirement;
  final String projectFinding;
  final FindingStatus status;
  final FindingSeverity severity;
  final String category;
  final String technicalExplanation;
  final String requiredRemedy;
  final String? engineeringCalculation;

  const AuditFinding({
    required this.id,
    required this.clauseRef,
    required this.clauseTitle,
    required this.standardRequirement,
    required this.projectFinding,
    required this.status,
    required this.severity,
    required this.category,
    required this.technicalExplanation,
    required this.requiredRemedy,
    this.engineeringCalculation,
  });
}

class AuditReport {
  final String id;
  final String projectId;
  final String projectName;
  final RiggingStandard standard;
  final ProjectFile projectFile;
  final DateTime auditedAt;
  final int overallComplianceScore;
  final int violationsCount;
  final int warningsCount;
  final int compliantCount;
  final String executiveSummary;
  final List<AuditFinding> findings;
  final Map<String, dynamic> liftMetrics;

  const AuditReport({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.standard,
    required this.projectFile,
    required this.auditedAt,
    required this.overallComplianceScore,
    required this.violationsCount,
    required this.warningsCount,
    required this.compliantCount,
    required this.executiveSummary,
    required this.findings,
    required this.liftMetrics,
  });
}

class ChatMessage {
  final String id;
  final String sender; // 'user' or 'auditor'
  final String text;
  final DateTime timestamp;
  final List<String>? quickActionPrompts;
  final String? codeSnippetOrFormula;
  final String? linkedFindingClause;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.quickActionPrompts,
    this.codeSnippetOrFormula,
    this.linkedFindingClause,
  });
}

class AuditProject {
  final String id;
  final String name;
  final String siteLocation;
  final String client;
  final RiggingStandard standard;
  final ProjectFile projectFile;
  final AuditReport? report;
  final List<ChatMessage> chatHistory;
  final DateTime createdAt;
  final String status;

  AuditProject({
    required this.id,
    required this.name,
    required this.siteLocation,
    required this.client,
    required this.standard,
    required this.projectFile,
    this.report,
    required this.chatHistory,
    required this.createdAt,
    required this.status,
  });

  AuditProject copyWith({
    String? id,
    String? name,
    String? siteLocation,
    String? client,
    RiggingStandard? standard,
    ProjectFile? projectFile,
    AuditReport? report,
    List<ChatMessage>? chatHistory,
    DateTime? createdAt,
    String? status,
  }) {
    return AuditProject(
      id: id ?? this.id,
      name: name ?? this.name,
      siteLocation: siteLocation ?? this.siteLocation,
      client: client ?? this.client,
      standard: standard ?? this.standard,
      projectFile: projectFile ?? this.projectFile,
      report: report ?? this.report,
      chatHistory: chatHistory ?? this.chatHistory,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
