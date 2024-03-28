import 'package:flutter/material.dart';
import 'package:record/record.dart';

class Exp extends StatefulWidget {
  const Exp({super.key});

  @override
  State<Exp> createState() => _ExpState();
}

class _ExpState extends State<Exp> {
  final record = AudioRecorder();
  late Stream stream;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    record.dispose();
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
                    stream =
                        await record.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
                  }
                },
                child: const Text("Record Audio"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await record.stop();
                  // ... or cancel it (and implicitly remove file/blob).
                  // await record.cancel();

                  //stream variable contains the audio stream
                  print(stream);

                },
                child: const Text("Stop recording"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

