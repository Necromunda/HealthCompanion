import 'package:flutter/material.dart';

import '../models/component_model.dart';
import 'component_breakdown_screen.dart';

class AddIngredient extends StatefulWidget {
  final List<Component> userComponents;

  const AddIngredient({Key? key, required this.userComponents}) : super(key: key);

  @override
  State<AddIngredient> createState() => _AddIngredientState();
}

class _AddIngredientState extends State<AddIngredient> {
  late List<Component> _chosenComponents;
  late final List<Component> _userComponents;
  late final ScrollController _listScrollController;

  @override
  void initState() {
    _userComponents = widget.userComponents;
    _chosenComponents = <Component>[];
    _listScrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    super.dispose();
  }

  void _addSelection(Component component) {
    setState(() {
      _chosenComponents.add(component);
    });
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          color: Colors.black,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(_chosenComponents),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
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
              onTap: () => _addSelection(_userComponents[index]),
              onLongPress: () => _showComponentBreakdown(_userComponents[index]),
            );
          },
        ),
      ),
    );
  }
}
