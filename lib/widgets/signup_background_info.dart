import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpBackgroundInfo extends StatefulWidget {
  final int pageIndex;
  final Function inputCallback;
  final Function switchPageCallback;

  const SignUpBackgroundInfo({
    Key? key,
    required this.pageIndex,
    required this.inputCallback,
    required this.switchPageCallback,
  }) : super(key: key);

  @override
  State<SignUpBackgroundInfo> createState() => _SignUpBackgroundInfoState();
}

class _SignUpBackgroundInfoState extends State<SignUpBackgroundInfo>
    with AutomaticKeepAliveClientMixin<SignUpBackgroundInfo> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  late final _pageIndex = widget.pageIndex;
  late final _inputCallback = widget.inputCallback;
  late final _switchPageCallback = widget.switchPageCallback;
  bool _isAgeValid = false;
  bool _isHeightValid = false;
  bool _isWeightValid = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didUpdateWidget(covariant SignUpBackgroundInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 175.0),
            child: Text(
              "Page ${_pageIndex + 1} / 4",
              textAlign: TextAlign.center,
            ),
          ),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            // inputFormatters: [],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  print(value);
                  // _isAgeValid = int.tryParse(value) > 0 ? true : false;
                });
              }
            },
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              prefixIcon: const Icon(
                Icons.cake,
                color: Colors.grey,
              ),
              suffixIcon: _ageController.text.isEmpty
                  ? null
                  : _isAgeValid
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
              hintText: "Age",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:
                      const BorderSide(width: 1, style: BorderStyle.none)),
            ),
          ),
          TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _isHeightValid = (value as int) > 0 ? true : false;
              });
            },
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              prefixIcon: const Icon(
                Icons.height,
                color: Colors.grey,
              ),
              suffixIcon: _heightController.text.isEmpty
                  ? null
                  : _isHeightValid
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
              hintText: "Height",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:
                      const BorderSide(width: 1, style: BorderStyle.none)),
            ),
          ),
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _isWeightValid = (value as num) > 0 ? true : false;
              });
            },
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              prefixIcon: const Icon(
                Icons.scale,
                color: Colors.grey,
              ),
              suffixIcon: _weightController.text.isEmpty
                  ? null
                  : _isWeightValid
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:
                      const BorderSide(width: 1, style: BorderStyle.none)),
            ),
          ),
          const Card(
            elevation: 1,
            margin: EdgeInsets.only(top: 25.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Age, height and weight are needed in order to accurately calculate daily nutrition intake values",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (FocusScope.of(context).hasFocus) {
                          FocusScope.of(context).unfocus();
                        }
                        _switchPageCallback(0);
                      },
                      icon: Icon(
                        Icons.arrow_circle_left_outlined,
                        size: 48,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    IconButton(
                      onPressed: _isAgeValid && _isHeightValid && _isWeightValid
                          ? () {
                              if (FocusScope.of(context).hasFocus) {
                                FocusScope.of(context).unfocus();
                              }
                              _switchPageCallback(2);
                            }
                          : null,
                      icon: Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 48,
                        color: _isAgeValid && _isHeightValid && _isWeightValid
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
