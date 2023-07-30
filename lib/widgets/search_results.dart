import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/models/component_model.dart';
import 'package:health_companion/models/fineli_model.dart';
import 'package:health_companion/widgets/loading_components.dart';

import '../screens/component_breakdown_screen.dart';
import '../services/fineli_service.dart';
import '../services/firebase_service.dart';

class SearchResults extends StatefulWidget {
  final String search;

  const SearchResults({Key? key, required this.search}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late final String _search = widget.search;
  List<int> _addedComponents = [];
  bool _addingComponent = false;
  int _addingComponentIndex = -1;

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

  Future<void> _addComponent(int index, Component component) async {
    setState(() {
      _addingComponentIndex = index;
      _addingComponent = true;
    });
    bool isAdded = await FirebaseService.saveUserComponents(
      FirebaseAuth.instance.currentUser!.uid,
      component,
    );
    if (isAdded) {
      await FirebaseService.addToStats(UserStats.addComponent, 1);
      setState(() {
        _addedComponents.add(index);
      });
    }
    setState(() {
      _addingComponentIndex = -1;
      _addingComponent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FineliService.getFoodItem(_search),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Expanded(
            child: Center(
              child: Text("Error"),
            ),
          );
        }
        if (snapshot.hasData) {
          List<Component> results = snapshot.data!
              .map((e) => FineliModel.fromJson(e).toComponent())
              .toList();

          if (results.isEmpty) {
            return Expanded(
              child: Center(
                child: Text(
                  "No results with $_search",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            );
          }

          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: results.length,
              itemBuilder: (context, index) {
                return Card(
                  // elevation: 3,
                  margin: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    title: Text(
                      results[index].name!,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      results[index].description!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    leading: IconButton(
                      icon: _addedComponents.contains(index)
                          ? const Icon(Icons.check)
                          : _addingComponent && _addingComponentIndex == index
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.add),
                      color: _addedComponents.contains(index)
                          ? Colors.deepPurple.shade400
                          : Colors.green,
                      disabledColor: Theme.of(context).primaryColor,
                      onPressed: !_addedComponents.contains(index) &&
                              _addingComponentIndex != index
                          ? () => _addComponent(index, results[index])
                          : () {},
                    ),
                    trailing: const Icon(Icons.launch),
                    onTap: () => _showComponentBreakdown(results[index]),
                  ),
                );
              },
            ),
          );
        }
        return const Expanded(
          child: Center(
            child: LoadingComponents(
              message: "Fetching data",
            ),
          ),
        );
      },
    );
  }
}
