import 'package:flutter/material.dart';
import 'package:health_companion/widgets/custom_button.dart';
import 'package:health_companion/widgets/loading_components.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isInputValid = false;
  bool _obscureText = true;

  void onTap() {
    print("Tap!");
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
          color: Colors.black87,
        ),
      ),
      // body: const Center(child: Text("Stats screen"),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: TextField(
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            controller: _textEditingController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: _obscureText,
            maxLength: 5,
            onChanged: (value) {
              setState(() {
                _isInputValid =
                    _textEditingController.text.characters.length >= 3
                        ? true
                        : false;
              });
            },
            decoration: InputDecoration(
              counterText: "",
              hintText: "Password",
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: const Color(0XDEDEDEDE),
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
              prefixIcon: Container(
                margin: const EdgeInsets.only(right: 15.0),
                // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: _textEditingController.text.isEmpty
                      ? null
                      : _isInputValid
                          ? Colors.lightGreen
                          : Colors.redAccent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(1),
                      spreadRadius: -1,
                      offset: const Offset(2, 0), // changes position of shadow
                    ),
                    BoxShadow(
                      color: const Color(0XDEDEDEDE).withOpacity(1),
                      spreadRadius: 0,
                      offset: const Offset(1, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.key,
                      size: 30,
                      color: _textEditingController.text.isEmpty
                          ? Colors.black87
                          : _isInputValid
                              ? Colors.white
                              : Colors.black87),
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black87,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
