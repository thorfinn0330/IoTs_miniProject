import 'package:flutter/material.dart';

class SwitchScreen extends StatefulWidget {
  final String text;
  final String topic;
  final bool isButtonPressed; // Thêm trạng thái isButtonPressed
  final Function(bool)
      onButtonPressedChanged; // Callback để thông báo sự thay đổi
  const SwitchScreen({
    required this.text,
    required this.topic,
    required this.isButtonPressed,
    required this.onButtonPressedChanged,
    super.key,
  });

  @override
  SwitchClass createState() => SwitchClass();
}

class SwitchClass extends State<SwitchScreen> {
  late bool isSwitched;

  @override
  void initState() {
    super.initState();
    isSwitched =
        widget.isButtonPressed; // Sử dụng giá trị truyền vào từ MyHomePage
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.text,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Transform.scale(
              scale: 1.5,
              child: Switch(
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                  widget.onButtonPressedChanged(value); // Thông báo sự thay đổi
                },
                value: isSwitched,
                activeColor: const Color(0xFF19d2fe),
                activeTrackColor: const Color(0xff1d6cf3),
                inactiveThumbColor: const Color(0xff1d6cf3),
                inactiveTrackColor: const Color(0xFF19d2fe),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Button section
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.all(10.0),
              //       child: ElevatedButton(
              //         onPressed: () {
              //           setState(() {
              //             isButton1Pressed = !isButton1Pressed;
              //             publishButtonState(
              //                 "thorfinn0330/feeds/nutnhan1", isButton1Pressed);
              //           });
              //         },
              //         style: ElevatedButton.styleFrom(
              //           minimumSize: const Size(200, 80),
              //           foregroundColor:
              //               const Color.fromARGB(255, 255, 255, 255),
              //           backgroundColor:
              //               const Color.fromARGB(255, 125, 229, 255),
              //           // side: BorderSide(color: Colors.yellow, width: 5),
              //           textStyle: const TextStyle(
              //               color: Colors.white,
              //               fontSize: 25,
              //               fontStyle: FontStyle.normal),
              //           shape: const BeveledRectangleBorder(
              //               borderRadius: BorderRadius.all(Radius.circular(5))),
              //           shadowColor: Colors.lightBlue,
              //         ),
              //         child: Text(isButton1Pressed
              //             ? 'Nhấn để tắt đèn'
              //             : 'Nhấn để bật đèn'),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(10.0),
              //       child: ElevatedButton(
              //         onPressed: () {
              //           setState(() {
              //             isButton2Pressed = !isButton2Pressed;
              //             publishButtonState(
              //                 "thorfinn0330/feeds/nutnhan2", isButton2Pressed);
              //           });
              //         },
              //         style: ElevatedButton.styleFrom(
              //           minimumSize: const Size(200, 80),
              //           foregroundColor:
              //               const Color.fromARGB(255, 255, 255, 255),
              //           backgroundColor:
              //               const Color.fromARGB(255, 125, 229, 255),
              //           // side: BorderSide(color: Colors.yellow, width: 5),
              //           textStyle: const TextStyle(
              //               color: Colors.white,
              //               fontSize: 25,
              //               fontStyle: FontStyle.normal),
              //           shape: const BeveledRectangleBorder(
              //               borderRadius: BorderRadius.all(Radius.circular(5))),
              //           shadowColor: Colors.lightBlue,
              //         ),
              //         child: Text(isButton2Pressed
              //             ? 'Nhấn để tắt quạt'
              //             : 'Nhấn để bật quạt'),
              //       ),
              //     ),
              //   ],
              // ),