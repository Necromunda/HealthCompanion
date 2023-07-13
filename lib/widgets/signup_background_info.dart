import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_companion/widgets/signup_info_card.dart';

class SignUpBackgroundInfo extends StatefulWidget {
  final int pageIndex;
  final Function switchPageCallback,
      inputCallbackAge,
      inputCallbackHeight,
      inputCallbackWeight;

  const SignUpBackgroundInfo({
    Key? key,
    required this.pageIndex,
    required this.inputCallbackAge,
    required this.inputCallbackHeight,
    required this.inputCallbackWeight,
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
  late final _inputCallbackAge = widget.inputCallbackAge;
  late final _inputCallbackHeight = widget.inputCallbackHeight;
  late final _inputCallbackWeight = widget.inputCallbackWeight;
  late final _switchPageCallback = widget.switchPageCallback;
  bool _isAgeValid = false;
  bool _isHeightValid = false;
  bool _isWeightValid = false;
  final _weightRegexp =
      RegExp(r'^(?!^0[,.0])(?!^[,.])(?!^0+$)(?!^[,.0]+$)\d+(?:[,.]\d*)?$');

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

  Color get _ageColor => _ageController.text.isEmpty
      ? Colors.grey
      : _isAgeValid
          ? Colors.green
          : Colors.red;

  Color get _heightColor => _heightController.text.isEmpty
      ? Colors.grey
      : _isHeightValid
          ? Colors.green
          : Colors.red;

  Color get _weightColor => _weightController.text.isEmpty
      ? Colors.grey
      : _isWeightValid
          ? Colors.green
          : Colors.red;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 125.0),
            child: Text(
              "Page ${_pageIndex + 1} / 4",
              textAlign: TextAlign.center,
            ),
          ),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 3,
            onChanged: (value) {
              setState(() {
                if (value.isNotEmpty && !value.startsWith('0')) {
                  print(value);
                  _isAgeValid = true;
                  _inputCallbackAge(int.tryParse(value));
                } else {
                  _isAgeValid = false;
                }
              });
            },
            decoration: InputDecoration(
              errorText: _isAgeValid || _ageController.text.isEmpty
                  ? null
                  : 'Invalid age',
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _ageController.text.isEmpty ? Colors.grey : Colors.red,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _ageColor,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _ageColor,
                  width: 2.0,
                ),
              ),
              prefixIcon: Icon(
                Icons.cake,
                color: _ageColor,
              ),
              suffixText: "years",
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
                    const BorderSide(width: 2.0, style: BorderStyle.none),
              ),
            ),
          ),
          TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 3,
            onChanged: (value) {
              setState(() {
                if (value.isNotEmpty && !value.startsWith('0')) {
                  print(value);
                  _isHeightValid = true;
                  _inputCallbackHeight(int.tryParse(value));
                } else {
                  _isHeightValid = false;
                }
              });
            },
            decoration: InputDecoration(
              errorText: _isHeightValid || _heightController.text.isEmpty
                  ? null
                  : 'Invalid height',
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      _heightController.text.isEmpty ? Colors.grey : Colors.red,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _heightColor,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _heightColor,
                  width: 2.0,
                ),
              ),
              prefixIcon: Icon(
                Icons.height,
                color: _heightColor,
              ),
              suffixText: "cm",
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
                    const BorderSide(width: 2.0, style: BorderStyle.none),
              ),
            ),
          ),
          TextField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            maxLength: 5,
            onChanged: (value) {
              value = value.replaceAll(',', '.');
              print(value);
              print(_weightRegexp.hasMatch(value));
              setState(() {
                if (_weightRegexp.hasMatch(value)) {
                  print(value);
                  _isWeightValid = true;
                  _inputCallbackWeight(double.tryParse(value));
                } else {
                  _isWeightValid = false;
                }
              });
            },
            decoration: InputDecoration(
              errorText: _isWeightValid || _weightController.text.isEmpty
                  ? null
                  : 'Invalid weight',
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      _weightController.text.isEmpty ? Colors.grey : Colors.red,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _weightColor,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _weightColor,
                  width: 2.0,
                ),
              ),
              prefixIcon: Icon(
                Icons.scale,
                color: _weightColor,
              ),
              suffixText: "kg",
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
              hintText: "Weight",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide:
                    const BorderSide(width: 2.0, style: BorderStyle.none),
              ),
            ),
          ),
          const SignUpInfoCard(
            hint:
                "Age, height and weight are needed in order to accurately calculate daily nutrition intake values",
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
                        _switchPageCallback(_pageIndex - 1);
                      },
                      icon: Icon(
                        Icons.arrow_circle_left,
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
                              _switchPageCallback(_pageIndex + 1);
                            }
                          : null,
                      icon: Icon(
                        Icons.arrow_circle_right,
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
