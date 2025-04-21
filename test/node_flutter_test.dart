import 'package:flutter_test/flutter_test.dart';
import 'package:node_flutter/node_flutter.dart';
import 'package:node_flutter/node_flutter_platform_interface.dart';
import 'package:node_flutter/node_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNodeFlutterPlatform
    with MockPlatformInterfaceMixin
    implements NodeFlutterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getCurrentABIName() {
    // TODO: implement getCurrentABIName
    throw UnimplementedError();
  }

  @override
  Future<String?> getNodeJsProjectPath() {
    // TODO: implement getNodeJsProjectPath
    throw UnimplementedError();
  }

  @override
  // TODO: implement onMessageReceived
  Stream<Map<String, dynamic>> get onMessageReceived =>
      throw UnimplementedError();

  @override
  Future<void> sendMessage(String tag, String message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Future<void> startNodeProject(
    String mainFileName, {
    bool redirectOutputToLogcat = true,
  }) {
    // TODO: implement startNodeProject
    throw UnimplementedError();
  }

  @override
  Future<void> startNodeWithScript(
    String script, {
    bool redirectOutputToLogcat = true,
  }) {
    // TODO: implement startNodeWithScript
    throw UnimplementedError();
  }

  @override
  Future<void> startNodeService(
    String mainFileName,
    String title,
    String content, {
    bool redirectOutputToLogcat = true,
  }) {
    // TODO: implement startNodeService
    throw UnimplementedError();
  }
}

void main() {
  final NodeFlutterPlatform initialPlatform = NodeFlutterPlatform.instance;

  test('$MethodChannelNodeFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNodeFlutter>());
  });

  test('getPlatformVersion', () async {
    // Nodejs nodeFlutterPlugin = Nodejs();
    MockNodeFlutterPlatform fakePlatform = MockNodeFlutterPlatform();
    NodeFlutterPlatform.instance = fakePlatform;

    expect(await Nodejs.getPlatformVersion(), '42');
  });
}
