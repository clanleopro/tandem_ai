import 'package:flutter/material.dart';
import '../../data/sample_data.dart';
import '../../models/rigging_models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ai_auditor_console.dart';
import '../../widgets/audit_report_view.dart';
import '../../widgets/audit_wizard.dart';
import '../../widgets/hero_banner.dart';
import '../../widgets/nav_header.dart';
import '../../widgets/projects_history_view.dart';
import '../../widgets/standards_vault_dialog.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _activeTabIndex = 0; // 0: Overview, 1: Audit Studio, 2: AI Auditor Console
  bool _isWizardMode = false;
  String? _directAuditorPrompt;

  // Stored application state
  late List<RiggingStandard> _standards;
  late List<AuditProject> _projects;
  late AuditProject _currentProject;
  AuditReport? _activeReport;
  late List<ChatMessage> _chatHistory;

  @override
  void initState() {
    super.initState();
    _standards = List.from(SampleData.defaultStandards);
    _projects = SampleData.getSampleProjects();
    _currentProject = _projects.first;
    _activeReport = _currentProject.report;
    _chatHistory = List.from(_currentProject.chatHistory);
  }

  void _openStandardsVault() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (context) {
        return StandardsVaultDialog(
          standards: _standards,
          onStandardAdded: (newStd) {
            setState(() {
              _standards.add(newStd);
            });
          },
          onSelectStandard: (selectedStd) {
            setState(() {
              _activeTabIndex = 1;
              _isWizardMode = true;
            });
          },
        );
      },
    );
  }

  void _startNewAuditWizard() {
    setState(() {
      _activeTabIndex = 1;
      _isWizardMode = true;
    });
  }

  void _handleAuditComplete(AuditReport report) {
    setState(() {
      _activeReport = report;
      _isWizardMode = false;
      _currentProject = _currentProject.copyWith(report: report);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Compliance Audit Completed: ${report.overallComplianceScore}% Score (${report.violationsCount} Violations, ${report.warningsCount} Warnings)',
        ),
        backgroundColor: report.violationsCount > 0 ? AppTheme.amberWarning : AppTheme.greenCompliant,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _navigateToAuditorChat(String? clausePrompt) {
    setState(() {
      _activeTabIndex = 2;
      _directAuditorPrompt = clausePrompt;
    });
  }

  void _handleSendMessage(ChatMessage msg) {
    setState(() {
      _chatHistory.add(msg);
    });
  }

  void _handleSelectProject(AuditProject project) {
    setState(() {
      _currentProject = project;
      _activeReport = project.report ?? SampleData.createSampleReport();
      _chatHistory = project.chatHistory.isNotEmpty
          ? List.from(project.chatHistory)
          : SampleData.getInitialAuditorMessages();
      _activeTabIndex = 1;
      _isWizardMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: Column(
        children: [
          // Global Nav Header
          NavHeader(
            activeIndex: _activeTabIndex,
            onTabSelected: (index) {
              setState(() {
                _activeTabIndex = index;
                _directAuditorPrompt = null;
              });
            },
            onStartNewAudit: _startNewAuditWizard,
            onOpenStandardsVault: _openStandardsVault,
          ),

          // Main Scrollable Workspace Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  child: _buildActiveTabContent(),
                ),
              ),
            ),
          ),

          // Engineering Disclaimer Footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_activeTabIndex) {
      case 0:
        return _buildOverviewDashboard();
      case 1:
        return _buildAuditStudioView();
      case 2:
      default:
        return _buildAiAuditorConsoleView();
    }
  }

  // TAB 0: OVERVIEW & PROJECTS DASHBOARD
  Widget _buildOverviewDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero Banner
        HeroBanner(
          onStartProject: _startNewAuditWizard,
          onBrowseStandards: _openStandardsVault,
        ),

        const SizedBox(height: 36),

        // Quick Active Audit Alert Banner (If an audit exists)
        if (_activeReport != null) ...[
          _buildActiveAuditNotice(),
          const SizedBox(height: 36),
        ],

        // Projects History Grid
        ProjectsHistoryView(
          projects: _projects,
          onSelectProject: _handleSelectProject,
          onStartNewProject: _startNewAuditWizard,
        ),

        const SizedBox(height: 36),

        // Standards Repository Spotlight
        _buildStandardsSpotlight(),
      ],
    );
  }

  Widget _buildActiveAuditNotice() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppTheme.accentRed.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentRed.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: const Icon(Icons.warning_amber_rounded, color: AppTheme.accentRed, size: 28),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'ACTIVE AUDIT ALERT • REWORK REQUIRED',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accentRed,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '71% Compliance',
                        style: AppTheme.monoStyle(fontSize: 11, color: AppTheme.amberWarning, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${_activeReport!.projectName} (${_activeReport!.standard.code}) has 2 critical geometric violations: horizontal sling angle at 41.5° & deficient shackle D/d curvature.',
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () => setState(() => _activeTabIndex = 1),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
            ),
            child: const Text(
              'Inspect Report',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: () => _navigateToAuditorChat(null),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.textSecondary,
              side: const BorderSide(color: AppTheme.cardBorderGlow),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
            ),
            child: const Text('Open AI Auditor', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardsSpotlight() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user_outlined, size: 18, color: AppTheme.accentRed),
              const SizedBox(width: 10),
              const Text(
                'Active Standards Vault',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const Spacer(),
              TextButton(
                onPressed: _openStandardsVault,
                child: const Text('Manage All →', style: TextStyle(color: AppTheme.accentRed, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: _standards.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      s.code,
                      style: AppTheme.monoStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${s.clausesCount} cls',
                      style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // TAB 1: AUDIT & VERIFICATION STUDIO
  Widget _buildAuditStudioView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode Header
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rigging Plan Compliance Studio',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isWizardMode
                      ? 'Staging new verification audit: Standard ⟷ Project Lift Plan'
                      : 'Audit Results & Regulatory Discrepancy Findings',
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
              ],
            ),
            const Spacer(),
            if (!_isWizardMode) ...[
              OutlinedButton.icon(
                onPressed: () => setState(() => _isWizardMode = true),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Re-Verify / New Audit'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textSecondary,
                  side: const BorderSide(color: AppTheme.cardBorder),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _navigateToAuditorChat(null),
                icon: const Icon(Icons.terminal_outlined, color: Colors.white, size: 18),
                label: const Text(
                  'Launch AI Auditor Console',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 24),

        // Either Wizard OR Comprehensive Report
        if (_isWizardMode) ...[
          AuditWizard(
            standards: _standards,
            onAuditComplete: _handleAuditComplete,
            onCancel: () => setState(() => _isWizardMode = false),
            onOpenStandardsVault: _openStandardsVault,
          ),
        ] else if (_activeReport != null) ...[
          AuditReportView(
            report: _activeReport!,
            onOpenAuditorChat: _navigateToAuditorChat,
            onReAudit: () => setState(() => _isWizardMode = true),
          ),
        ] else ...[
          Center(
            child: Column(
              children: [
                const Icon(Icons.assignment_outlined, size: 64, color: AppTheme.textMuted),
                const SizedBox(height: 16),
                const Text(
                  'No active audit loaded. Launch verification wizard to begin.',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() => _isWizardMode = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                  ),
                  child: const Text('Launch Verification Wizard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // TAB 2: AI AUDITOR CONSOLE
  Widget _buildAiAuditorConsoleView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Industrial AI Rigging Auditor Studio',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Live engineering dialogue, formula rework, shackle sizing, and compliance clarification',
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
              ],
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => setState(() => _activeTabIndex = 1),
              icon: const Icon(Icons.arrow_back, size: 16, color: AppTheme.textSecondary),
              label: const Text('Back to Audit Report', style: TextStyle(color: AppTheme.textSecondary)),
            ),
          ],
        ),

        const SizedBox(height: 20),

        AiAuditorConsole(
          report: _activeReport,
          chatHistory: _chatHistory,
          onSendMessage: _handleSendMessage,
          initialPrompt: _directAuditorPrompt,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(
          top: BorderSide(color: AppTheme.cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.greenCompliant,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Tandem AI Engine v4.8 • ASME B30.9 / OSHA 1926.1400 / LOLER 1998 Verified',
                style: AppTheme.monoStyle(fontSize: 11, color: AppTheme.textMuted),
              ),
            ],
          ),
          const Spacer(),
          Text(
            'Tandem AI • Precision Lifting Standards Compliance',
            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }
}
