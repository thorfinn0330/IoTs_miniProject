import 'package:flutter/material.dart';
import 'package:value_listener/modal/items.dart';
import 'package:value_listener/widget/fanDetailWidget.dart';

class LightDetailScreen extends StatelessWidget {
  LightDetailScreen({super.key});
  final List<DataItems> Lights = [
    DataItems(id: "1", name: "Đèn ban công", room: "Phòng ngủ"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Light Detail Screen'),
      ),
      body: Center(
        child: Column(
            children:
                Lights.map((item) => FanDetailWidget(item: item)).toList()),
      ),
    );
  }
}
