import 'package:flutter/material.dart';
import 'package:value_listener/modal/items.dart';
import 'package:value_listener/widget/fanDetailWidget.dart';

class FanDetailScreen extends StatefulWidget {
  final void Function(int) updateFanCount;
  final List<DataItems> fans;
  const FanDetailScreen({
    super.key,
    required this.fans,
    required this.updateFanCount,
  });

  @override
  _FanDetailScreenState createState() => _FanDetailScreenState();
}

class _FanDetailScreenState extends State<FanDetailScreen>
    with AutomaticKeepAliveClientMixin {
  late List<DataItems> fans; // Update this line

  @override
  void initState() {
    super.initState();
    fans = widget.fans; // Assign the passed list of fans to the local variable
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController roomController = TextEditingController();

  void addFan(String name, String room) {
    setState(() {
      fans.add(DataItems(
        id: (fans.length + 1).toString(),
        name: name,
        room: room,
      ));
      widget.updateFanCount(fans.length); // Update fan count
    });
    Navigator.pop(context); // Close the bottom modal sheet
  }

  void deleteFan(String id) {
    setState(() {
      fans.removeWhere((fan) => fan.id == id);
      widget.updateFanCount(fans.length); // Update fan count
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(
        context); // Ensure to call super.build(context) to use AutomaticKeepAliveClientMixin

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fan Detail Screen',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 27, 101, 227),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: fans.length,
              itemBuilder: (context, index) {
                return FanDetailWidget(
                  item: fans[index],
                  onDelete: deleteFan,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 27, 101, 227),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Fan Name',
                          ),
                        ),
                        TextField(
                          controller: roomController,
                          decoration: const InputDecoration(
                            labelText: 'Room',
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            addFan(
                              nameController.text,
                              roomController.text,
                            );
                            nameController.clear();
                            roomController.clear();
                          },
                          child: const Text('Add Fan'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  bool get wantKeepAlive =>
      true; // Return true to preserve the state of the widget
}
