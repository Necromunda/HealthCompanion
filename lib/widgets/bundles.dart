import 'package:flutter/material.dart';
import 'package:health_companion/models/bundle_model.dart';
import 'package:intl/intl.dart';

import '../models/component_model.dart';
import '../screens/component_breakdown_screen.dart';
import '../services/firebase_service.dart';
import 'bundle_button_bar.dart';

class Bundles extends StatefulWidget {
  final int initialPageIndex;
  final List<Bundle> bundles;
  final Function onPageChanged;

  const Bundles({
    Key? key,
    required this.initialPageIndex,
    required this.bundles,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  State<Bundles> createState() => _BundlesState();
}

class _BundlesState extends State<Bundles> {
  late final int _initialPageIndex, _lastBundleIndex;
  late int _currentBundleIndex;
  late final PageController _bundlePageViewController;
  late final ScrollController _listScrollController;
  late final List<Bundle> _bundles;
  late final Function _onPageChanged;

  @override
  void initState() {
    print("Bundles init");
    _bundles = widget.bundles;
    _lastBundleIndex = _bundles.length - 1;
    _currentBundleIndex = _lastBundleIndex;
    _initialPageIndex = widget.initialPageIndex;
    _bundlePageViewController = PageController(initialPage: _initialPageIndex);
    _listScrollController = ScrollController();
    _onPageChanged = widget.onPageChanged;
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
    _bundlePageViewController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  void _showPreviousBundle() {
    if (_currentBundleIndex > 0) {
      _currentBundleIndex -= 1;
      _scrollBundles(_currentBundleIndex);
    }
  }

  void _showNextBundle() {
    if (_currentBundleIndex < _lastBundleIndex) {
      _currentBundleIndex += 1;
      _scrollBundles(_currentBundleIndex);
    }
  }

  void _scrollBundles(int index) {
    print("Scroll to $index");
    setState(() {
      _bundlePageViewController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _addNewBundle() async {
    Bundle newBundle = Bundle.fromJson({
      "creationDate": DateTime.now().millisecondsSinceEpoch,
      "lastEdited": DateTime.now().millisecondsSinceEpoch,
      "components": [],
    });
    _bundles.add(newBundle);
    await FirebaseService.updateDailyData(_bundles);
    // _scrollBundles(_lastBundleIndex);
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

  void _deleteComponentFromBundle(
      List<Bundle> bundles, int bundleIndex, int componentIndex) async {
    // bundles[bundleIndex].lastEdited = DateTime.now().millisecondsSinceEpoch;
    bundles[bundleIndex].lastEdited = DateTime.now();
    Component? retVal =
        bundles[bundleIndex].components?.removeAt(componentIndex);
    print("Removed component: $retVal");
    await FirebaseService.updateDailyData(bundles);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _bundlePageViewController,
            scrollDirection: Axis.horizontal,
            itemCount: _bundles.length,
            onPageChanged: (pageviewIndex) {
              setState(() {
                _currentBundleIndex = pageviewIndex;
                _onPageChanged(pageviewIndex);
              });
            },
            itemBuilder: (context, pageviewIndex) {
              Bundle bundle = _bundles[pageviewIndex];

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    "#${pageviewIndex + 1} Bundle created: ${DateFormat('d.M H:mm').format(
                      bundle.creationDate!,
                      // DateTime.fromMillisecondsSinceEpoch(bundle.creationDate!),
                    )}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (bundle.components!.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          "This bundle is empty",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        controller: _listScrollController,
                        itemCount: bundle.components!.length,
                        itemBuilder: (context, listviewIndex) {
                          return ListTile(
                            title: Text(
                              bundle.components![listviewIndex].name!,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              bundle.components?[listviewIndex].description ??
                                  "No description",
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _deleteComponentFromBundle(
                                      _bundles, pageviewIndex, listviewIndex),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 32.0,
                                  ),
                                ),
                                const Icon(Icons.launch)
                              ],
                            ),
                            onTap: () => _showComponentBreakdown(
                                bundle.components![listviewIndex]),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        Card(
          child: BundleButtonBar(
            onPressedLeft: _showPreviousBundle,
            onPressedCenter: _addNewBundle,
            onPressedRight: _showNextBundle,
          ),
        ),
      ],
    );
  }
}
