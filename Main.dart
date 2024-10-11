- 👋 Hi, I’m @OHYEAH6910
- 👀 I’m interested in ...
- 🌱 I’m currently learning ...
- 💞️ I’m looking to collaborate on ...
- 📫 How to reach me ...
- 😄 Pronouns: ...
- ⚡ Fun fact: ...

<!---
OHYEAH6910/OHYEAH6910 is a ✨ special ✨ repository because its `README.md` (this file) appears on your GitHub profile.
You can click the Preview link to take a look at your changes.
--->
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:flutter_sound/flutter_sound.dart';

void main() {
  runApp(AudioVideoSyncApp());
}

class AudioVideoSyncApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Video Sync App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? _cameraController;
  FlutterSoundRecorder? _audioRecorder;
  bool _isCameraInitialized = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initializeCamera();
    _initializeAudioRecorder();
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.first;

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
      );

      await _cameraController?.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  Future<void> _initializeAudioRecorder() async {
    _audioRecorder = FlutterSoundRecorder();

    try {
      await _audioRecorder?.openAudioSession();
    } catch (e) {
      print("Error initializing audio recorder: $e");
    }
  }

  Future<void> _startRecording() async {
    if (_isRecording) return;

    try {
      await _audioRecorder?.startRecorder();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    try {
      await _audioRecorder?.stopRecorder();
      setState(() {
        _isRecording = false;
      });
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _audioRecorder?.closeAudioSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Video Sync'),
      ),
      body: Column(
        children: [
          if (_isCameraInitialized)
            AspectRatio(
              aspectRatio: _cameraController!.value.aspectRatio,
              child: CameraPreview(_cameraController!),
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isRecording ? _stopRecording : _startRecording,
            child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
          ),
        ],
      ),
    );
  }
}
