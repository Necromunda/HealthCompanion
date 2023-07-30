import 'package:flutter/material.dart';
import 'package:health_companion/widgets/achievement_template.dart';

class Achievements extends StatelessWidget {
  const Achievements({Key? key}) : super(key: key);

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
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          children: [
            FutureBuilder(
              future: Future.delayed(Duration(seconds: 5)),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error"),
                  );
                }
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Components",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                TextButton(
                                  onPressed: null,
                                  child: Text("More"),
                                ),
                              ],
                            ),
                            Expanded(
                              child: SizedBox(
                                // height: 150,
                                width: double.infinity,
                                child: ListView.builder(
                                  // shrinkWrap: true,
                                  itemCount: 10,
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Center(
                                        child: Container(
                                          height: 200,
                                          width: 100,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onTertiary,
                                          child: Text(
                                            "Achievement\n${index + 1}",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    );
                                    // return Padding(
                                    //   padding: const EdgeInsets.all(5),
                                    //   child: Image.network(
                                    //     "https://logo.uplead.com/amazon.com",
                                    //     // scale: 0.5,
                                    //   ),
                                    // );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Member",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                TextButton(
                                  onPressed: null,
                                  child: Text("More"),
                                ),
                              ],
                            ),
                            Expanded(
                              child: SizedBox(
                                // height: 150,
                                width: double.infinity,
                                child: ListView.builder(
                                  // shrinkWrap: true,
                                  itemCount: 10,
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Center(
                                        child: Container(
                                          height: 200,
                                          width: 100,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onTertiary,
                                          child: Text(
                                            "Achievement\n${index + 1}",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    );
                                    // return Padding(
                                    //   padding: const EdgeInsets.all(5),
                                    //   child: Image.network(
                                    //     "https://logo.uplead.com/amazon.com",
                                    //     // scale: 0.5,
                                    //   ),
                                    // );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
