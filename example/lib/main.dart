import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:node_flutter/node_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _abiName = 'Unknown';
  String _nodeStatus = 'OFF';
  bool _nodeStarted = false;
  String _currentStatus = 'IDLE';
  String _receivedMessages = 'No messages yet';
  final TextEditingController _scriptController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _startListening();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _scriptController.dispose();
    _messageController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _startListening() {
    _messageSubscription = Nodejs.onMessageReceived.listen((msg) {
      setState(() {
        var tag = msg['channelName'] ?? 'Unknown tag';
        var message = msg['message'] ?? 'Unknown message';

        if (tag == "_NODE_") {
          if (message == "STARTED") {
            setState(() {
              _nodeStarted = true;
              _nodeStatus = 'ON';
            });
          } else if (message == "STOPPED") {
            setState(() {
              _nodeStarted = false;
              _nodeStatus = 'OFF';
            });
          } else {
            setState(() {
              _nodeStatus = 'Unknown status: $message';
            });
          }
          return;
        }

        if (tag == "eval") {
          _scriptController.text = message;
          _scriptController.selection = TextSelection.fromPosition(
            TextPosition(offset: _scriptController.text.length),
          );
          return;
        }

        var timestamp = DateTime.now().toIso8601String();

        _receivedMessages = '[$timestamp] $tag: $message\n$_receivedMessages';
      });
    });
  }

  Future<void> initPlatformState() async {
    try {
      final platformVersion =
          await Nodejs.getPlatformVersion() ?? 'Unknown platform version';
      final abiName = 'Unknown ABI';

      if (!mounted) return;

      setState(() {
        _platformVersion = platformVersion;
        _abiName = abiName;
      });
    } on PlatformException {
      setState(() {
        _platformVersion = 'Failed to get platform version.';
      });
    }
  }

  Future<void> _execNodeWithScript() async {
    if (_scriptController.text.isEmpty) return;

    setState(() {
      _currentStatus = 'Starting Node.js with script...';
    });

    try {
      if (_nodeStarted == true) {
        Nodejs.sendMessage("eval", _scriptController.text);
        setState(() {
          _currentStatus = 'Evaluating script...';
        });
      } else {
        setState(() {
          _currentStatus = 'Node.js is not started yet';
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _currentStatus = 'Failed to start: ${e.message}';
      });
    }
  }

  Future<void> _startNodeProject() async {
    setState(() {
      _currentStatus = 'Starting Node.js project...';
    });

    try {
      await Nodejs.start();
      setState(() {
        _currentStatus = 'Node.js start request sent!';
      });
    } on PlatformException catch (e) {
      setState(() {
        _currentStatus = 'Failed to start project: ${e.message}';
      });
    }
  }

  Future<void> _startNodeService() async {
    setState(() {
      _currentStatus = 'Starting Node.js service...';
    });

    try {
      await Nodejs.startService(
        "main.js",
        title: "Node Service",
        content: "Running",
      );
      setState(() {
        _currentStatus = 'Node.js Service request sent!';
      });
    } on PlatformException catch (e) {
      setState(() {
        _currentStatus = 'Failed to start service: ${e.message}';
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty || _tagController.text.isEmpty) return;

    try {
      await Nodejs.sendMessage(_tagController.text, _messageController.text);
      _messageController.clear();
    } on PlatformException catch (e) {
      setState(() {
        _receivedMessages =
            'Failed to send message: ${e.message}\n$_receivedMessages';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Nodejs in Flutter Test')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoSection(),
              const SizedBox(height: 20),
              _buildProjectSection(),
              const SizedBox(height: 20),
              _buildStartServiceSection(),
              const SizedBox(height: 20),
              _buildScriptSection(),
              const SizedBox(height: 20),
              _buildMessageSection(),
              const SizedBox(height: 20),
              _buildMessagesDisplay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Info',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Platform: $_platformVersion'),
            Text('ABI: $_abiName'),
            const SizedBox(height: 10),
            Text(
              'Status: $_nodeStatus',
              style: TextStyle(
                color: _nodeStatus.contains('OFF') ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Info: $_currentStatus',
              style: TextStyle(
                color: _currentStatus == 'ing' ? Colors.blue : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _startNodeProject,
            child: const Text('Start Node.js'),
          ),
        ),
      ),
    );
  }

  Widget _buildStartServiceSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _startNodeService,
            child: const Text('Start Node Service'),
          ),
        ),
      ),
    );
  }

  Widget _buildScriptSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Run Script',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _scriptController,
              decoration: const InputDecoration(
                labelText: 'Enter javascript',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _execNodeWithScript,
                child: const Text('Execute Script'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Send Message to Node.js',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(
                labelText: 'Message tag',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message content',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendMessage,
                child: const Text('Send Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesDisplay() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Messages from Node.js',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                reverse: true,
                child: Text(_receivedMessages),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _receivedMessages = 'No messages yet';
                  });
                },
                child: const Text('Clear Messages'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
