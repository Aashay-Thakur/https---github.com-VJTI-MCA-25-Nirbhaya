import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MotionExp extends StatefulWidget {
  const MotionExp({super.key});

  @override
  State<MotionExp> createState() => _MotionExpState();
}

class _MotionExpState extends State<MotionExp> {
  String status = "Not danger";
  double mag = 0.0;
  double maxMag = 0.0;
  Duration sensorInterval = SensorInterval.normalInterval;

  @override
  void initState() {
    super.initState();
    userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
      (UserAccelerometerEvent event) {
        double deltaX = event.x;
        double deltaY = event.y;
        double deltaZ = event.z;

        double deltaMagnitude =
            deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ;
        // Define a threshold for rapid zig-zag motion
        double threshold = 10000.0;
        mag = deltaMagnitude;

        //to check how much high we can go
        if(maxMag < deltaMagnitude){
          maxMag = deltaMagnitude;
        }
        // Check if the magnitude exceeds the threshold
        if (deltaMagnitude > threshold) {
          setState(() {
            status = "Danger";
          });
        } else {
          setState(() {
            status = "Not Danger";
          });
        }
      },
      onError: (e) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                    "It seems that your device doesn't support User Accelerometer Sensor"),
              );
            });
      },
      cancelOnError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Magnitude: $mag"),
              const SizedBox(height: 10),
              Text("Max Magnitude: $maxMag"),
              const SizedBox(height: 10),
              Text(
                status,
                style: TextStyle(
                    color: status == "Danger" ? Colors.red : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
