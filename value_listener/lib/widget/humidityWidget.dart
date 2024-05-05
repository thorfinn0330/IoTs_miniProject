import 'package:flutter/material.dart';

// ignore: must_be_immutable
class humidityWidget extends StatelessWidget {
  String value = "30.0";

  humidityWidget({
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Image.asset(height: 100, 'images/humidity2.png'),
          Text("$value%",
              style: const TextStyle(
                  fontSize: 56,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          const Text(
            "Humidity",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
