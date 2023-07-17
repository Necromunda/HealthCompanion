import 'package:flutter/material.dart';
import 'package:health_companion/screens/add_component_screen.dart';

import '../models/component_model.dart';
import 'component_breakdown_screen.dart';

class Components extends StatefulWidget {
  const Components({Key? key}) : super(key: key);

  @override
  State<Components> createState() => _ComponentsState();
}

class _ComponentsState extends State<Components> {
  final ScrollController _listScrollController = ScrollController();
  List<Component> _userComponents = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
    Component? component = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const AddComponent(
            userComponents: [],
          );
        },
      ),
    );
    print(component);
  }

  void _showComponentBreakdown(Component component) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ComponentBreakdown(
            component: component,
          );
        },
      ),
    );
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
          ),
          ListView.builder(
            controller: _listScrollController,
            itemCount: _userComponents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  _userComponents[index].name!,
                  style: const TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  _userComponents[index].description!,
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: const Icon(Icons.launch),
                onTap: () => _showComponentBreakdown(_userComponents[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}
