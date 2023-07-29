import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:health_companion/widgets/custom_button.dart';
import 'package:health_companion/widgets/loading_components.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  late final User _currentUser;
  late final ScrollController _scrollController;

  @override
  void initState() {
    print("Overview screen init");
    _currentUser = FirebaseAuth.instance.currentUser!;
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      // body: const Center(child: Text("Stats screen"),),
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
                  const Center(
                    child: Text(
                      "Your stats",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
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
                              const Text(
                                "Components added",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                (snapshot.data?["componentsAdded"] ?? 0)
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const Text(
                                "Components deleted",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                (snapshot.data?["componentsDeleted"] ?? 0)
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const Text(
                                "Bundles added",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                (snapshot.data?["bundlesAdded"] ?? 0)
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const Text(
                                "Bundles deleted",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                (snapshot.data?["bundlesDeleted"] ?? 0)
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const Text(
                                "Achievements unlocked",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
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

                        return const Center(
                          child: Text("Loading stats"),
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
