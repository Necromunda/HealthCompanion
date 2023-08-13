import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:health_companion/models/fineli_model.dart';
import 'package:health_companion/models/component_model.dart';
import 'package:health_companion/services/fineli_service.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:health_companion/widgets/loading_components.dart';
import 'package:health_companion/screens/component_breakdown_screen.dart';

class SearchResults extends StatefulWidget {
  final String search;

  const SearchResults({Key? key, required this.search}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  static const List<String> _portions = ['g', 'ports', 'portm', 'portl'];
  late final String _search = widget.search;
  final List<int> _addedComponents = [];
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

  // Future<void> _addComponent(int index, Component component) async {
  Future<void> _addComponent(int index, FineliModel model) async {
    Locale myLocale = Localizations.localeOf(context);
    String? portion = await _dialogBuilder(context, model);
    if (portion == null) return;
    setState(() {
      _addingComponentIndex = index;
      _addingComponent = true;
    });
    int userComponentsLength = await FirebaseService.saveUserComponents(
      model.toComponent(myLocale.languageCode, portion),
    );
    if (userComponentsLength != 0) {
      await FirebaseService.addToStats(UserStats.addComponent, 1);
      setState(() {
        _addedComponents.add(index);
      });
    }
    setState(() {
      _addingComponentIndex = -1;
      _addingComponent = false;
    });
    _addComponentAchievement(userComponentsLength);
  }

  void _addComponentAchievement(int userComponentsLength) {
    if (userComponentsLength >= 250) {
      FirebaseService.addAchievement(
          context, UserAchievementType.components250);
    } else if (userComponentsLength >= 100) {
      FirebaseService.addAchievement(
          context, UserAchievementType.components100);
    } else if (userComponentsLength >= 50) {
      FirebaseService.addAchievement(context, UserAchievementType.components50);
    } else if (userComponentsLength >= 10) {
      FirebaseService.addAchievement(context, UserAchievementType.components10);
    }
  }

  Future<String?> _dialogBuilder(BuildContext context, FineliModel model) {
    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        var width = MediaQuery.of(context).size.width;
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          content: SizedBox(
            width: width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ..._portions
                    .map((e) => ListTile(
                        title: Text(AppLocalizations.of(context)!.portions(e)),
                        subtitle: Text(e == 'g'
                            ? '100 g'
                            : "${model.units?.firstWhere((element) => element.code?.toLowerCase() == e).mass?.toStringAsFixed(0)} g"),
                        onTap: () => Navigator.of(context).pop(e)))
                    .toList(),
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        );
      },
    );
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
          Locale myLocale = Localizations.localeOf(context);
          List<Component> results = snapshot.data!
              .map((e) =>
                  FineliModel.fromJson(e).toComponent(myLocale.languageCode))
              .toList();
          List<FineliModel> fineliResults =
              snapshot.data!.map((e) => FineliModel.fromJson(e)).toList();

          if (results.isEmpty) {
            return Expanded(
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.searchNoMatches,
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
                          ? () => _addComponent(index, fineliResults[index])
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
