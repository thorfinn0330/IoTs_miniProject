import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:value_listener/widget/button.dart';

const server = 'io.adafruit.com';
const port = '1883';
const username = 'thorfinn0330';
const password = 'aio_hWro50PCtg2XhdDyQbLo4MMMi0pQ';
const topics = [
  'thorfinn0330/feeds/cambien1',
  'thorfinn0330/feeds/cambien2',
  'thorfinn0330/feeds/cambien3',
  'thorfinn0330/feeds/nutnhan1',
  'thorfinn0330/feeds/nutnhan2',
  'thorfinn0330/feeds/ai'
];

int getValuePayload(String payload) {
  int nByte = int.parse(payload.substring(
      payload.indexOf("Payload") + 10, payload.indexOf("Payload") + 11));
  final hexString = payload.substring(payload.indexOf("bytes") + 8,
      payload.indexOf("bytes") + 8 + nByte * 3 + (nByte - 2));
  List<String> parts = hexString.split("><");
  int total = 0;
  int base = 1;
  for (int i = 1; i < nByte; i++) {
    base *= 10;
  }
  for (int i = 0; i < parts.length; i++) {
    int temp = (int.parse(parts[i]) - 48) * base;
    base = base ~/ 10;

    total += temp;
  }
  return total;
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartHome',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'SmartHome'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<int> _humidityValue = ValueNotifier<int>(50);
  final ValueNotifier<int> _temperatureValue = ValueNotifier<int>(25);
  bool isButton1Pressed = false;
  bool isButton2Pressed = false;
  final Widget goodJob = const Text('Good job!');
  late MqttClient client;
  @override
  void initState() {
    super.initState();
    client =
        MqttServerClient(server, ''); // Replace "yourClientId" with a unique ID
    client.connect(username, password).then((connack) {
      if (connack?.state == MqttConnectionState.connected) {
        print('Connected to MQTT broker');
        // Subscribe to the topic here (explained in step 4)
        subscribeToTopic(); // Call subscribe function after successful connection
        _listenForMessages();
      } else {
        print('Connection failed. State: ${connack?.state}');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    client.disconnect(); // Disconnect from the broker when done
  }

  void connectToMqttBroker() async {
    try {
      final connack = await client.connect(username, password);
      if (connack?.state == MqttConnectionState.connected) {
        print('Connected to MQTT broker');
        subscribeToTopic(); // Call subscribe function after successful connection
        _listenForMessages();
      } else {
        print('Connection failed. State: ${connack?.state}');
      }
    } catch (e) {
      print('Error connecting to MQTT broker: $e');
    }
  }

  void subscribeToTopic() {
    for (String topic in topics) {
      client.subscribe(topic, MqttQos.atLeastOnce);
    }
  }

  void publishButtonState(String topic, bool state) {
    final message = state ? '1' : '0'; // Clear message for button state
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }

  void _listenForMessages() {
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final message = messages[0].payload.toString();
      final topic = messages[0].topic;

      print('----------------Received message: $message');
      int val = getValuePayload(message);
      print('Topic: $topic ----------------Value:  $val');
      if (topic.contains("cambien1")) {
        _temperatureValue.value = val;
        if (val.toInt() > 35) {
          setState(() {
            isButton1Pressed = true; // Cập nhật trạng thái của nút nhấn
            publishButtonState("thorfinn0330/feeds/nutnhan1", isButton1Pressed);
          });
        }
      }
      if (topic.contains("cambien3")) {
        _humidityValue.value = val;
      }
      // if (topic.contains("nutnhan1")) {
      //   isButton1Pressed = message == "1" ? true : false;
      // }
      // if (topic.contains("nutnhan2")) {
      //   isButton2Pressed = message == "1" ? true : false;
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "SmartHome",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 27, 101, 227),
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff1d6cf3), Color(0xFF19d2fe)])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(97, 95, 217, 248)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ValueListenableBuilder<int>(
                        builder:
                            (BuildContext context, int value, Widget? child) {
                          return temperatureWidget(
                              temp:
                                  value.toString()); // Convert value to String
                        },
                        valueListenable: _temperatureValue,
                      ),
                      ValueListenableBuilder<int>(
                        builder:
                            (BuildContext context, int value, Widget? child) {
                          return humidityWidget(
                              value:
                                  value.toString()); // Convert value to String
                        },
                        valueListenable: _humidityValue,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(97, 95, 217, 248)),
                  child: Column(
                    children: [
                      SwitchScreen(
                        text: "Đèn",
                        topic: "thorfinn0330/feeds/nutnhan1",
                        isButtonPressed:
                            isButton1Pressed, // Truyền giá trị isButtonPressed
                        onButtonPressedChanged: (value) {
                          setState(() {
                            isButton1Pressed =
                                value; // Cập nhật giá trị isButtonPressed
                            publishButtonState("thorfinn0330/feeds/nutnhan1",
                                isButton1Pressed);
                          });
                        },
                      ),
                      SwitchScreen(
                        text: "Quạt",
                        topic: "thorfinn0330/feeds/nutnhan2",
                        isButtonPressed:
                            isButton2Pressed, // Truyền giá trị isButtonPressed
                        onButtonPressedChanged: (value) {
                          setState(() {
                            isButton2Pressed =
                                value; // Cập nhật giá trị isButtonPressed
                            publishButtonState("thorfinn0330/feeds/nutnhan2",
                                isButton2Pressed);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(96, 148, 234, 255)),
                  child: const Column(
                    children: [
                      Text("Nhận diện AI ",
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                      Text("                     ",
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                      Text("Không đeo khẩu trang",
                          style: TextStyle(fontSize: 32, color: Colors.white)),
                    ],
                  ),
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class temperatureWidget extends StatelessWidget {
  final String temp;
  const temperatureWidget({
    required this.temp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(height: 150, 'images/ii.png'),
        Text("$temp°C",
            style: const TextStyle(
                fontSize: 56,
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold)),
        const Text(
          "Nhiệt độ",
          style: TextStyle(
            fontSize: 24,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ],
    );
  }
}

class humidityWidget extends StatelessWidget {
  String value = "30.0";

  humidityWidget({
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(height: 150, 'images/temp_1.png'),
        Text("$value%",
            style: const TextStyle(
                fontSize: 56,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        const Text(
          "Độ ẩm",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ],
    );
  }
}

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
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.text,
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Transform.scale(
              scale: 2,
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
