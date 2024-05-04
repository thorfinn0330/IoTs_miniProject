import 'package:flutter/material.dart';

class SwitchScreen extends StatefulWidget {
  final text;
  const SwitchScreen({required this.text, super.key});

  @override
  SwitchClass createState() => SwitchClass(text);
}

class SwitchClass extends State {
  bool isSwitched = false;
  var textValue = 'Switch is OFF';
  SwitchClass(this.textValue);
  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
      });
      print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.all(15),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              textValue,
              style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Transform.scale(
                scale: 2,
                child: Switch(
                  onChanged: toggleSwitch,
                  value: isSwitched,
                  activeColor: const Color(0xFF19d2fe),
                  activeTrackColor: const Color(0xff1d6cf3),
                  inactiveThumbColor: const Color(0xff1d6cf3),
                  inactiveTrackColor: const Color(0xFF19d2fe),
                )),
          ])),
    );
  }
}
