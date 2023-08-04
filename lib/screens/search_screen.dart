import 'package:flutter/material.dart';
import 'package:health_companion/widgets/search_results.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../util.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  late String _searchString;
  late final FocusNode _focusNode;

  @override
  void initState() {
    _searchString = "";
    _focusNode = FocusNode();
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
    if (_focusNode.hasFocus) _focusNode.unfocus();
    _searchController.dispose();
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  Widget get _searchTextField => Card(
        clipBehavior: Clip.antiAlias,
        child: TextField(
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          controller: _searchController,
          keyboardType: TextInputType.text,
          maxLength: 99,
          style: TextStyle(
            color: Util.isDark(context) ? Colors.white : Colors.black,
          ),

          decoration: InputDecoration(
            counterText: "",
            hintText: "Search",
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            filled: true,
            // fillColor: const Color(0XDEDEDEDE),
            fillColor: Theme.of(context).colorScheme.secondaryContainer,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2.0,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2.0,
              ),
            ),
            // prefixIcon: Container(
            //   margin: const EdgeInsets.only(right: 15.0),
            //   decoration: BoxDecoration(
            //     borderRadius: const BorderRadius.only(
            //       topLeft: Radius.circular(5.0),
            //       bottomLeft: Radius.circular(5.0),
            //     ),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(1),
            //         spreadRadius: -1,
            //         offset: const Offset(2, 0), // changes position of shadow
            //       ),
            //       BoxShadow(
            //         color: const Color(0XDEDEDEDE).withOpacity(1),
            //         spreadRadius: 0,
            //         offset: const Offset(1, 0), // changes position of shadow
            //       ),
            //     ],
            //   ),
            //   child: const Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 20),
            //     child: Icon(Icons.search, size: 30, color: Colors.black87),
            //   ),
            // ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, size: 30),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {
                  _searchString = _searchController.text;
                });
              },
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          _searchTextField,
          const SizedBox(
            height: 10,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 10.0),
          //   child: TextField(
          //     focusNode: _focusNode,
          //     // onChanged: (value) => setState(() {}),
          //     controller: _searchController,
          //     keyboardType: TextInputType.text,
          //     decoration: InputDecoration(
          //       prefixIcon: Icon(
          //         Icons.search,
          //         color: Colors.deepPurple.shade400,
          //       ),
          //       suffixIcon: IconButton(
          //         icon: const Icon(Icons.search),
          //         onPressed: () {
          //           FocusManager.instance.primaryFocus?.unfocus();
          //           setState(() {
          //             _searchString = _searchController.text;
          //           });
          //         },
          //       ),
          //       hintText: "Food item",
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(5.0),
          //         borderSide: const BorderSide(
          //             width: 3, style: BorderStyle.solid, color: Colors.black),
          //       ),
          //     ),
          //   ),
          // ),
          if (_searchString.isNotEmpty)
            SearchResults(key: Key(_searchString), search: _searchString),
        ],
      ),
    );
  }
}
