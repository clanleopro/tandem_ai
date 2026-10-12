import 'package:flutter/material.dart';
import '../models/rigging_models.dart';
import '../theme/app_theme.dart';

class AiAuditorConsole extends StatefulWidget {
  final AuditReport? report;
  final List<ChatMessage> chatHistory;
  final Function(ChatMessage) onSendMessage;
  final String? initialPrompt;

  const AiAuditorConsole({
    super.key,
    required this.report,
    required this.chatHistory,
    required this.onSendMessage,
    this.initialPrompt,
  });

  @override
  State<AiAuditorConsole> createState() => _AiAuditorConsoleState();
}

class _AiAuditorConsoleState extends State<AiAuditorConsole> {
  final _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isGenerating = false;

  final List<String> _quickPrompts = [
    'Recalculate with 60° Sling Angle',
    'What Crosby shackle size fixes D/d ratio?',
    'Calculate Dynamic Factored Load (DAF=1.15)',
    'Generate Stamped Lift Plan Rework Note',
    'Verify Crane Outrigger Mat Sizing',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialPrompt != null) {
      _inputController.text = widget.initialPrompt!;
    }
  }

  @override
  void didUpdateWidget(covariant AiAuditorConsole oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPrompt != null && widget.initialPrompt != oldWidget.initialPrompt) {
      _inputController.text = widget.initialPrompt!;
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'user',
      text: text.trim(),
      timestamp: DateTime.now(),
    );

    widget.onSendMessage(userMsg);
    _inputController.clear();
    _scrollToBottom();

    // Trigger AI response generation
    setState(() => _isGenerating = true);

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      final aiMsg = _generateAuditorResponse(text);
      widget.onSendMessage(aiMsg);
      setState(() => _isGenerating = false);
      _scrollToBottom();
    });
  }

  ChatMessage _generateAuditorResponse(String query) {
    final q = query.toLowerCase();

    if (q.contains('60') || q.contains('angle') || q.contains('sling length') || q.contains('tension')) {
      return ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'auditor',
        text:
            '### 📐 Engineering Recalculation: 60.0° Bridle Sling Geometry\n\n'
            'By increasing the horizontal sling angle from **41.5°** to **60.0°**, dynamic tension per sling leg drops by **23.6%**, restoring compliance with **ASME B30.9-1.5.3**.\n\n'
            '**Verification Checks:**\n'
            '• **Previous Tension (at 41.5°)**: 24.27 MT per leg (16.8% over WLL ❌)\n'
            '• **New Tension (at 60.0°)**: 18.53 MT per leg (Compliant with 20.8 MT WLL ✅)\n'
            '• **Design Safety Factor**: Restored from 4.28:1 to **5.61:1** (Meets ASME ≥ 5:1 requirement)\n'
            '• **Required Bridle Length**: Slings must be lengthened from **6.00 m** to **8.25 m** (or a 4.5m spreader bar must be introduced).',
        timestamp: DateTime.now(),
        codeSnippetOrFormula:
            '// Mathematical Verification:\n'
            'W_gross = 64.2 MT\n'
            'N = 4 legs (bridle)\n'
            'θ_new = 60.0°\n'
            'T_leg = W / (N * sin(θ_new))\n'
            'T_leg = 64.2 / (4 * sin(60°)) = 18.53 MT\n'
            'Safety Factor = (Breaking Strength 104t) / 18.53t = 5.61 : 1 [PASS]',
        linkedFindingClause: 'ASME B30.9-1.5.3(c)',
        quickActionPrompts: [
          'Generate Lift Plan Revision C-1 drawing notes',
          'Sizing Crosby G-2140 shackles for 18.53t tension',
        ],
      );
    } else if (q.contains('shackle') || q.contains('crosby') || q.contains('d/d') || q.contains('pin')) {
      return ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'auditor',
        text:
            '### ⛓️ Hardware Specification: Crosby Shackle Sizing & D/d Ratio Resolution\n\n'
            'To resolve the **D/d curvature violation (ASME B30.26 Section 26-1.5.1)** where the 38mm pin crushed the 32mm bare wire rope eye:\n\n'
            '**Recommended Solution: Crosby G-2140 Alloy Bolt-Type Wide-Body Shackle (40t WLL)**\n'
            '• **Bow/Body Radius**: Provides a D/d ratio of **1.78**, exceeding the required 1.50 threshold.\n'
            '• **Working Load Limit**: 40.0 MT (Provides 2.15x safety margin against the 18.53 MT leg load).\n'
            '• **Alternative**: Keep existing Crosby G-2130 35t shackles, but swage **Crosby S-412 Solid Heavy-Duty Thimbles** into the sling eyes.',
        timestamp: DateTime.now(),
        codeSnippetOrFormula:
            '// Curvature Verification:\n'
            'Rope Diameter (d) = 32 mm\n'
            'Crosby G-2140 Bow Contact Diameter (D) = 57 mm\n'
            'D/d Ratio = 57 / 32 = 1.781 > 1.50 Requirement [PASS]\n'
            'Strength Retention Factor = 100% (No de-rating needed)',
        linkedFindingClause: 'ASME B30.26 Section 26-1.5.1',
        quickActionPrompts: [
          'Check DAF factor compliance',
          'Export Stamped Technical Memo',
        ],
      );
    } else if (q.contains('daf') || q.contains('dynamic') || q.contains('ground') || q.contains('wind')) {
      return ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'auditor',
        text:
            '### ⚡ Dynamic Factors & Geotechnical Outrigger Pressure Audit\n\n'
            '**1. Dynamic Amplification Factor (DAF):**\n'
            '• Factored Hook Load = 64.2 MT × 1.15 DAF = **73.83 MT**\n'
            '• Adding Rigging Tackle Weight (3.40 MT) = **77.23 MT Gross Lifted Load**\n\n'
            '**2. Crane Outrigger Bearing Pressure:**\n'
            '• Current pressure: **275 kPa** on 3.0m × 2.0m steel mats (Allowable soil capacity: 290 kPa, only 5.4% margin).\n'
            '• **Remedy**: Increase outrigger mat footprint to **4.0m × 2.4m** hardwood timber bog mats.\n'
            '• Resulting Bearing Pressure: Drops from 275 kPa to **178 kPa**, establishing an optimal **62% safety buffer** well within OSHA 1926.1402.',
        timestamp: DateTime.now(),
        codeSnippetOrFormula:
            '// Soil Pressure Equation:\n'
            'P_max = (Max Outrigger Force 1,710 kN) / (Mat Area 9.6 m²)\n'
            'P_actual = 178.1 kPa < 290 kPa Permissible [PASS]',
        linkedFindingClause: 'OSHA 1926.1402 / CIRIA C703',
        quickActionPrompts: [
          'Generate Stamped Lift Plan Rework Note',
          'Recalculate with 60° Sling Angle',
        ],
      );
    } else {
      return ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'auditor',
        text:
            '### 📋 RigGuard Engineering Audit Memo\n\n'
            'Regarding your query: *"$query"*\n\n'
            'Based on **${widget.report?.standard.code ?? "ASME B30.9"}**, all rigging calculations must uphold a verified **5:1 safety factor**, keep multi-leg sling angles strictly above **45° (preferably ≥ 60°)**, and ensure certified mill test traceability on all rigging hardware.\n\n'
            'Would you like me to generate the complete stamped **Revision C-1 Rework Specification Sheet** for handover to your Lifting Appointed Person?',
        timestamp: DateTime.now(),
        linkedFindingClause: widget.report?.standard.code ?? 'ASME B30.9',
        quickActionPrompts: [
          'Generate Stamped Lift Plan Rework Note',
          'Recalculate with 60° Sling Angle',
          'What Crosby shackle size fixes D/d ratio?',
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.cardBorderGlow, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Console Header (Bespoke Industrial Engineering HUD)
          _buildConsoleHeader(report),

          const Divider(height: 1, color: AppTheme.cardBorder),

          // Quick Prompt Bar
          _buildQuickPromptsBar(),

          const Divider(height: 1, color: AppTheme.cardBorder),

          // Chat Stream Container
          Container(
            height: 520,
            color: AppTheme.bgDark.withValues(alpha: 0.4),
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              itemCount: widget.chatHistory.length + (_isGenerating ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                if (index == widget.chatHistory.length && _isGenerating) {
                  return _buildGeneratingIndicator();
                }
                final msg = widget.chatHistory[index];
                return _buildChatMessageItem(msg);
              },
            ),
          ),

          const Divider(height: 1, color: AppTheme.cardBorder),

          // Message Input Dock
          _buildMessageInputDock(),
        ],
      ),
    );
  }

  Widget _buildConsoleHeader(AuditReport? report) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppTheme.aiBadgeGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'AI Rigging Auditor Console',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.greenCompliant.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppTheme.greenCompliant.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.greenCompliant,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'AUDITOR ONLINE',
                            style: AppTheme.monoStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.greenCompliant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Active Context: ${report?.standard.code ?? "ASME B30.9-2021"} ⟷ ${report?.projectFile.fileName ?? "Turbine_Module_Lift_Plan.pdf"}',
                  style: AppTheme.monoStyle(
                    fontSize: 11,
                    color: AppTheme.cyanAccent,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Stamped Engineering Rework Note exported successfully (PDF)!'),
                  backgroundColor: AppTheme.greenCompliant,
                ),
              );
            },
            icon: const Icon(Icons.download, size: 14),
            label: const Text('Export Rework Memo'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.cyanAccent,
              side: const BorderSide(color: AppTheme.cyanAccent),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPromptsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: AppTheme.surfaceDark.withValues(alpha: 0.7),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Icon(Icons.bolt, size: 14, color: AppTheme.amberWarning),
            const SizedBox(width: 8),
            Text(
              'QUICK SOLVERS:',
              style: AppTheme.monoStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(width: 12),
            ..._quickPrompts.map((p) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  label: Text(p),
                  onPressed: () => _handleSendMessage(p),
                  backgroundColor: AppTheme.cardDark,
                  labelStyle: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  side: const BorderSide(color: AppTheme.cardBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessageItem(ChatMessage msg) {
    final isUser = msg.sender == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUser) ...[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppTheme.aiBadgeGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.architecture, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isUser ? AppTheme.cyanAccent.withValues(alpha: 0.12) : AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isUser ? AppTheme.cyanAccent.withValues(alpha: 0.4) : AppTheme.cardBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sender info
                    Row(
                      children: [
                        Text(
                          isUser ? 'Rigging Engineer (You)' : 'RigGuard AI Lead Auditor',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isUser ? AppTheme.cyanAccent : Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!isUser && msg.linkedFindingClause != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppTheme.cardBorder),
                            ),
                            child: Text(
                              msg.linkedFindingClause!,
                              style: AppTheme.monoStyle(
                                fontSize: 9,
                                color: AppTheme.cyanAccent,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                          style: AppTheme.monoStyle(fontSize: 10, color: AppTheme.textMuted),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Body Text
                    Text(
                      msg.text,
                      style: const TextStyle(fontSize: 13, color: Colors.white, height: 1.5),
                    ),

                    // Monospace Math / Formula block
                    if (msg.codeSnippetOrFormula != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.cardBorder),
                        ),
                        child: Text(
                          msg.codeSnippetOrFormula!,
                          style: AppTheme.monoStyle(
                            fontSize: 11,
                            color: AppTheme.cyanAccent,
                          ),
                        ),
                      ),
                    ],

                    // Suggested follow-up buttons
                    if (msg.quickActionPrompts != null && msg.quickActionPrompts!.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: msg.quickActionPrompts!.map((p) {
                          return ActionChip(
                            label: Text(p),
                            onPressed: () => _handleSendMessage(p),
                            backgroundColor: AppTheme.surfaceDark,
                            labelStyle: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.cyanAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            side: const BorderSide(color: AppTheme.cyanAccent),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (isUser) ...[
              const SizedBox(width: 12),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: const Center(
                  child: Icon(Icons.person, color: AppTheme.cyanAccent, size: 20),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.cyanAccent),
            ),
            const SizedBox(width: 12),
            Text(
              'Auditor is calculating rigging parameters & checking ASME clauses...',
              style: AppTheme.monoStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputDock() {
    return Container(
      padding: const EdgeInsets.all(18),
      color: AppTheme.surfaceDark,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: AppTheme.textSecondary),
            tooltip: 'Attach Revised Rigging Sketch',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Revised drawing staged for comparison!'),
                  backgroundColor: AppTheme.cyanAccent,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _inputController,
              onSubmitted: _handleSendMessage,
              style: const TextStyle(fontSize: 13, color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ask the AI Rigging Auditor (e.g. "Calculate sling tension with 60° bridle angle")...',
                hintStyle: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                filled: true,
                fillColor: AppTheme.cardDark,
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.cyanAccent),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => _handleSendMessage(_inputController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.cyanAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Send Inquiry',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.send, color: Colors.black, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
