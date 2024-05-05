import 'package:flutter/material.dart';

class temperatureWidget extends StatelessWidget {
  final String temp;
  const temperatureWidget({
    required this.temp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Image.asset(height: 100, 'images/temperature2.png'),
          Text("$temp°C",
              style: const TextStyle(
                  fontSize: 56,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold)),
          const Text(
            "Temperature",
            style: TextStyle(
              fontSize: 24,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
    );
  }
}
