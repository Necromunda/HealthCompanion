import 'package:flutter/material.dart';
import 'package:health_companion/services/fineli_service.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>>? _results;
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _searchController.clear();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: TextField(
              focusNode: _focusNode,
              controller: _searchController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                // labelText: _isEmailValid ? null : "Invalid email",
                // focusedBorder: const OutlineInputBorder(
                //   borderSide: BorderSide(color: Colors.grey, width: 2.0),
                //   // borderRadius: BorderRadius.circular(15.0),
                // ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.deepPurple.shade400,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _focusNode.unfocus();
                    FineliService.getFoodItem(_searchController.text)
                        .then((value) {
                          setState(() {
                            _results = value;
                          });
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
          _results == null
              ? SizedBox()
              : Expanded(child: ListView.builder(
                  itemCount: _results?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_results![index]['name']['fi']),
                    );
                  },
                ),
                ),
        ],
      ),
    );
  }
}
