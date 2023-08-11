import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:health_companion/services/firebase_service.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
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
    _scrollController.dispose();
    super.dispose();
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              // hasScrollBody: false,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.yourStats,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: FirebaseService.getUserStats(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Error"),
                          );
                        }
                        if (snapshot.hasData) {
                          return GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    // mainAxisSpacing: 10
                                    mainAxisExtent: 50,
                                    crossAxisSpacing: 0),
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .statsComponentsAdded,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                (snapshot.data?["componentsAdded"] ?? 0)
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .statsComponentsDeleted,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                (snapshot.data?["componentsDeleted"] ?? 0)
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                AppLocalizations.of(context)!.statsBundlesAdded,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                (snapshot.data?["bundlesAdded"] ?? 0)
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .statsBundlesDeleted,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                (snapshot.data?["bundlesDeleted"] ?? 0)
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .statsAchievementsUnlocked,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                (snapshot.data?["achievementsUnlocked"] ?? 0)
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          );
                        }
                        return Center(
                          child: Text(
                            AppLocalizations.of(context)!.loadingStats,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
