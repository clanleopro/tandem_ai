import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/document_item.dart';

class DocumentDropdown extends StatelessWidget {
  final String hint;
  final List<DocumentItem> documents;
  final DocumentItem? selectedDocument;
  final ValueChanged<DocumentItem?> onSelected;

  const DocumentDropdown({
    super.key,
    required this.hint,
    required this.documents,
    required this.selectedDocument,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DocumentItem>(
          isExpanded: true,
          value: documents.contains(selectedDocument) ? selectedDocument : null,
          hint: Text(
            hint,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textPrimary,
            size: 22,
          ),
          items: documents.map((document) {
            return DropdownMenuItem<DocumentItem>(
              value: document,
              child: Text(
                document.fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: onSelected,
        ),
      ),
    );
  }
}
