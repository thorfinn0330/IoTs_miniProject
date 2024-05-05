import 'package:flutter/material.dart';
import 'package:value_listener/modal/items.dart';

class FanDetailWidget extends StatelessWidget {
  final DataItems item;
  const FanDetailWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        height: 75,
        decoration: BoxDecoration(
            color: Colors.grey[400], borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(item.room,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      )),
                ],
              ),
              const Icon(
                Icons.delete_outline,
                size: 20,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
