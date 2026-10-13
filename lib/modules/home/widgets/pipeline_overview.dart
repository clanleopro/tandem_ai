import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PipelineOverview extends StatelessWidget {
  const PipelineOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Automated Compliance Architecture',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Engineered pipeline for cross-referencing heavy lift rigging calculations against statutory standards',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 800;
            if (isCompact) {
              return Column(
                children: const [
                  _PipelineCard(
                    step: '01',
                    title: 'Standards Clause Parsing',
                    description: 'Extracts regulatory safety factors, minimum sling angle thresholds, and D/d curvature requirements from ASME, OSHA, and LOLER.',
                    icon: Icons.rule_folder_outlined,
                  ),
                  SizedBox(height: 12),
                  _PipelineCard(
                    step: '02',
                    title: 'Geometry & Tension Engine',
                    description: 'Analyzes sling bridle angles, calculates factored leg tension T = W / (N · sin θ), and evaluates dynamic amplification (DAF).',
                    icon: Icons.calculate_outlined,
                  ),
                  SizedBox(height: 12),
                  _PipelineCard(
                    step: '03',
                    title: 'Interactive AI Auditor',
                    description: 'Flags geometric discrepancies, Crosby shackle pin/bow sizing violations, and generates PE-certified rework directives.',
                    icon: Icons.psychology_outlined,
                  ),
                ],
              );
            }

            return Row(
              children: const [
                Expanded(
                  child: _PipelineCard(
                    step: '01',
                    title: 'Standards Clause Parsing',
                    description: 'Extracts regulatory safety factors, minimum sling angle thresholds, and D/d curvature requirements from ASME, OSHA, and LOLER.',
                    icon: Icons.rule_folder_outlined,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: _PipelineCard(
                    step: '02',
                    title: 'Geometry & Tension Engine',
                    description: 'Analyzes sling bridle angles, calculates factored leg tension T = W / (N · sin θ), and evaluates dynamic amplification (DAF).',
                    icon: Icons.calculate_outlined,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: _PipelineCard(
                    step: '03',
                    title: 'Interactive AI Auditor',
                    description: 'Flags geometric discrepancies, Crosby shackle pin/bow sizing violations, and generates PE-certified rework directives.',
                    icon: Icons.psychology_outlined,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PipelineCard extends StatelessWidget {
  final String step;
  final String title;
  final String description;
  final IconData icon;

  const _PipelineCard({
    required this.step,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Icon(icon, size: 18, color: AppTheme.accentRed),
              ),
              const Spacer(),
              Text(
                step,
                style: AppTheme.monoStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}
