import 'package:flutter/material.dart';
import 'package:value_listener/screen/LedDetailScreen.dart';

class LightWidget extends StatefulWidget {
  const LightWidget({super.key});

  @override
  _LightWidgetState createState() => _LightWidgetState();
}

class _LightWidgetState extends State<LightWidget> {
  int lightCount = 1; // Initially, no lights

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
            Image.asset(height: 100, 'images/light2.png'),
            const SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Text(
                  'Number of Lights: $lightCount',
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LightDetailScreen()),
                    );
                  },
                  child: const Text('View details'),
                ),
                const Text('Manage Lights',
                    style: TextStyle(fontSize: 24, color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
