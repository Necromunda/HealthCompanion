import 'package:flutter/material.dart';
import 'package:health_companion/models/fineli_model.dart';
import 'package:health_companion/services/fineli_service.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState
    extends State<Search> // with AutomaticKeepAliveClientMixin<Search>
{
  final TextEditingController _searchController = TextEditingController();
  List<FineliModel>? _results;
  late FocusNode _focusNode;

  // @override
  // bool get wantKeepAlive => true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // @override
  // void didUpdateWidget(covariant Search oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void initState() {
    _results = <FineliModel>[];
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _searchController.clear();
    });
    super.initState();
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
              onChanged: (value) => setState(() {}),
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
                  onPressed: _searchController.text.isEmpty
                      ? null
                      : () {
                          _focusNode.unfocus();
                          FineliService.getFoodItem(_searchController.text)
                              .then((value) {
                            value?.forEach((element) {
                              // print(FineliModel.fromJson(element).toComponent().name);
                              _results?.add(FineliModel.fromJson(element));
                              // print(FineliModel.fromJson(element).name?.fi);
                            });
                            setState(() {
                              //   _results = value;
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
          _results!.isEmpty
              ? const SizedBox()
              : Expanded(
                  child: ListView.builder(
                    itemCount: _results?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        // title: Text(_results![index]['name']['fi']),
                        title: Text(_results![index].name!.fi!),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
