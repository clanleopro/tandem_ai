import 'dart:async';
import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../models/rigging_models.dart';
import '../theme/app_theme.dart';

class AuditWizard extends StatefulWidget {
  final List<RiggingStandard> standards;
  final Function(AuditReport) onAuditComplete;
  final VoidCallback onCancel;
  final VoidCallback onOpenStandardsVault;

  const AuditWizard({
    super.key,
    required this.standards,
    required this.onAuditComplete,
    required this.onCancel,
    required this.onOpenStandardsVault,
  });

  @override
  State<AuditWizard> createState() => _AuditWizardState();
}

class _AuditWizardState extends State<AuditWizard> {
  int _currentStep = 0; // 0: Select Standard, 1: Upload Project File, 2: Verification Scan

  late RiggingStandard _selectedStandard;
  late ProjectFile _selectedProjectFile;

  // Custom upload simulation
  String? _customProjectFileName;
  final _projectNameController = TextEditingController(text: 'Turbine Generator Module 4 - Tandem Placement');
  final _siteLocationController = TextEditingController(text: 'Ras Laffan Petrochem Phase II, Qatar');

  // Scanner state
  bool _isAnalyzing = false;
  double _scanProgress = 0.0;
  String _scanStatusText = 'Initializing Tandem AI Engine...';
  Timer? _scanTimer;

  final List<String> _scanStages = [
    'Parsing Standard Clauses & Regulatory Safety Factors...',
    'Extracting Lift Geometry, Sling Lengths & Horizontal Angles...',
    'Evaluating Leg Tension: T = W / (N * sin θ) against WLL...',
    'Cross-referencing Crosby Hardware D/d Curvature Limits...',
    'Verifying Dynamic Amplification & Outrigger Ground Pressures...',
    'Detecting Discrepancies & Formulating Engineering Rework Directives...',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStandard = widget.standards.first;
    _selectedProjectFile = SampleData.sampleProjectFiles.first;
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    _projectNameController.dispose();
    _siteLocationController.dispose();
    super.dispose();
  }

  void _startAnalysis() {
    setState(() {
      _currentStep = 2;
      _isAnalyzing = true;
      _scanProgress = 0.05;
      _scanStatusText = _scanStages[0];
    });

    int stageIndex = 0;
    _scanTimer = Timer.periodic(const Duration(milliseconds: 650), (timer) {
      setState(() {
        _scanProgress += 0.16;
        if (stageIndex < _scanStages.length) {
          _scanStatusText = _scanStages[stageIndex];
          stageIndex++;
        }

        if (_scanProgress >= 1.0) {
          _scanProgress = 1.0;
          _isAnalyzing = false;
          _scanTimer?.cancel();

          // Generate Report
          final generatedReport = SampleData.createSampleReport();
          widget.onAuditComplete(generatedReport);
        }
      });
    });
  }

  void _simulateCustomFileUpload() {
    setState(() {
      _customProjectFileName = 'Heavy_Turbine_Rigging_LiftPlan_Verified.pdf';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.cardBorderGlow, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wizard Stepper Header
          _buildWizardHeader(),

          const Divider(height: 1, color: AppTheme.cardBorder),

          // Step Body
          Padding(
            padding: const EdgeInsets.all(28),
            child: _buildCurrentStepContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildWizardHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.rocket_launch, color: Colors.black, size: 20),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start New Rigging Verification Audit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Step-by-step workflow: Select Standard → Upload Project Plan → Run AI Verification',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Step indicators
          Row(
            children: [
              _buildStepIndicator(0, '1. Standard', _currentStep >= 0),
              _buildStepDivider(_currentStep >= 1),
              _buildStepIndicator(1, '2. Project File', _currentStep >= 1),
              _buildStepDivider(_currentStep >= 2),
              _buildStepIndicator(2, '3. AI Verify', _currentStep >= 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title, bool isReached) {
    final isCurrent = _currentStep == stepIndex;
    return InkWell(
      onTap: !_isAnalyzing && isReached ? () => setState(() => _currentStep = stepIndex) : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isCurrent
              ? AppTheme.cyanAccent.withValues(alpha: 0.15)
              : (isReached ? AppTheme.surfaceDark : Colors.transparent),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCurrent
                ? AppTheme.cyanAccent
                : (isReached ? AppTheme.cardBorder : AppTheme.dividerColor),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
            color: isCurrent
                ? AppTheme.cyanAccent
                : (isReached ? Colors.white : AppTheme.textMuted),
          ),
        ),
      ),
    );
  }

  Widget _buildStepDivider(bool active) {
    return Container(
      width: 24,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: active ? AppTheme.cyanAccent.withValues(alpha: 0.5) : AppTheme.dividerColor,
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1StandardSelection();
      case 1:
        return _buildStep2ProjectFileUpload();
      case 2:
      default:
        return _buildStep3AnalysisScan();
    }
  }

  // STEP 1: SELECT OR UPLOAD RIGGING STANDARD
  Widget _buildStep1StandardSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stage 1: Select or Upload Rigging Standard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Choose an established regulatory standard or select a custom company specification from your vault.',
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: widget.onOpenStandardsVault,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Register New Standard'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.cyanAccent,
                side: const BorderSide(color: AppTheme.cyanAccent),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Standards Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 450,
            mainAxisExtent: 170,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: widget.standards.length,
          itemBuilder: (context, index) {
            final std = widget.standards[index];
            final isSelected = _selectedStandard.id == std.id;

            return InkWell(
              onTap: () => setState(() => _selectedStandard = std),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.cyanAccent.withValues(alpha: 0.08)
                      : AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppTheme.cyanAccent : AppTheme.cardBorder,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.cyanAccent.withValues(alpha: 0.2),
                            blurRadius: 16,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.cyanAccent
                                : AppTheme.surfaceDark,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            std.code,
                            style: AppTheme.monoStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.black : AppTheme.cyanAccent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceDark,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            std.category,
                            style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isSelected ? AppTheme.cyanAccent : AppTheme.textMuted,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      std.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.rule, size: 14, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${std.clausesCount} Clauses',
                          style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.attach_file, size: 14, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          std.fileSize,
                          style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 28),

        // Bottom Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () => setState(() => _currentStep = 1),
              icon: const Icon(Icons.arrow_forward, color: Colors.black, size: 18),
              label: const Text(
                'Next: Upload Project Plan',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cyanAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // STEP 2: UPLOAD PROJECT PLAN / DRAWING
  Widget _buildStep2ProjectFileUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stage 2: Upload Project Rigging File / Drawing',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Upload your lift plan document, rigging layout CAD drawing, or sling tension calculation sheet for AI verification.',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),

        const SizedBox(height: 24),

        // Project Metadata Row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Project Audit Name', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _projectNameController,
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppTheme.cardDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.cardBorder),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Site Location / Plant Unit', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _siteLocationController,
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppTheme.cardDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.cardBorder),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Drag & Drop Upload Zone
        InkWell(
          onTap: _simulateCustomFileUpload,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _customProjectFileName != null ? AppTheme.greenCompliant : AppTheme.cardBorderGlow,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  _customProjectFileName != null ? Icons.verified : Icons.cloud_upload_outlined,
                  size: 44,
                  color: _customProjectFileName != null ? AppTheme.greenCompliant : AppTheme.cyanAccent,
                ),
                const SizedBox(height: 12),
                Text(
                  _customProjectFileName ?? 'Click to Upload Project Rigging File (.PDF, .DWG, .DXF, .XLSX)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: _customProjectFileName != null ? AppTheme.greenCompliant : Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _customProjectFileName != null
                      ? 'Custom lift plan successfully staged for standard verification.'
                      : 'Drag & drop your multi-page Lift Plan, Rigging Drawing, or Sling Calculation book',
                  style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Or select a pre-staged Industrial Lift Plan benchmark:',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
        ),

        const SizedBox(height: 12),

        // Pre-staged Lift Plans List
        Column(
          children: SampleData.sampleProjectFiles.map((file) {
            final isSelected = _selectedProjectFile.id == file.id && _customProjectFileName == null;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.cyanAccent.withValues(alpha: 0.08) : AppTheme.cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppTheme.cyanAccent : AppTheme.cardBorder,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: ListTile(
                onTap: () {
                  setState(() {
                    _selectedProjectFile = file;
                    _customProjectFileName = null;
                  });
                },
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.picture_as_pdf, color: AppTheme.amberWarning, size: 24),
                ),
                title: Text(
                  file.fileName,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(
                  '${file.liftDescription} • ${file.craneModel}',
                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${file.totalLoadWeightTons} MT Load',
                        style: AppTheme.monoStyle(fontSize: 11, color: AppTheme.cyanAccent, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isSelected ? AppTheme.cyanAccent : AppTheme.textMuted,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () => setState(() => _currentStep = 0),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: const Text('Back to Standard Selection'),
              style: TextButton.styleFrom(foregroundColor: AppTheme.textSecondary),
            ),
            ElevatedButton.icon(
              onPressed: _startAnalysis,
              icon: const Icon(Icons.bolt, color: Colors.black, size: 20),
              label: const Text(
                'Run AI Compliance Verification',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cyanAccent,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 4,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // STEP 3: REAL-TIME VERIFICATION SCAN ANIMATION
  Widget _buildStep3AnalysisScan() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pulse icon
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.cyanAccent.withValues(alpha: 0.4),
                  blurRadius: 32,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.architecture, color: Colors.black, size: 44),
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Verifying Rigging Plan Against Engineering Standard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Standard: ${_selectedStandard.code}',
                style: AppTheme.monoStyle(fontSize: 12, color: AppTheme.cyanAccent),
              ),
              const SizedBox(width: 12),
              const Text('⟷', style: TextStyle(color: AppTheme.textMuted)),
              const SizedBox(width: 12),
              Text(
                'File: ${_customProjectFileName ?? _selectedProjectFile.fileName}',
                style: AppTheme.monoStyle(fontSize: 12, color: AppTheme.amberWarning),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Progress bar
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _scanProgress.clamp(0.0, 1.0),
                    minHeight: 10,
                    backgroundColor: AppTheme.cardDark,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.cyanAccent),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _scanStatusText,
                        style: AppTheme.monoStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      '${(_scanProgress.clamp(0.0, 1.0) * 100).toInt()}%',
                      style: AppTheme.monoStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.cyanAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
