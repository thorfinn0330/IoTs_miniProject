import 'package:flutter/material.dart';
import 'package:value_listener/modal/items.dart';

class LedDetailWidget extends StatelessWidget {
  final DataItems item;
  final void Function(String) onDelete;
  const LedDetailWidget({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final index = item.id; // Assuming item.id is unique

    // Define colors for alternating rows
    final Color backgroundColor = int.parse(index) % 2 == 0
        ? const Color.fromARGB(255, 174, 231, 245)
        : Colors.grey[300]!;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        height: 75,
        decoration: BoxDecoration(
          color: backgroundColor, // Use the alternating background color
          borderRadius: BorderRadius.circular(20),
        ),
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.room,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                // Wrap the icon with GestureDetector for tap detection
                onTap: () {
                  onDelete(item.id); // Call onDelete callback to delete item
                },
                child: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
