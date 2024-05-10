import 'package:flutter/material.dart';
import 'package:value_listener/modal/items.dart';
import 'package:value_listener/widget/ledDetailWidget.dart';

class LightDetailScreen extends StatefulWidget {
  final void Function(int) updateLightCount;
  final List<DataItems> lights;
  const LightDetailScreen({
    super.key,
    required this.lights,
    required this.updateLightCount,
  });

  @override
  _LightDetailScreenState createState() => _LightDetailScreenState();
}

class _LightDetailScreenState extends State<LightDetailScreen>
    with AutomaticKeepAliveClientMixin {
  late List<DataItems> lights;

  @override
  void initState() {
    super.initState();
    lights = widget.lights;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController roomController = TextEditingController();

  void addLight(String name, String room) {
    setState(() {
      lights.add(DataItems(
        id: (lights.length + 1).toString(),
        name: name,
        room: room,
      ));
      widget.updateLightCount(lights.length);
    });
    Navigator.pop(context);
  }

  void deleteLight(String id) {
    setState(() {
      lights.removeWhere((light) => light.id == id);
      widget.updateLightCount(lights.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Light Detail Screen',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 27, 101, 227),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: lights.length,
              itemBuilder: (context, index) {
                return LedDetailWidget(
                  item: lights[index],
                  onDelete: deleteLight,
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
                            labelText: 'Light Name',
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
                            addLight(
                              nameController.text,
                              roomController.text,
                            );
                            nameController.clear();
                            roomController.clear();
                          },
                          child: const Text('Add Light'),
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
  bool get wantKeepAlive => true;
}
