import 'package:flutter/material.dart';

class insensityWidget extends StatelessWidget {
  final String temp;
  const insensityWidget({
    required this.temp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Image.asset(height: 100, 'images/insen.png'),
          Text("$temp lx",
              style: const TextStyle(
                  fontSize: 56,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold)),
          const Text(
            "Luminance",
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
