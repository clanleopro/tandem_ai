import 'dart:async';

import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../data/models/discussion_message.dart';

/// GetxController responsible for report interactions and engineer consultation.
class ReportController extends GetxController {
  final RxList<DiscussionMessage> discussionMessages =
      <DiscussionMessage>[].obs;
  final RxBool showDiscussionHistory = false.obs;

  Timer? _replyTimer;

  @override
  void onInit() {
    super.onInit();
    discussionMessages.assignAll(MockDataService.getInitialDiscussion());
  }

  void toggleDiscussionHistory() {
    showDiscussionHistory.value = !showDiscussionHistory.value;
  }

  void setDiscussionHistoryVisible(bool visible) {
    showDiscussionHistory.value = visible;
  }

  void addDiscussionMessage(String text, {String senderName = 'Divya'}) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    discussionMessages.add(
      DiscussionMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderName: senderName,
        senderRole: 'Reviewing Engineer',
        text: trimmed,
        timestamp: DateTime.now(),
        isFromEngineer: false,
      ),
    );

    showDiscussionHistory.value = true;

    _replyTimer?.cancel();
    _replyTimer = Timer(AppConstants.engineerReplyDelay, () {
      if (!isClosed) {
        discussionMessages.add(
          DiscussionMessage(
            id: 'msg_reply_${DateTime.now().millisecondsSinceEpoch}',
            senderName: 'Divya',
            senderRole: 'Senior Crane & Rigging Specialist',
            text:
                'Received your note regarding "$trimmed". I have flagged this item on Sheet 3 of the lift plan package and notified the site lift supervisor.',
            timestamp: DateTime.now(),
            isFromEngineer: true,
          ),
        );
      }
    });
  }

  @override
  void onClose() {
    _replyTimer?.cancel();
    super.onClose();
  }
}
