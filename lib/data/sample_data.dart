import '../models/rigging_models.dart';

class SampleData {
  static final List<RiggingStandard> defaultStandards = [
    const RiggingStandard(
      id: 'std_asme_b30_9',
      code: 'ASME B30.9-2021',
      title: 'Slings & Bridle Assemblies (Wire Rope, Synthetic, Chain)',
      category: 'Slings & Hardware',
      organization: 'American Society of Mechanical Engineers',
      clausesCount: 148,
      uploadedAt: 'Oct 04, 2026',
      fileSize: '14.2 MB',
      keyRequirementsSummary:
          'Mandates minimum 5:1 design safety factor, limits sling angles below 45°, specifies D/d thimble ratios, dynamic de-rating, and proof load certification requirements.',
      tags: ['ASME', 'Bridle Rigging', 'Slings', 'Safety Factor 5:1', 'WLL Tables'],
      isDefault: true,
    ),
    const RiggingStandard(
      id: 'std_osha_1926_1400',
      code: 'OSHA 1926.1400',
      title: 'Cranes and Derricks in Construction & Rigging Verification',
      category: 'Mobile Crane Operations',
      organization: 'Occupational Safety and Health Administration (US)',
      clausesCount: 215,
      uploadedAt: 'Sep 28, 2026',
      fileSize: '18.7 MB',
      keyRequirementsSummary:
          'Defines critical lift thresholds (>75% crane chart), ground bearing pressure verifications, tandem crane synchronization, and tag line safety procedures.',
      tags: ['OSHA', 'Crane Safety', 'Critical Lift >75%', 'Ground Pressure'],
      isDefault: true,
    ),
    const RiggingStandard(
      id: 'std_loler_1998',
      code: 'LOLER 1998 / BS 7121',
      title: 'Lifting Operations & Safe Use of Cranes (UK HSE Standard)',
      category: 'Heavy Lift Management',
      organization: 'Health and Safety Executive (UK)',
      clausesCount: 182,
      uploadedAt: 'Sep 15, 2026',
      fileSize: '11.8 MB',
      keyRequirementsSummary:
          'Regulation 8 lift planning rules, appointed person oversight, thorough examination certificates, and environmental wind limit governance.',
      tags: ['LOLER', 'Appointed Person', 'HSE', 'Lift Plan Reg 8'],
      isDefault: true,
    ),
    const RiggingStandard(
      id: 'std_dnv_st_n001',
      code: 'DNV-ST-N001',
      title: 'Marine Operations and Offshore Heavy Lifting Standard',
      category: 'Offshore & Marine Rigging',
      organization: 'Det Norske Veritas (DNV)',
      clausesCount: 320,
      uploadedAt: 'Aug 19, 2026',
      fileSize: '24.5 MB',
      keyRequirementsSummary:
          'Governs Dynamic Amplification Factors (DAF), skew load distribution for 4-point lifts, dual-crane offshore tandem operations, and sea-fastening checks.',
      tags: ['DNV', 'Offshore Heavy Lift', 'DAF Factors', 'Spreader Beams'],
      isDefault: true,
    ),
    const RiggingStandard(
      id: 'std_api_rp_2d',
      code: 'API RP 2D (7th Edition)',
      title: 'Operation and Maintenance of Offshore Pedestal Cranes',
      category: 'Offshore Pedestal Cranes',
      organization: 'American Petroleum Institute',
      clausesCount: 164,
      uploadedAt: 'Jul 10, 2026',
      fileSize: '16.0 MB',
      keyRequirementsSummary:
          'Specifies supply vessel offloading dynamic factors, personnel basket safety, wire rope retirement criteria, and hook throat opening tolerances.',
      tags: ['API', 'Offshore Cranes', 'Wire Rope Retirement', 'Pedestal'],
      isDefault: true,
    ),
  ];

  static final List<ProjectFile> sampleProjectFiles = [
    const ProjectFile(
      id: 'file_proj_01',
      fileName: 'Turbine_Module_Tandem_Lift_Plan_RevC.pdf',
      liftDescription:
          'Tandem crane lift and placement of 64.2 MT Gas Turbine Module onto foundation plinth.',
      craneModel: 'Liebherr LTM 1500-8.1 (500t) + Tadano ATF 400G-6 (400t)',
      totalLoadWeightTons: 64.2,
      slingConfiguration: '4-Leg Wire Rope Bridle with 35t Crosby G-2130 Shackles',
      engineerInCharge: 'Er. Rajesh Menon, Lead Rigging Specialist',
      revision: 'Rev C - Issued for Verification',
      uploadedAt: 'Today at 10:14 AM',
      fileSize: '8.4 MB (Vector CAD & Calculation Book)',
    ),
    const ProjectFile(
      id: 'file_proj_02',
      fileName: 'Subsea_Manifold_4Leg_Bridle_Rigging.dwg',
      liftDescription:
          'Deployment of 38.5 MT Subsea Manifold through splash zone from HLV Deck.',
      craneModel: 'Huisman 800MT Pedestal Offshore Crane',
      totalLoadWeightTons: 38.5,
      slingConfiguration: 'Equalized 4-Leg Grommet Slings + Spreader Beam',
      engineerInCharge: 'Capt. David Alistair, Marine Rigging Lead',
      revision: 'Rev 02 - Pre-Execution Draft',
      uploadedAt: 'Yesterday at 04:30 PM',
      fileSize: '19.2 MB',
    ),
    const ProjectFile(
      id: 'file_proj_03',
      fileName: 'Cracking_Column_Tail_Erection_Calc.xlsx',
      liftDescription:
          'Heavy industrial vessel upending: Main boom lift 112 MT + Tail frame crane.',
      craneModel: 'Demag CC 2800-1 (600t Crawler)',
      totalLoadWeightTons: 112.0,
      slingConfiguration: 'Trunnion Rigging with 120t Wide-Body Shackles',
      engineerInCharge: 'Anand K. Varma, Structural Lifting Engineer',
      revision: 'Rev D - Engineering Review',
      uploadedAt: '3 days ago',
      fileSize: '5.1 MB',
    ),
  ];

  static List<AuditFinding> createFindingsForTurbine() {
    return [
      const AuditFinding(
        id: 'fnd_01',
        clauseRef: 'ASME B30.9-1.5.3(c) & Table 9-1.2',
        clauseTitle: 'Horizontal Sling Angle Restriction (< 45° Violation)',
        standardRequirement:
          'Horizontal sling angle shall NEVER be less than 30°, and for multi-leg bridles without equalizers, angles below 45° require formal derating with written engineering justification. Mandatory minimum design safety factor is 5.0.',
        projectFinding:
          'In Drawing DWG-TK-04 Sheet 2, the lower bridle horizontal sling angle is indicated at 41.5° (Tension Factor 1.514x).',
        status: FindingStatus.violation,
        severity: FindingSeverity.critical,
        category: 'Rigging Geometry & Sling Angles',
        technicalExplanation:
          'At 41.5°, each sling leg experiences 24.3 MT of dynamic tension. The specified 32mm IWRC 6x36 wire rope has an effective WLL of only 20.8 MT at this inclination, resulting in a 16.8% over-tension condition.',
        requiredRemedy:
          'Increase bridle sling length from 6.0m to 8.2m to achieve an angle of ≥ 60° (reducing tension factor to 1.155x), or integrate a transverse spreader beam.',
        engineeringCalculation:
          'T_leg = W / (N × sin θ) = 64.2t / (4 × sin(41.5°)) = 24.27 MT > 20.8 MT WLL limit (SF dropped to 4.28:1 vs 5:1 required).',
      ),
      const AuditFinding(
        id: 'fnd_02',
        clauseRef: 'ASME B30.26 Section 26-1.5.1',
        clauseTitle: 'Shackle Pin / Bow D/d Curvature Ratio Deficit',
        standardRequirement:
          'When wire rope slings with soft eyes or Flemish eyes without thimbles rest on shackle pins, the D/d curvature ratio must be maintained according to manufacturer specifications to avoid rope strand crushing.',
        projectFinding:
          'Bill of Materials specifies 35t Crosby G-2130 bow shackles connected directly over bare 32mm eye without heavy-duty protective thimbles.',
        status: FindingStatus.violation,
        severity: FindingSeverity.critical,
        category: 'Hardware & Shackle Ratings',
        technicalExplanation:
          'The pin diameter of 38mm on the 35t shackle yields a D/d ratio of 1.18. ASME B30.9 mandates D/d ≥ 1.5 unless a 15% reduction in breaking strength is applied to the sling rating.',
        requiredRemedy:
          'Specify Crosby G-2140 Alloy Bolt-Type Wide-Body Shackles or insert Crosby S-412 heavy-duty wire rope thimbles in the eye splice.',
        engineeringCalculation:
          'D/d = 38mm / 32mm = 1.187 < 1.50 threshold. De-rating factor of 0.85 must be applied if thimble is omitted.',
      ),
      const AuditFinding(
        id: 'fnd_03',
        clauseRef: 'OSHA 1926.1400 / DNV-ST-N001 Sec 5.2',
        clauseTitle: 'Dynamic Amplification Factor (DAF) Underestimation',
        standardRequirement:
          'For onshore crane tandem lifts where load sharing fluctuates during slewing, standard specifies minimum DAF of 1.15 and Skew Load Factor (SKL) of 1.25 for 4-point non-coplanar lifts.',
        projectFinding:
          'Lift Plan calculation utilizes static weight only (DAF = 1.00) without accounting for wind gust dynamics or tandem out-of-sync deflection.',
        status: FindingStatus.violation,
        severity: FindingSeverity.high,
        category: 'Dynamic & Load Distribution Factors',
        technicalExplanation:
          'A static 64.2 MT lift under tandem hoisting requires factored gross dynamic weight calculation: 64.2 MT × 1.15 DAF = 73.83 MT gross crane load.',
        requiredRemedy:
          'Update calculation sheet with 1.15 DAF. Re-verify crane radius chart for Crane 2 at 18.0m radius.',
        engineeringCalculation:
          'Factored Gross Load = (64.2t × 1.15) + Rigging Gear (3.4t) = 77.23 MT.',
      ),
      const AuditFinding(
        id: 'fnd_04',
        clauseRef: 'OSHA 1926.1402 & CIRIA C703',
        clauseTitle: 'Ground Bearing Pressure (GBP) Outrigger Margin Warning',
        standardRequirement:
          'Crane outrigger mats must provide a minimum safety margin of 1.25x against verified geotechnical permissible ground bearing capacity.',
        projectFinding:
          'Maximum calculated outrigger reaction is 275 kPa on 3.0m x 2.0m steel mats. Site soil report specifies allowable limit of 290 kPa (Margin: 5.4%).',
        status: FindingStatus.warning,
        severity: FindingSeverity.medium,
        category: 'Geotechnical & Mat Safety',
        technicalExplanation:
          '5.4% margin is below the recommended 25% safety buffer for critical tandem industrial lifts, especially if uncompacted backfill exists near plinth perimeter.',
        requiredRemedy:
          'Upsize crane outrigger foundation mats to 4.0m x 2.4m hardwood timber mat assemblies to distribute pressure down to 185 kPa.',
        engineeringCalculation:
          'Current P_max = 275 kPa / 290 kPa allowable = 94.8% utilization (Recommended max: 80%).',
      ),
      const AuditFinding(
        id: 'fnd_05',
        clauseRef: 'ASME B30.5 Section 5-3.2.1.5',
        clauseTitle: 'Tandem Crane Capacity Threshold Warning',
        standardRequirement:
          'Neither crane in a multi-crane tandem lift shall exceed 75% of rated net capacity as per manufacturer load chart at the maximum working radius.',
        projectFinding:
          'Crane 2 (Tadano ATF 400G) operates at 73.8% rated capacity at 18.2m working radius with 42m boom.',
        status: FindingStatus.warning,
        severity: FindingSeverity.medium,
        category: 'Crane Load Charts',
        technicalExplanation:
          'While 73.8% is technically below the 75% hard ceiling, any wind gust above 8.5 m/s or minor slew tilt will push Crane 2 into critical shutdown threshold.',
        requiredRemedy:
          'Pull Crane 2 setup pad 1.5m closer to reduce operating radius to 16.7m (bringing chart utilization down to 66.5%).',
        engineeringCalculation:
          'Rated Cap at 18.2m = 48.0 MT. Applied Load = 35.4 MT -> Utilization = 73.75%.',
      ),
      const AuditFinding(
        id: 'fnd_06',
        clauseRef: 'ASME B30.9-1.7.1',
        clauseTitle: 'Sling Identification & Mill Proof-Test Traceability',
        standardRequirement:
          'Each wire rope sling shall have a permanent metal tag indicating manufacturer, rated load by hitch, diameter, and proof test serial number.',
        projectFinding:
          'All four 32mm slings listed in Rigging Schedule Sheet 4 have verified mill test certificates (Certs: MTC-8891-A through D) and RFID tag numbers.',
        status: FindingStatus.compliant,
        severity: FindingSeverity.low,
        category: 'Tagging & Documentation',
        technicalExplanation:
          'Proof test certificates verified at 2.0x WLL with third-party Lloyd’s Register endorsement dated within the past 12 months.',
        requiredRemedy: 'Complies with standard. Maintain certificates on site during lift.',
        engineeringCalculation: 'Tested Proof Load: 41.6 MT per leg (2.0x WLL). Verified.',
      ),
      const AuditFinding(
        id: 'fnd_07',
        clauseRef: 'LOLER 1998 Regulation 8 / BS 7121',
        clauseTitle: 'Appointed Person & Lift Supervisor Role Definition',
        standardRequirement:
          'A clearly defined Appointed Person (Lifting), Lift Supervisor, and qualified Rigging Signalman with single-channel VHF radio must be appointed.',
        projectFinding:
          'Section 1.2 of Lift Plan designates certified Appointed Person (Er. Rajesh Menon) and dedicated banksman with dedicated 446 MHz VHF frequency.',
        status: FindingStatus.compliant,
        severity: FindingSeverity.low,
        category: 'Personnel & Supervision',
        technicalExplanation: 'Full compliance with role governance and communication protocols.',
        requiredRemedy: 'Complies with standard.',
        engineeringCalculation: null,
      ),
      const AuditFinding(
        id: 'fnd_08',
        clauseRef: 'ASME B30.5-3.4.5',
        clauseTitle: 'Environmental Wind Speed Cut-Off Protocols',
        standardRequirement:
          'Permissible operating wind velocity shall be calculated accounting for load sail area and boom tip anemometer placement.',
        projectFinding:
          'Lift plan sets strict 9.8 m/s (19 knots) shut-off limit with dual calibrated anemometers, matching manufacturer crane table guidelines.',
        status: FindingStatus.compliant,
        severity: FindingSeverity.low,
        category: 'Environmental Limits',
        technicalExplanation: 'Proper sail area aerodynamic drag factor of 1.32 applied to turbine cowl.',
        requiredRemedy: 'Complies with standard.',
        engineeringCalculation: 'Max Wind Sail Force: 4.8 kN at 9.8 m/s within outrigger lateral tolerance.',
      ),
    ];
  }

  static AuditReport createSampleReport() {
    final findings = createFindingsForTurbine();
    return AuditReport(
      id: 'rep_turbine_01',
      projectId: 'proj_01',
      projectName: 'Turbine Generator Module 4 - Tandem Placement',
      standard: defaultStandards[0], // ASME B30.9
      projectFile: sampleProjectFiles[0],
      auditedAt: DateTime.now().subtract(const Duration(minutes: 18)),
      overallComplianceScore: 71,
      violationsCount: 3,
      warningsCount: 2,
      compliantCount: 3,
      executiveSummary:
          'AI Rigging Audit completed across 8 rigorous clauses. The project contains 2 CRITICAL GEOMETRY VIOLATIONS (sling angle < 45° resulting in 16.8% over-tension, and deficient D/d shackle ratio), plus 1 Dynamic Factor omission. Rework is required prior to lifting permit issuance.',
      findings: findings,
      liftMetrics: {
        'totalGrossWeight': '67.6 MT (Incl. Rigging)',
        'minSlingAngle': '41.5° (FAILED: Required ≥ 60°)',
        'maxLegTension': '24.27 MT (FAILED: WLL 20.8 MT)',
        'designSafetyFactor': '4.28 : 1 (FAILED: Required 5.0 : 1)',
        'crane1Utilization': '71.2% (Liebherr 500t)',
        'crane2Utilization': '73.8% (Tadano 400t)',
        'groundPressureMax': '275 kPa (Margin: 5.4%)',
        'windLimit': '9.8 m/s (19.0 Knots)',
      },
    );
  }

  static List<ChatMessage> getInitialAuditorMessages() {
    return [
      ChatMessage(
        id: 'msg_01',
        sender: 'auditor',
        text:
            'Welcome to the **Tandem RigGuard AI Auditor Studio**. I have analyzed **Turbine_Module_Tandem_Lift_Plan_RevC.pdf** against **ASME B30.9-2021**.\n\n'
            '⚠️ **Audit Summary**: 2 Critical Violations, 1 High Severity, 2 Warnings detected.\n'
            'The primary failure is the **41.5° sling angle** on the lower bridle assembly, driving tension up to **24.27 MT** against a **20.8 MT WLL** limit.\n\n'
            'How would you like to proceed with the engineering rework?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        quickActionPrompts: [
          'Recalculate with 60° Sling Angle',
          'Sizing Crosby G-2140 Wide-Body Shackles',
          'Check Spreader Beam alternative',
          'Generate Lift Plan Rework Sheet',
        ],
        codeSnippetOrFormula:
            '// Current Deficient Tension:\nT = 64.2t / (4 * sin(41.5°)) = 24.27 MT per leg (Over WLL by 16.8%)\n\n// Target with 60°:\nT = 64.2t / (4 * sin(60.0°)) = 18.53 MT per leg (WLL Margin +11.2% Safe!)',
        linkedFindingClause: 'ASME B30.9-1.5.3(c)',
      ),
    ];
  }

  static List<AuditProject> getSampleProjects() {
    final report1 = createSampleReport();
    return [
      AuditProject(
        id: 'proj_01',
        name: 'Turbine Module 4 - Tandem Plinth Lift',
        siteLocation: 'Ras Laffan Petrochem Phase II, Qatar',
        client: 'Siemens Energy / McDermott',
        standard: defaultStandards[0],
        projectFile: sampleProjectFiles[0],
        report: report1,
        chatHistory: getInitialAuditorMessages(),
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        status: 'Rework Required',
      ),
      AuditProject(
        id: 'proj_02',
        name: 'Subsea Manifold 38t Splash-Zone Deployment',
        siteLocation: 'Offshore Block KG-D6, Deepwater Basin',
        client: 'Reliance Industries / Subsea 7',
        standard: defaultStandards[3], // DNV-ST-N001
        projectFile: sampleProjectFiles[1],
        report: null,
        chatHistory: [],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: 'Audited',
      ),
      AuditProject(
        id: 'proj_03',
        name: 'FCCU Reactor Column 112t Tandem Upending',
        siteLocation: 'Jamnagar Refinery Expansion Unit 3',
        client: 'L&T Heavy Engineering',
        standard: defaultStandards[1], // OSHA 1926.1400
        projectFile: sampleProjectFiles[2],
        report: null,
        chatHistory: [],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        status: 'Approved',
      ),
    ];
  }
}
