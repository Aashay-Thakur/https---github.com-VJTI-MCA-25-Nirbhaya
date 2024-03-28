import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AudioExp extends StatefulWidget {
  const AudioExp({super.key});

  @override
  State<AudioExp> createState() => _AudioExpState();
}

class _AudioExpState extends State<AudioExp> {
  late AudioRecorder record;
  late AudioPlayer audioPlayer;
  late Stream stream;
  String? path = "";

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    record = AudioRecorder();
  }

  @override
  void dispose() {
    super.dispose();
    record.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // Check and request permission if needed
                  if (await record.hasPermission()) {

                    // Start recording to stream
                    // stream = await record.startStream(
                    //     const RecordConfig(encoder: AudioEncoder.pcm16bits));

                    String filePath = await createFileForAudio();
                    await record.start(const RecordConfig(), path: filePath);
                  }
                },
                child: const Text("Record Audio"),
              ),
              ElevatedButton(
                onPressed: () async {
                  path = await record.stop();
                  // ... or cancel it (and implicitly remove file/blob).
                  // await record.cancel();
                },
                child: const Text("Stop recording"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Source urlSource = UrlSource(path!);
                  await audioPlayer.play(urlSource);
                },
                child: const Text("Play Audio"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await audioPlayer.stop();
                },
                child: const Text("Stop Audio"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> createFileForAudio() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);

    // Create a file for the path of
    // device and file name with extension
    File('$exPath/file.m4a');
    return "$exPath/file.m4a";
  }

}
