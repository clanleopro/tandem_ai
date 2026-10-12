import 'package:flutter/material.dart';
import '../models/rigging_models.dart';
import '../theme/app_theme.dart';

class StandardsVaultDialog extends StatefulWidget {
  final List<RiggingStandard> standards;
  final Function(RiggingStandard) onStandardAdded;
  final Function(RiggingStandard) onSelectStandard;

  const StandardsVaultDialog({
    super.key,
    required this.standards,
    required this.onStandardAdded,
    required this.onSelectStandard,
  });

  @override
  State<StandardsVaultDialog> createState() => _StandardsVaultDialogState();
}

class _StandardsVaultDialogState extends State<StandardsVaultDialog> {
  bool _isUploadingNew = false;
  String _searchQuery = '';

  // Form fields for new standard upload
  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _orgController = TextEditingController();
  final _summaryController = TextEditingController();
  String _selectedCategory = 'Slings & Hardware';
  String? _uploadedFileName;

  final List<String> _categories = [
    'Slings & Hardware',
    'Mobile Crane Operations',
    'Heavy Lift Management',
    'Offshore & Marine Rigging',
    'General Rigging & Derrick',
  ];

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _orgController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  void _handleUploadSimulation() {
    setState(() {
      _uploadedFileName = 'STD_${_codeController.text.isNotEmpty ? _codeController.text.replaceAll(' ', '_') : "NEW_STANDARD"}_Spec.pdf';
    });
  }

  void _saveNewStandard() {
    if (_codeController.text.trim().isEmpty || _titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both Standard Code and Standard Title'),
          backgroundColor: AppTheme.redViolation,
        ),
      );
      return;
    }

    final newStandard = RiggingStandard(
      id: 'std_${DateTime.now().millisecondsSinceEpoch}',
      code: _codeController.text.trim(),
      title: _titleController.text.trim(),
      category: _selectedCategory,
      organization: _orgController.text.trim().isNotEmpty
          ? _orgController.text.trim()
          : 'Corporate Engineering Standards Council',
      clausesCount: 120,
      uploadedAt: 'Just now',
      fileSize: '15.4 MB',
      keyRequirementsSummary: _summaryController.text.trim().isNotEmpty
          ? _summaryController.text.trim()
          : 'Strict adherence to design safety factors, load angles, certified rigging hardware, and periodic verification protocols.',
      tags: [_codeController.text.trim().split(' ').first, 'Custom Standard', 'Rigging Spec'],
      isDefault: false,
    );

    widget.onStandardAdded(newStandard);
    setState(() {
      _isUploadingNew = false;
      _uploadedFileName = null;
      _codeController.clear();
      _titleController.clear();
      _orgController.clear();
      _summaryController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Standard "${newStandard.code}" registered successfully into vault!'),
        backgroundColor: AppTheme.greenCompliant,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.standards.where((s) {
      final q = _searchQuery.toLowerCase();
      return s.code.toLowerCase().contains(q) ||
          s.title.toLowerCase().contains(q) ||
          s.category.toLowerCase().contains(q);
    }).toList();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 900,
        height: 680,
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.cardBorderGlow, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.7),
              blurRadius: 40,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            // Modal Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppTheme.cardBorder, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.cyanAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.cyanAccent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      color: AppTheme.cyanAccent,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rigging Standards Vault & Library',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Reusable regulatory norms (ASME, OSHA, LOLER, DNV) & company lifting specifications',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Toggle Between List and Upload New
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              color: AppTheme.bgDark.withValues(alpha: 0.6),
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text('Saved Standards (${widget.standards.length})'),
                    selected: !_isUploadingNew,
                    onSelected: (val) => setState(() => _isUploadingNew = false),
                    selectedColor: AppTheme.cyanAccent.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: !_isUploadingNew ? AppTheme.cyanAccent : AppTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                    side: BorderSide(
                      color: !_isUploadingNew ? AppTheme.cyanAccent : AppTheme.cardBorder,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 16),
                        SizedBox(width: 6),
                        Text('Upload New Standard'),
                      ],
                    ),
                    selected: _isUploadingNew,
                    onSelected: (val) => setState(() => _isUploadingNew = true),
                    selectedColor: AppTheme.cyanAccent.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: _isUploadingNew ? AppTheme.cyanAccent : AppTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                    side: BorderSide(
                      color: _isUploadingNew ? AppTheme.cyanAccent : AppTheme.cardBorder,
                    ),
                  ),
                  const Spacer(),
                  if (!_isUploadingNew)
                    SizedBox(
                      width: 240,
                      height: 36,
                      child: TextField(
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search standard...',
                          hintStyle: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                          prefixIcon: const Icon(Icons.search, size: 16, color: AppTheme.textMuted),
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: AppTheme.surfaceDark,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.cardBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.cyanAccent),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: _isUploadingNew ? _buildUploadNewStandardForm() : _buildStandardsList(filtered),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandardsList(List<RiggingStandard> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 48, color: AppTheme.textMuted),
            const SizedBox(height: 12),
            Text(
              'No standards found matching "$_searchQuery"',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(28),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final std = list[index];
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.cyanAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.cyanAccent.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      std.code,
                      style: AppTheme.monoStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.cyanAccent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          std.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${std.organization} • ${std.clausesCount} Verified Clauses • ${std.fileSize}',
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onSelectStandard(std);
                    },
                    icon: const Icon(Icons.check, size: 16, color: Colors.black),
                    label: const Text(
                      'Use For Audit',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.cyanAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                std.keyRequirementsSummary,
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: std.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: Text(
                      '#$tag',
                      style: AppTheme.monoStyle(fontSize: 10, color: AppTheme.textMuted),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadNewStandardForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Register a New Rigging Standard / Regulatory Code',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Upload your official standard PDF or regulatory book. Tandem RigGuard AI will extract clause rules, tables, and safety thresholds.',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),

          // Upload Drop Zone
          InkWell(
            onTap: _handleUploadSimulation,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _uploadedFileName != null ? AppTheme.greenCompliant : AppTheme.cardBorderGlow,
                  width: 1.5,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _uploadedFileName != null ? Icons.task_alt : Icons.cloud_upload_outlined,
                    size: 44,
                    color: _uploadedFileName != null ? AppTheme.greenCompliant : AppTheme.cyanAccent,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _uploadedFileName ?? 'Click to choose Standard Document (.PDF, .DOCX, .ISO, .TXT)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: _uploadedFileName != null ? AppTheme.greenCompliant : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _uploadedFileName != null
                        ? 'Standard file analyzed and parsed into 120 clause schemas.'
                        : 'Supports standard regulatory publications up to 100 MB',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Form fields
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Standard Code * (e.g. ASME B30.26 / ISO 12480)',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _codeController,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'e.g. ASME B30.26-2020',
                        hintStyle: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
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
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Category',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          dropdownColor: AppTheme.surfaceDark,
                          items: _categories.map((c) {
                            return DropdownMenuItem(
                              value: c,
                              child: Text(c, style: const TextStyle(fontSize: 13, color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedCategory = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Standard Full Title *',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              const SizedBox(height: 6),
              TextField(
                controller: _titleController,
                style: const TextStyle(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g. Rigging Hardware: Shackles, Hooks, Rings, and Swivels',
                  hintStyle: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
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

          const SizedBox(height: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Issuing Organization / Authority',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              const SizedBox(height: 6),
              TextField(
                controller: _orgController,
                style: const TextStyle(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g. American Society of Mechanical Engineers (ASME)',
                  hintStyle: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
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

          const SizedBox(height: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Key Safety Rules & Design Thresholds Summary',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              const SizedBox(height: 6),
              TextField(
                controller: _summaryController,
                maxLines: 2,
                style: const TextStyle(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g. 5:1 Design factor, shackle angle derating table, hook throat opening limits...',
                  hintStyle: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
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

          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveNewStandard,
              icon: const Icon(Icons.save, color: Colors.black),
              label: const Text(
                'Save Standard To Company Vault',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cyanAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
