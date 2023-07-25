import 'package:flutter/material.dart';
import 'package:health_companion/models/fineli_model.dart';
import 'package:health_companion/services/fineli_service.dart';
import 'package:health_companion/widgets/search_results.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: TextField(
              focusNode: _focusNode,
              // onChanged: (value) => setState(() {}),
              controller: _searchController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.deepPurple.shade400,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      _searchString = _searchController.text;
                    });
                  },
                ),
                hintText: "Food item",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                      width: 3, style: BorderStyle.solid, color: Colors.black),
                ),
              ),
            ),
          ),
          if (_searchString.isNotEmpty)
            SearchResults(key: Key(_searchString), search: _searchString),
        ],
      ),
    );
  }
}
