import 'package:flutter/material.dart';
import 'package:health_companion/screens/add_component_screen.dart';

import '../models/component_model.dart';

class Components extends StatefulWidget {
  const Components({Key? key}) : super(key: key);

  @override
  State<Components> createState() => _ComponentsState();
}

class _ComponentsState extends State<Components> {
  final ScrollController _listScrollController = ScrollController();
  List<Component> _components = [];

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addComponent() async {
    Component? _component = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const AddComponent();
        },
      ),
    );
    print(_component);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 5,
              child: ListTile(
                title: const Text(
                  "Add component +",
                  style: TextStyle(fontSize: 22),
                ),
                trailing: const Icon(Icons.arrow_forward),
                onTap: _addComponent,
              ),
            ),
          )
        ],
      ),
    );
  }
}
