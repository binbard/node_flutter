import 'package:flutter/services.dart';
import 'package:node_flutter/node_flutter_platform_interface.dart';

class Nodejs {
  static Future<void> start({
    String fileName = "main.js",
    bool redirectOutputToLogcat = true,
  }) async {
    try {
      await NodeFlutterPlatform.instance.startNodeProject(
        fileName,
        redirectOutputToLogcat: redirectOutputToLogcat,
      );
    } on PlatformException catch (e) {
      throw Exception('Failed to start Node.js: ${e.message}');
    }
  }

  static Future<void> startWithScript(
    String script, {
    bool redirectOutputToLogcat = true,
  }) async {
    try {
      await NodeFlutterPlatform.instance.startNodeWithScript(
        script,
        redirectOutputToLogcat: redirectOutputToLogcat,
      );
    } on PlatformException catch (e) {
      throw Exception('Failed to start Node.js with script: ${e.message}');
    }
  }

  static Future<void> startService(
    String script, {
    String title = "Node Service",
    String content = "Running",
    bool redirectOutputToLogcat = true,
  }) async {
    try {
      await NodeFlutterPlatform.instance.startNodeService(
        script,
        title,
        content,
      );
    } on PlatformException catch (e) {
      throw Exception('Failed to start Node.js with script: ${e.message}');
    }
  }

  static Future<void> sendMessage(String tag, String message) async {
    try {
      await NodeFlutterPlatform.instance.sendMessage(tag, message);
    } on PlatformException catch (e) {
      throw Exception('Failed to send message: ${e.message}');
    }
  }

  static Stream<Map<String, dynamic>> get onMessageReceived {
    return NodeFlutterPlatform.instance.onMessageReceived;
  }

  static Future<String?> getCurrentABIName() async {
    return await NodeFlutterPlatform.instance.getCurrentABIName();
  }

  static Future<String?> getNodeJsProjectPath() async {
    return await NodeFlutterPlatform.instance.getNodeJsProjectPath();
  }

  static Future<String?> getPlatformVersion() async {
    return await NodeFlutterPlatform.instance.getPlatformVersion();
  }
}
