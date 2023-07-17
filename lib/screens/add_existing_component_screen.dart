import 'package:flutter/material.dart';

import '../models/component_model.dart';
import 'component_breakdown_screen.dart';

class AddExistingComponent extends StatefulWidget {
  final List<Component> userComponents;

  const AddExistingComponent({Key? key, required this.userComponents}) : super(key: key);

  @override
  State<AddExistingComponent> createState() => _AddExistingComponent();
}

class _AddExistingComponent extends State<AddExistingComponent> {
  late List<Component> _selectedComponents;
  late final List<Component> _userComponents;
  late final ScrollController _listScrollController;

  @override
  void initState() {
    _userComponents = widget.userComponents;
    _selectedComponents = <Component>[];
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
      _selectedComponents.add(component);
    });
  }

  void _removeSelection(Component component) {
    setState(() {
      _selectedComponents.remove(component);
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

  bool _isSelected(Component component) {
    return _selectedComponents.contains(component);
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
            onPressed: () => Navigator.of(context).pop(_selectedComponents),
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
                style: TextStyle(
                    fontSize: 18,
                    color: _isSelected(_userComponents[index])
                        ? Theme.of(context).primaryColor
                        : null),
              ),
              subtitle: Text(
                _userComponents[index].description!,
                style: const TextStyle(fontSize: 16),
              ),
              trailing: const Icon(Icons.launch),
              onTap: () => _isSelected(_userComponents[index])
                  ? _removeSelection(_userComponents[index])
                  : _addSelection(_userComponents[index]),
              onLongPress: () => _showComponentBreakdown(_userComponents[index]),
            );
          },
        ),
      ),
    );
  }
}
