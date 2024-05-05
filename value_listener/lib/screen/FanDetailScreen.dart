import 'package:flutter/material.dart';
import 'package:value_listener/modal/items.dart';
import 'package:value_listener/widget/button.dart';
import 'package:value_listener/widget/fanDetailWidget.dart';

class FanDetailScreen extends StatelessWidget {
  FanDetailScreen({super.key});
  final List<DataItems> Fans = [
    DataItems(id: "1", name: "Quạt 1", room: "Phòng ngủ"),
    DataItems(id: "2", name: "Quạt trần", room: "Phòng khách"),
    DataItems(id: "3", name: "Quạt treo tường", room: "Phòng ngủ"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fan Detail Screen',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 27, 101, 227),
      ),
      body: Center(
        child: Column(
            children: Fans.map((item) => FanDetailWidget(item: item)).toList()),
      ),
    );
  }
}
