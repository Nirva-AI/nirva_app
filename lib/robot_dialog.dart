import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';

class RobotDialog extends StatelessWidget {
  const RobotDialog({super.key});

  @override
  Widget build(BuildContext context) {
    RobotDialogData robotDialogData = DataManager().activeRobotDialog;
    BaseMessage firstMessage = robotDialogData.getMessage(0);
    return Stack(
      children: [
        Positioned(
          bottom: 80,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 顶部标题栏
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFB39DDB),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.green,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Nirva',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          firstMessage.content,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Message Nirva...',
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFB39DDB),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFB39DDB),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            // 发送按钮点击事件
                            debugPrint('Send button clicked');
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFFB39DDB),
                            child: const Icon(Icons.send, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onLongPress: () {
                            // 按住语音按钮事件
                            debugPrint('Voice button pressed');
                          },
                          onLongPressUp: () {
                            // 抬起语音按钮事件
                            debugPrint('Voice button released');
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFFB39DDB),
                            child: const Icon(Icons.mic, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
