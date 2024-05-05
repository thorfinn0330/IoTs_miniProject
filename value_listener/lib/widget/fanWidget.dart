import 'package:flutter/material.dart';
import 'package:value_listener/screen/FanDetailScreen.dart';

class FanWidget extends StatefulWidget {
  const FanWidget({super.key});

  @override
  _FanWidgetState createState() => _FanWidgetState();
}

class _FanWidgetState extends State<FanWidget> {
  int fanCount = 3; // Initially, no fans

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
            Image.asset(height: 100, 'images/fan2.png'),
            const SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Text(
                  'Number of Fans: $fanCount',
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FanDetailScreen()),
                    );
                  },
                  child: const Text('View details'),
                ),
                const Text('Manage Fans',
                    style: TextStyle(fontSize: 24, color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
