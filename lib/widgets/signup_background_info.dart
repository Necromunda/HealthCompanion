import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_companion/widgets/signup_info_card.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../util.dart';
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

  bool _isDateOfBirthValid = false;
  bool _isHeightValid = false;
  bool _isWeightValid = false;

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
        style: TextStyle(
          color: Util.isDark(context) ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          counterText: "",
          hintText: AppLocalizations.of(context)!.dateOfBirth,
          contentPadding: EdgeInsets.zero,
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
                  // color: const Color(0XDEDEDEDE).withOpacity(1),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  spreadRadius: 0,
                  offset: const Offset(1, 0), // changes position of shadow
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.calendar_month,
                size: 30,
              ),
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
        style: TextStyle(
          color: Util.isDark(context) ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          counterText: "",
          hintText: AppLocalizations.of(context)!.height,
          suffixText: "cm",
          contentPadding: const EdgeInsets.only(right: 10),
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
                  // color: const Color(0XDEDEDEDE).withOpacity(1),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  spreadRadius: 0,
                  offset: const Offset(1, 0), // changes position of shadow
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.height,
                size: 30,
              ),
            ),
          ),
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
        style: TextStyle(
          color: Util.isDark(context) ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          counterText: "",
          hintText: AppLocalizations.of(context)!.weight,
          suffixText: "kg",
          contentPadding: const EdgeInsets.only(right: 10),
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
                  // color: const Color(0XDEDEDEDE).withOpacity(1),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  spreadRadius: 0,
                  offset: const Offset(1, 0), // changes position of shadow
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.scale,
                size: 30,
              ),
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
          SignUpInfoCard(
            hint: AppLocalizations.of(context)!.signUpBackgroundInfo,
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
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  CustomButton(
                    onPressed:
                        _isDateOfBirthValid && _isHeightValid && _isWeightValid
                            ? () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                _switchPageCallback(_pageIndex + 1);
                              }
                            : null,
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
