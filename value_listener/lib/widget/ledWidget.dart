import 'package:flutter/material.dart';
import 'package:value_listener/modal/items.dart';
import 'package:value_listener/screen/LedDetailScreen.dart';

class LedWidget extends StatefulWidget {
  const LedWidget({super.key});

  @override
  _LedWidgetState createState() => _LedWidgetState();
}

class _LedWidgetState extends State<LedWidget> {
  int ledCount = 2; // Initially, no LEDs
  List<DataItems> lights = [
    DataItems(id: "1", name: "Đèn trần", room: "Phòng khách"),
    DataItems(id: "2", name: "Đèn chùm", room: "Phòng ngủ"),
  ];

  void updateLightCount(int newCount) {
    setState(() {
      ledCount = newCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: double.infinity,
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'images/light2.png',
              height: 100,
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Text(
                  'Number of Lights: $ledCount',
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LightDetailScreen(
                          lights: lights, // Pass the list of LEDs
                          updateLightCount: updateLightCount,
                        ),
                      ),
                    );
                  },
                  child: const Text('View details'),
                ),
                const Text(
                  'Manage Lights',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
