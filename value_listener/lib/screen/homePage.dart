import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:value_listener/widget/button.dart';
import 'package:value_listener/widget/fanWidget.dart';
import 'package:value_listener/widget/humidityWidget.dart';
import 'package:value_listener/widget/insensityWidget.dart';
import 'package:value_listener/widget/ledWidget.dart';
import 'package:value_listener/widget/temperatureWidget.dart';

const server = 'io.adafruit.com';
const port = '1883';
const username = 'thorfinn0330';
const password = 'aio_dOWI18oQA6Hq7I94WG3fBdiqRebj';
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<int> _humidityValue = ValueNotifier<int>(50);
  final ValueNotifier<int> _temperatureValue = ValueNotifier<int>(25);
  final ValueNotifier<int> _insensityValue = ValueNotifier<int>(25);

  bool isButton1Pressed = false;
  bool isButton2Pressed = false;
  bool isFanOn = false;
  final Widget goodJob = const Text('Good job!');
  late MqttClient client;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(android: android);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
          _showNotification("High Temperature",
              "The temperature is above the threshold."); // Show notification
          setState(() {
            isFanOn = true; // Update button state
            publishButtonState("thorfinn0330/feeds/nutnhan2", true);
          });
        }
      }
      if (topic.contains("cambien2")) {
        _insensityValue.value = val;
        if (val.toInt() > 600) {
          _showNotification("High Luminance",
              "The Luminance is above the threshold."); // Show notification
          setState(() {
            publishButtonState("thorfinn0330/feeds/nutnhan1", false);
          });
        }
      }
      if (topic.contains("cambien3")) {
        _humidityValue.value = val;
      }
    });
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'high_temperature_channel_id', 'High Temperature');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'payload',
    );
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
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(126, 174, 231, 245)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        const SizedBox(width: 15),
                        ValueListenableBuilder<int>(
                          builder:
                              (BuildContext context, int value, Widget? child) {
                            return temperatureWidget(
                                temp: value
                                    .toString()); // Convert value to String
                          },
                          valueListenable: _temperatureValue,
                        ),
                        const SizedBox(width: 20),
                        ValueListenableBuilder<int>(
                          builder:
                              (BuildContext context, int value, Widget? child) {
                            return humidityWidget(
                                value: value
                                    .toString()); // Convert value to String
                          },
                          valueListenable: _humidityValue,
                        ),
                        const SizedBox(width: 30),
                        ValueListenableBuilder<int>(
                          builder:
                              (BuildContext context, int value, Widget? child) {
                            return insensityWidget(
                                temp: value
                                    .toString()); // Convert value to String
                          },
                          valueListenable: _insensityValue,
                        ),
                        const SizedBox(width: 30),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(126, 174, 231, 245)),
                  child: Column(
                    children: [
                      const LedWidget(),
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(126, 174, 231, 245)),
                  child: Column(
                    children: [
                      const FanWidget(),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: SwitchScreen(
                            text: "Quạt",
                            topic: "thorfinn0330/feeds/nutnhan2",
                            isButtonPressed:
                                isButton2Pressed, // Truyền giá trị isButtonPressed
                            onButtonPressedChanged: (value) {
                              setState(() {
                                isButton2Pressed =
                                    value; // Cập nhật giá trị isButtonPressed
                                publishButtonState(
                                    "thorfinn0330/feeds/nutnhan2",
                                    isButton2Pressed);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
