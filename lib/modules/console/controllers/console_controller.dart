import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/sample_data.dart';
import '../../../models/rigging_models.dart';
import '../../home/controllers/home_controller.dart';

class ConsoleController extends GetxController {
  static ConsoleController get to => Get.find<ConsoleController>();

  final chatHistory = <ChatMessage>[].obs;
  final activeReport = Rx<AuditReport?>(null);
  final isGenerating = false.obs;
  final inputController = TextEditingController();
  final scrollController = ScrollController();

  final List<String> quickPrompts = [
    'Recalculate with 60° Sling Angle',
    'What Crosby shackle size fixes D/d ratio?',
    'Calculate Dynamic Factored Load (DAF=1.15)',
    'Generate Stamped Lift Plan Rework Note',
    'Verify Crane Outrigger Mat Sizing',
  ];

  @override
  void onInit() {
    super.onInit();
    final initial = SampleData.getInitialAuditorMessages();
    chatHistory.assignAll(initial);

    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args['report'] != null) {
        activeReport.value = args['report'] as AuditReport;
      }
      if (args['prompt'] != null && (args['prompt'] as String).isNotEmpty) {
        inputController.text = args['prompt'] as String;
      }
    }

    if (activeReport.value == null && Get.isRegistered<HomeController>()) {
      activeReport.value = HomeController.to.activeReport.value;
    }
  }

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void handleSend(String text) {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'user',
      text: text.trim(),
      timestamp: DateTime.now(),
    );

    chatHistory.add(userMsg);
    inputController.clear();
    scrollToBottom();

    isGenerating.value = true;
    Future.delayed(const Duration(milliseconds: 700), () {
      final aiResponse = _generateResponse(text);
      chatHistory.add(aiResponse);
      isGenerating.value = false;
      scrollToBottom();
    });
  }

  ChatMessage _generateResponse(String query) {
    final q = query.toLowerCase();

    if (q.contains('60') || q.contains('angle') || q.contains('sling length') || q.contains('tension')) {
      return ChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'ai',
        text: '### Engineering Tension Recalculation (θ = 60.0° Horizontal Angle)\n\n'
            'By lengthening the 4-leg wire rope bridle from **8.5 m** to **10.5 m**, the horizontal sling angle increases from **41.5°** to **60.0°**.\n\n'
            '**Formula Evaluation:**\n\n'
            r'$$\text{Leg Tension } T = \frac{W}{N \cdot \sin\theta} = \frac{142.5\text{ MT}}{4 \cdot \sin(60^\circ)} = \frac{142.5}{3.4641} = \mathbf{41.14\text{ MT}}$$'
            '\n\n'
            '• **Previous Tension (41.5°):** 53.6 MT *(VIOLATION: Exceeds 50 MT WLL)*\n'
            '• **New Tension (60.0°):** 41.14 MT *(COMPLIANT: 17.7% Safety Margin)*\n'
            '• **Design Safety Factor:** Increases from **4.1:1** to **5.4:1** *(Satisfies ASME B30.9-2021 min 5.0)*.',
        timestamp: DateTime.now(),
      );
    } else if (q.contains('shackle') || q.contains('d/d') || q.contains('crosby') || q.contains('curvature')) {
      return ChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'ai',
        text: '### Crosby Hardware Hardware Sizing Directives\n\n'
            'The current lift plan specifies a 35 MT Crosby G-2130 shackle where the pin diameter (d = 1.625 in) against the pad eye hole (D = 1.54 in) creates an impermissible **D/d ratio of 0.95**.\n\n'
            '**Remediation Recommendation:**\n'
            '1. Upgrade to **Crosby G-2130 55-Metric Ton Alloy Shackle** (Pin dia: 2.25 in / 57.1 mm).\n'
            '2. Yields an updated **D/d ratio of 1.38**, fully satisfying Crosby Engineering and ASME B30.26 standards.\n'
            '3. Working Load Limit increases from 35.0 MT to 55.0 MT, supporting dynamic peak loading.',
        timestamp: DateTime.now(),
      );
    } else if (q.contains('daf') || q.contains('dynamic') || q.contains('amplification')) {
      return ChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'ai',
        text: '### Dynamic Factored Load Analysis (DAF = 1.15)\n\n'
            'Under coastal wind conditions and dual-crane synchronisation:\n\n'
            r'$$\text{Factored Load } W_d = W \cdot \text{DAF} = 142.5\text{ MT} \cdot 1.15 = \mathbf{163.88\text{ MT}}$$'
            '\n\n'
            '• **Crane A (Liebherr LTM 1750-9.1):** 81.94 MT share (72% chart rating at 18 m radius)\n'
            '• **Crane B (Tadano ATF 400G-6):** 81.94 MT share (68% chart rating at 16 m radius)\n'
            'Both cranes maintain greater than 25% safety reserve under factored dynamic loading.',
        timestamp: DateTime.now(),
      );
    } else if (q.contains('stamp') || q.contains('note') || q.contains('rework')) {
      return ChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'ai',
        text: '### Certified PE Engineering Revision Note\n\n'
            '```\n'
            'PROJECT: Turbine Generator Module 4 (TANDEM LIFT REV 04)\n'
            'SPECIFICATION: ASME B30.9-2021 & LOLER 1998 COMPLIANCE\n'
            '\n'
            'REWORK DIRECTIVES FOR LIFT DIRECTOR & RIGGING FOREMAN:\n'
            '1. REPLACE 8.5m BRIDLE LEGS WITH 10.5m WIRE ROPE SLINGS (MIN 60° INCLINATION).\n'
            '2. REPLACE EXISTING 35T SHACKLES WITH 55T CROSBY G-2130 (PIN D/d >= 1.0).\n'
            '3. VERIFY GROUND BEARING PRESSURE UNDER MATS DOES NOT EXCEED 220 kPa.\n'
            '\n'
            'STATUS: REVISED LIFT PLAN APPROVED PENDING PHYSICAL RIGGING INSPECTION.\n'
            '```',
        timestamp: DateTime.now(),
      );
    }

    return ChatMessage(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'ai',
      text: '### Rigging Compliance Clarification\n\n'
          'Regarding "$query":\n\n'
          'Under **ASME B30.9** and **OSHA 1926.1400**, all multi-leg sling arrangements require verification that no single leg exceeds its rated Working Load Limit under unequal load sharing (Clause 9-2.10.1).\n\n'
          'Would you like me to recalculate the rigging geometry or draft an engineering variance form for this clause?',
      timestamp: DateTime.now(),
    );
  }
}
