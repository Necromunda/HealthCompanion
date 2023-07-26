import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_companion/widgets/signup_info_card.dart';
import 'package:intl/intl.dart';

import 'custom_button.dart';

class SignUpBackgroundInfo extends StatefulWidget {
  final int pageIndex;

  // final Function switchPageCallback, inputCallbackAge, inputCallbackHeight, inputCallbackWeight;
  final Function switchPageCallback,
      inputCallbackDateOfBirth,
      inputCallbackHeight,
      inputCallbackWeight;

  const SignUpBackgroundInfo({
    Key? key,
    required this.pageIndex,
    // required this.inputCallbackAge,
    required this.inputCallbackDateOfBirth,
    required this.inputCallbackHeight,
    required this.inputCallbackWeight,
    required this.switchPageCallback,
  }) : super(key: key);

  @override
  State<SignUpBackgroundInfo> createState() => _SignUpBackgroundInfoState();
}

class _SignUpBackgroundInfoState extends State<SignUpBackgroundInfo>
    with AutomaticKeepAliveClientMixin<SignUpBackgroundInfo> {
  // final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  late final _pageIndex = widget.pageIndex;

  // late final _inputCallbackAge = widget.inputCallbackAge;
  late final _inputCallbackDateOfBirth = widget.inputCallbackDateOfBirth;
  late final _inputCallbackHeight = widget.inputCallbackHeight;
  late final _inputCallbackWeight = widget.inputCallbackWeight;
  late final _switchPageCallback = widget.switchPageCallback;

  // bool _isAgeValid = false;
  bool _isDateOfBirthValid = false;
  bool _isHeightValid = false;
  bool _isWeightValid = false;

  // final RegExp _weightRegexp = RegExp(r'^(?!^0[,.0])(?!^[,.])(?!^0+$)(?!^[,.0]+$)\d+(?:[,.]\d*)?$');
  final RegExp _heightRegexp = RegExp(r"^[1-9]\d{0,2}");
  final RegExp _weightRegexp = RegExp(r"^[1-9]\d{0,2}((\.|,)\d?)?");
  DateTime? _dateOfBirth;

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

  Future<DateTime?> _showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    // firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    firstDate ??= DateTime(1900, 1, 1);
    // lastDate ??= firstDate.add(const Duration(days: 365 * 200));
    lastDate ??= DateTime.now();

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    // final TimeOfDay? selectedTime = await showTimePicker(
    //   context: context,
    //   initialTime: TimeOfDay.fromDateTime(selectedDate),
    // );

    // return selectedTime == null
    //     ? selectedDate
    //     : DateTime(
    //   selectedDate.year,
    //   selectedDate.month,
    //   selectedDate.day,
    //   selectedTime.hour,
    //   selectedTime.minute,
    // );

    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
  }

  // Color get _ageColor => _ageController.text.isEmpty
  //     ? Colors.grey
  //     : _isAgeValid
  //         ? Colors.green
  //         : Colors.red;

  Color get _dateOfBirthColor =>
      _dateOfBirthController.text.isEmpty ? Colors.grey : Colors.green;

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

  Widget get _dateOfBirthTextField => TextField(
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: _dateOfBirthController,
        keyboardType: TextInputType.none,
        readOnly: true,
        onTap: () {
          _showDateTimePicker(context: context, initialDate: _dateOfBirth)
              .then((value) {
            print(value);
            if (value == null) {
              _isDateOfBirthValid = false;
            } else {
              _dateOfBirth = value;
              _isDateOfBirthValid = true;
              _dateOfBirthController.text =
                  DateFormat("d.M.yyyy").format(value);
              _inputCallbackDateOfBirth(value);
            }
          });
        },
        decoration: InputDecoration(
          counterText: "",
          hintText: "Date of birth",
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
              color: _dateOfBirthController.text.isEmpty
                  ? null
                  : _isDateOfBirthValid
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
              child: Icon(Icons.calendar_month,
                  size: 30,
                  color: _dateOfBirthController.text.isEmpty
                      ? Colors.black87
                      : _isDateOfBirthValid
                          ? Colors.white
                          : Colors.black87),
            ),
          ),
        ),
      );

  Widget get _heightTextField => TextField(
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: _heightController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(_heightRegexp)],
        onChanged: (value) {
          setState(() {
            _isHeightValid = value.isEmpty ? false : true;
            if (_isHeightValid) {
              _inputCallbackHeight(double.tryParse(value));
            }
          });
        },
        decoration: InputDecoration(
          counterText: "",
          hintText: "Height",
          suffixText: "cm",
          contentPadding: const EdgeInsets.only(right: 10),
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
              color: _heightController.text.isEmpty
                  ? null
                  : _isHeightValid
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
              child: Icon(Icons.height,
                  size: 30,
                  color: _heightController.text.isEmpty
                      ? Colors.black87
                      : _isHeightValid
                          ? Colors.white
                          : Colors.black87),
            ),
          ),
          // suffixIcon: Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
        ),
      );

  Widget get _weightTextField => TextField(
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: _weightController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(_weightRegexp)],
        // maxLength: 3,
        onChanged: (value) {
          setState(() {
            _isWeightValid = value.isEmpty ? false : true;
            if (_isWeightValid) {
              _inputCallbackWeight(double.tryParse(value.replaceAll(',', '.')));
            }
          });
        },
        decoration: InputDecoration(
          counterText: "",
          hintText: "Weight",
          suffixText: "kg",
          contentPadding: const EdgeInsets.only(right: 10),
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
              color: _weightController.text.isEmpty
                  ? null
                  : _isWeightValid
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
              child: Icon(Icons.scale,
                  size: 30,
                  color: _weightController.text.isEmpty
                      ? Colors.black87
                      : _isWeightValid
                          ? Colors.white
                          : Colors.black87),
            ),
          ),
          // suffixIcon: Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
        ),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 50.0),
          //   child: Text(
          //     "Page ${_pageIndex + 1} / 4",
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          const SizedBox(
            height: 50.0,
          ),
          _dateOfBirthTextField,
          const SizedBox(
            height: 20,
          ),
          _heightTextField,
          const SizedBox(
            height: 20,
          ),
          _weightTextField,
          const SizedBox(
            height: 20,
          ),
          // TextField(
          //   readOnly: true,
          //   onTap: () {
          //     _showDateTimePicker(context: context, initialDate: _dateOfBirth)
          //         .then((value) {
          //       print(value);
          //       if (value == null) {
          //         _isDateOfBirthValid = false;
          //       } else {
          //         _dateOfBirth = value;
          //         _isDateOfBirthValid = true;
          //         _dateOfBirthController.text =
          //             DateFormat("d.M.yyyy").format(value);
          //         _inputCallbackDateOfBirth(value);
          //       }
          //     });
          //   },
          //   inputFormatters: [FilteringTextInputFormatter.deny(r"^*")],
          //   controller: _dateOfBirthController,
          //   keyboardType: TextInputType.none,
          //   decoration: InputDecoration(
          //     focusedBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: _dateOfBirthColor,
          //         width: 2.0,
          //       ),
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: _dateOfBirthColor,
          //         width: 2.0,
          //       ),
          //     ),
          //     prefixIcon: Icon(
          //       Icons.cake,
          //       color: _dateOfBirthColor,
          //     ),
          //     suffixText: "date of birth",
          //     suffixIcon: _dateOfBirthController.text.isEmpty
          //         ? null
          //         : _isDateOfBirthValid
          //             ? const Icon(
          //                 Icons.check,
          //                 color: Colors.green,
          //               )
          //             : const Icon(
          //                 Icons.close,
          //                 color: Colors.red,
          //               ),
          //     hintText: "Date of birth",
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(5.0),
          //       borderSide:
          //           const BorderSide(width: 2.0, style: BorderStyle.none),
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          // TextField(
          //   controller: _ageController,
          //   keyboardType: TextInputType.number,
          //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          //   maxLength: 3,
          //   onChanged: (value) {
          //     setState(() {
          //       if (value.isNotEmpty && !value.startsWith('0')) {
          //         print(value);
          //         _isAgeValid = true;
          //         _inputCallbackAge(int.tryParse(value));
          //       } else {
          //         _isAgeValid = false;
          //       }
          //     });
          //   },
          //   decoration: InputDecoration(
          //     errorText: _isAgeValid || _ageController.text.isEmpty ? null : 'Invalid age',
          //     errorBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: _ageController.text.isEmpty ? Colors.grey : Colors.red,
          //         width: 2.0,
          //       ),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: _ageColor,
          //         width: 2.0,
          //       ),
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: _ageColor,
          //         width: 2.0,
          //       ),
          //     ),
          //     prefixIcon: Icon(
          //       Icons.cake,
          //       color: _ageColor,
          //     ),
          //     suffixText: "years",
          //     suffixIcon: _ageController.text.isEmpty
          //         ? null
          //         : _isAgeValid
          //             ? const Icon(
          //                 Icons.check,
          //                 color: Colors.green,
          //               )
          //             : const Icon(
          //                 Icons.close,
          //                 color: Colors.red,
          //               ),
          //     hintText: "Age",
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(5.0),
          //       borderSide: const BorderSide(width: 2.0, style: BorderStyle.none),
          //     ),
          //   ),
          // ),
          // TextField(
          //   controller: _heightController,
          //   keyboardType: TextInputType.number,
          //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          //   maxLength: 3,
          //   onChanged: (value) {
          //     setState(() {
          //       if (value.isNotEmpty && !value.startsWith('0')) {
          //         print(value);
          //         _isHeightValid = true;
          //         _inputCallbackHeight(double.tryParse(value));
          //       } else {
          //         _isHeightValid = false;
          //       }
          //     });
          //   },
          //   decoration: InputDecoration(
          //     errorText: _isHeightValid || _heightController.text.isEmpty
          //         ? null
          //         : 'Invalid height',
          //     errorBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color:
          //             _heightController.text.isEmpty ? Colors.grey : Colors.red,
          //         width: 2.0,
          //       ),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: _heightColor,
          //         width: 2.0,
          //       ),
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: _heightColor,
          //         width: 2.0,
          //       ),
          //     ),
          //     prefixIcon: Icon(
          //       Icons.height,
          //       color: _heightColor,
          //     ),
          //     suffixText: "cm",
          //     suffixIcon: _heightController.text.isEmpty
          //         ? null
          //         : _isHeightValid
          //             ? const Icon(
          //                 Icons.check,
          //                 color: Colors.green,
          //               )
          //             : const Icon(
          //                 Icons.close,
          //                 color: Colors.red,
          //               ),
          //     hintText: "Height",
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(5.0),
          //       borderSide:
          //           const BorderSide(width: 2.0, style: BorderStyle.none),
          //     ),
          //   ),
          // ),
          // TextField(
          //   controller: _weightController,
          //   keyboardType: const TextInputType.numberWithOptions(decimal: true),
          //   maxLength: 5,
          //   onChanged: (value) {
          //     value = value.replaceAll(',', '.');
          //     print(value);
          //     print(_weightRegexp.hasMatch(value));
          //     setState(() {
          //       if (_weightRegexp.hasMatch(value)) {
          //         print(value);
          //         _isWeightValid = true;
          //         _inputCallbackWeight(double.tryParse(value));
          //       } else {
          //         _isWeightValid = false;
          //       }
          //     });
          //   },
          //   decoration: InputDecoration(
          //     errorText: _isWeightValid || _weightController.text.isEmpty
          //         ? null
          //         : 'Invalid weight',
          //     errorBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color:
          //             _weightController.text.isEmpty ? Colors.grey : Colors.red,
          //         width: 2.0,
          //       ),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: _weightColor,
          //         width: 2.0,
          //       ),
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: _weightColor,
          //         width: 2.0,
          //       ),
          //     ),
          //     prefixIcon: Icon(
          //       Icons.scale,
          //       color: _weightColor,
          //     ),
          //     suffixText: "kg",
          //     suffixIcon: _weightController.text.isEmpty
          //         ? null
          //         : _isWeightValid
          //             ? const Icon(
          //                 Icons.check,
          //                 color: Colors.green,
          //               )
          //             : const Icon(
          //                 Icons.close,
          //                 color: Colors.red,
          //               ),
          //     hintText: "Weight",
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(5.0),
          //       borderSide:
          //           const BorderSide(width: 2.0, style: BorderStyle.none),
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 10.0,
          // ),
          const SignUpInfoCard(
            hint:
                "Age, height and weight are needed in order to accurately calculate daily nutrition intake values",
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _switchPageCallback(_pageIndex - 1);
                    },
                    // color: _isUsernameValid ? Theme.of(context).primaryColor : Colors.grey,
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  CustomButton(
                    // onPressed: _isAgeValid && _isHeightValid && _isWeightValid
                    onPressed:
                        _isDateOfBirthValid && _isHeightValid && _isWeightValid
                            ? () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                _switchPageCallback(_pageIndex + 1);
                              }
                            : null,
                    // color: _isUsernameValid ? Theme.of(context).primaryColor : Colors.grey,
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     if (FocusScope.of(context).hasFocus) {
                  //       FocusScope.of(context).unfocus();
                  //     }
                  //     _switchPageCallback(_pageIndex - 1);
                  //   },
                  //   icon: Icon(
                  //     Icons.arrow_circle_left,
                  //     size: 48,
                  //     color: Theme.of(context).primaryColor,
                  //   ),
                  // ),
                  // IconButton(
                  //   onPressed: _isAgeValid && _isHeightValid && _isWeightValid
                  //       ? () {
                  //           if (FocusScope.of(context).hasFocus) {
                  //             FocusScope.of(context).unfocus();
                  //           }
                  //           _switchPageCallback(_pageIndex + 1);
                  //         }
                  //       : null,
                  //   icon: Icon(
                  //     Icons.arrow_circle_right,
                  //     size: 48,
                  //     color: _isAgeValid && _isHeightValid && _isWeightValid
                  //         ? Theme.of(context).primaryColor
                  //         : Colors.grey,
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
