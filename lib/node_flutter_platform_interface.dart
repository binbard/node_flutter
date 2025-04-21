import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:node_flutter/node_flutter_method_channel.dart';

abstract class NodeFlutterPlatform extends PlatformInterface {
  NodeFlutterPlatform() : super(token: _token);
  static final Object _token = Object();

  static NodeFlutterPlatform _instance = MethodChannelNodeFlutter();

  static NodeFlutterPlatform get instance => _instance;

  static set instance(NodeFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> startNodeWithScript(
    String script, {
    bool redirectOutputToLogcat = true,
  }) {
    throw UnimplementedError('startNodeWithScript() has not been implemented.');
  }

  Future<void> startNodeProject(
    String mainFileName, {
    bool redirectOutputToLogcat = true,
  }) {
    throw UnimplementedError('startNodeProject() has not been implemented.');
  }

  Future<void> startNodeService(
    String mainFileName,
    String title,
    String content, {
    bool redirectOutputToLogcat = true,
  }) {
    throw UnimplementedError('startNodeService() has not been implemented.');
  }

  Future<void> sendMessage(String tag, String message) {
    throw UnimplementedError('sendMessage() has not been implemented.');
  }

  Stream<Map<String, dynamic>> get onMessageReceived {
    throw UnimplementedError('onMessageReceived has not been implemented.');
  }

  Future<String?> getCurrentABIName() {
    throw UnimplementedError('getCurrentABIName() has not been implemented.');
  }

  Future<String?> getNodeJsProjectPath() {
    throw UnimplementedError(
      'getCurrentNodeVersion() has not been implemented.',
    );
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }
}
