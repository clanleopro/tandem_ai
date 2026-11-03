import '../../data/models/project_model.dart';
import '../../data/models/document_item.dart';
import '../../data/models/analysis_report.dart';
import '../../data/models/discussion_message.dart';

class MockDataService {
  static List<ProjectModel> getInitialProjects() {
    final now = DateTime.now();
    return [
      ProjectModel(
        id: 'proj_titan',
        name: 'Titan Rigging',
        category: 'Heavy Industrial Crane Operations',
        updatedAt: now.subtract(const Duration(hours: 2)),
        sourceDocumentId: 'doc_standard_1',
        liftPlanDocumentId: 'doc_plan_1',
        hasReport: true,
      ),
      ProjectModel(
        id: 'proj_heavy',
        name: 'Heavy Move',
        category: 'Multi-Axle SPMT & Gantry Transport',
        updatedAt: now.subtract(const Duration(days: 1)),
        sourceDocumentId: 'doc_standard_2',
        liftPlanDocumentId: null,
        hasReport: false,
      ),
      ProjectModel(
        id: 'proj_force',
        name: 'Lift Force',
        category: 'Offshore Module Installation',
        updatedAt: now.subtract(const Duration(days: 3)),
        sourceDocumentId: null,
        liftPlanDocumentId: null,
        hasReport: false,
      ),
      ProjectModel(
        id: 'proj_steel',
        name: 'Steel Bridge',
        category: 'Precast Truss Tandem Erection',
        updatedAt: now.subtract(const Duration(days: 5)),
        sourceDocumentId: 'doc_standard_1',
        liftPlanDocumentId: 'doc_plan_2',
        hasReport: true,
      ),
    ];
  }

  static List<DocumentItem> getStandardDocuments() {
    final now = DateTime.now();
    return [
      DocumentItem(
        id: 'doc_standard_loler',
        fileName: 'LOLER_1998 -Lifting_Regulations.pdf',
        extension: 'PDF',
        sizeString: '5.2 MB',
        description:
            'Lifting Operations and Lifting Equipment Regulations 1998 (LOLER)',
        isReferenceStandard: true,
        uploadedAt: now.subtract(const Duration(days: 2)),
      ),
      DocumentItem(
        id: 'doc_standard_1',
        fileName: 'Appointed_Person_Lifting.pdf',
        extension: 'PDF',
        sizeString: '4.8 MB',
        description: 'Site Appointed Person Lifting Operations Standards & Safety Protocols',
        isReferenceStandard: true,
        uploadedAt: now.subtract(const Duration(days: 10)),
      ),
      DocumentItem(
        id: 'doc_standard_2',
        fileName: 'ASME_B30_Mobile_Cranes_2024.pdf',
        extension: 'PDF',
        sizeString: '12.4 MB',
        description: 'ASME B30.5 Mobile and Locomotive Cranes Safety Standard',
        isReferenceStandard: true,
        uploadedAt: now.subtract(const Duration(days: 14)),
      ),
      DocumentItem(
        id: 'doc_standard_3',
        fileName: 'OSHA_1926_Rigging_Standard.pdf',
        extension: 'PDF',
        sizeString: '3.2 MB',
        description:
            'OSHA 1926.1400 & 1926.251 Rigging Equipment for Material Handling',
        isReferenceStandard: true,
        uploadedAt: now.subtract(const Duration(days: 20)),
      ),
    ];
  }

  static List<DocumentItem> getLiftPlanDocuments() {
    final now = DateTime.now();
    return [
      DocumentItem(
        id: 'doc_plan_frame435',
        fileName: 'Frame 435 (1).pdf',
        extension: 'PDF',
        sizeString: '7.4 MB',
        description: 'CAD Rigging Drawing & Heavy Lift Plan Sequence Frame 435',
        isReferenceStandard: false,
        uploadedAt: now.subtract(const Duration(days: 1)),
      ),
      DocumentItem(
        id: 'doc_plan_1',
        fileName: 'Lifting_Equip_Protocol.pdf',
        extension: 'PDF',
        sizeString: '6.1 MB',
        description: 'Critical 150-Ton Tandem Vessel Lift Sequence & Rigging Calculation Sheet Rev B',
        isReferenceStandard: false,
        uploadedAt: now.subtract(const Duration(days: 2)),
      ),
      DocumentItem(
        id: 'doc_plan_2',
        fileName: 'Steel_Girder_Dual_Pick_Plan.pdf',
        extension: 'PDF',
        sizeString: '8.3 MB',
        description: 'Dual Crane Girder Placement & Ground Loading Calculation',
        isReferenceStandard: false,
        uploadedAt: now.subtract(const Duration(days: 4)),
      ),
      DocumentItem(
        id: 'doc_plan_3',
        fileName: 'Substation_Module_Rigging_Drawing.dwg.pdf',
        extension: 'PDF',
        sizeString: '5.6 MB',
        description: 'CAD Rigging Drawing & Sling Geometry Detail Set',
        isReferenceStandard: false,
        uploadedAt: now.subtract(const Duration(days: 6)),
      ),
    ];
  }

  static AnalysisReport createDefaultReport({
    required String projectId,
    required String projectName,
    required String referenceFileName,
    required String liftPlanFileName,
  }) {
    return AnalysisReport(
      id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
      projectId: projectId,
      projectName: projectName,
      generatedAt: DateTime(2026, 10, 23, 10, 18),
      referenceFileName: referenceFileName,
      liftPlanFileName: liftPlanFileName,
      purpose: 'Verify crane configuration, rigging load factors, ground bearing calculations, and certified personnel compliance against appointed person standards.',
      summaryText: 'The lift plan mostly aligns with the site standard, but two critical safety deviations were identified that require qualified engineering review before lift execution:',
      summaryBullets: [
        'Crane capacity margin at maximum radius (32m) is calculated at 88.5%, exceeding the critical lift 85% limit in the Reference Standard.',
        'Rigging sling angle check indicates 45-degree bridle hitch without sling derating calculation on page 8.',
      ],
      safetyImpactNote: 'Potential safety impact: Crane 1 exceeds critical lift capacity by 3.5% and rigging tension is underestimated by 29.3% due to missing sling angle derating. These parameters must be corrected before crane setup.',
      findings: const [
        FindingItem(
          topic: 'Crane Capacity Limit',
          referenceStandardSpec:
              'Max 85% for Critical Lifts (ASME B30.5 §5-1.1)',
          liftPlanSpec: '88.5% calculated at 32m radius',
          result: 'Deviation: 3.5% over critical threshold',
          status: FindingStatus.deviation,
          referenceCitation: 'Reference standard: Max 85% — Section 4.2 "Critical Lift Protocols"',
          liftPlanCitation:
              'Lift plan: 88.5% — Sheet 3 "Crane Load Chart & Radius"',
          differenceExplanation:
              'Difference: +3.5% over allowable critical threshold',
          whatToCheck: 'Whether counterweight can be increased or working radius reduced from 32m to 29.5m to achieve 81.5% capacity.',
        ),
        FindingItem(
          topic: 'Sling Angle & Deration',
          referenceStandardSpec:
              'Min 60° or derating factor applied (OSHA 1926.251)',
          liftPlanSpec: '45° bridle hitch specified, no derate factor',
          result: 'Non-compliant: 0.707 derate required',
          status: FindingStatus.omission,
          referenceCitation: 'Reference standard: OSHA 1926.251 Table H-1 — page 12 "Sling Angles"',
          liftPlanCitation:
              'Lift plan: 45° angle noted on rigging drawing detail B, sheet 8',
          differenceExplanation: 'Difference: Sling capacity derated by 29.3% not factored into WLL safety factor',
          whatToCheck: 'Whether longer slings or a wider spreader beam can be deployed to achieve a 60° minimum horizontal sling angle.',
        ),
        FindingItem(
          topic: 'Ground Bearing Pressure',
          referenceStandardSpec: 'Max 220 kPa on prepared timber mat',
          liftPlanSpec: '185 kPa with 4x outrigger mats',
          result: 'Match',
          status: FindingStatus.match,
          referenceCitation:
              'Reference standard: Geotechnical assessment report GT-2026-08',
          liftPlanCitation:
              'Lift plan: Sheet 5 "Outrigger Matting & Ground Bearing Layout"',
          differenceExplanation:
              'Margin: 35 kPa below maximum allowable ground pressure',
          whatToCheck: 'Confirm ground mat placement matches survey grid before outrigger extension.',
        ),
        FindingItem(
          topic: 'Appointed Person Sign-off',
          referenceStandardSpec: 'Named AP with Level 3 CPCS/NCCCO cert',
          liftPlanSpec: 'No matching line found',
          result: 'Possible omission',
          status: FindingStatus.omission,
          referenceCitation: 'Reference standard: Section 1.4 "Personnel Competency & Sign-offs"',
          liftPlanCitation: 'Lift plan: Approval block unpopulated on Sheet 1',
          differenceExplanation:
              'Missing certified Appointed Person signature endorsement',
          whatToCheck: 'Obtain formal endorsement from site Appointed Person prior to lift permit issuance.',
        ),
        FindingItem(
          topic: 'Wind Speed Threshold',
          referenceStandardSpec: 'Max 9.8 m/s (22 mph) for tandem picks',
          liftPlanSpec: '10.0 m/s site general limit',
          result: 'Difference: site limit is 0.2 m/s higher',
          status: FindingStatus.deviation,
          referenceCitation:
              'Reference standard: Section 5.3 "Meteorological Constraints"',
          liftPlanCitation:
              'Lift plan: Section 2.1 "General Environmental Operating Limits"',
          differenceExplanation:
              'Site general limit is 0.2 m/s higher than tandem pick standard',
          whatToCheck: 'Update lift plan Section 2.1 to reflect strict 9.8 m/s cutoff with continuous anemometer monitoring.',
        ),
      ],
      suggestedNextSteps: const [
        'Confirm the crane counterweight and radius calculation with the Lead Rigging Engineer.',
        'Update rigging drawing detail B to include the 0.707 sling derating factor or lengthen slings to 60°.',
        'Have the appointed person verify ground conditions and sign Sheet 1 of the lift plan.',
        'Adjust wind speed threshold to 9.8 m/s in the site lift permit documentation.',
      ],
      scopeAndNotes: 'I compared the crane configuration, radius margins, sling geometries, outrigger matting, and personnel certifications against the reference standard. Citations refer to specific document pages, sheet drawings, and chart cells. If a CAD drawing or scan was ambiguous, it is flagged for engineering inspection rather than assumed.',
    );
  }

  static List<DiscussionMessage> getInitialDiscussion() {
    return [
      DiscussionMessage(
        id: 'msg_1',
        senderName: 'Divya',
        senderRole: 'Senior Crane & Rigging Specialist',
        text: 'Hello! I reviewed the 88.5% capacity calculation on Crane 1. If we reposition the crane center of rotation 1.8m closer to the vessel pad, capacity drops to 81.2%, which satisfies ASME B30 critical limits. Let me know if you would like me to stamp the revised drawing.',
        timestamp: DateTime(2026, 10, 23, 10, 22),
        isFromEngineer: true,
      ),
    ];
  }
}
