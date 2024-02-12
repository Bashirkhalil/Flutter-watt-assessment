import 'package:flutter/material.dart';

import 'common_constant_widget.dart';

enum InputType { normalText, normalNumber, mobile, email, search, password }

class CommonEditText extends StatefulWidget {
  CommonEditText(
      {super.key,
      required this.inputType,
      required this.onChanged,
      required this.onSubmitted,
      required this.labelName,
      required this.hint,
      required this.keyboardType,
      this.readOnly = false,
      this.maxLength = 50,
      this.prefixIcon,
      this.showInsideLabel = false,
      this.textEditingController,
      this.showOuterLabel = false});

  final String hint;
  final String labelName;
  final int maxLength;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final bool showInsideLabel;
  final InputType inputType;
  final bool showOuterLabel;
  final TextEditingController? textEditingController;
  final Function(String textValue) onChanged;
  final Function(String textValue) onSubmitted;

  bool readOnly;
  bool isTextEmpty = true;

  @override
  State<CommonEditText> createState() => _CommonEditTextState();
}

class _CommonEditTextState extends State<CommonEditText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          if (widget.showOuterLabel)
            Row(
              children: [
                getTextLabel(),
              ],
            ),
          mHeight_15,
          TextFormField(
            onChanged: (textValue) {
              checkIfTextIsNotEmpty(textValue);

              widget.onChanged(textValue);
            },
            onFieldSubmitted: (textValue) {
              widget.onSubmitted(textValue);
            },
            controller: widget.textEditingController,
            keyboardType: widget.keyboardType,
            inputFormatters: getInputFormatters(),
            readOnly: widget.readOnly,
            maxLength: widget.maxLength,
            autofocus: true,
            decoration: InputDecoration(
              hintText: widget.hint,
              counterText: '',
              filled: true,
              label: widget.showInsideLabel ? getTextLabel() : null,
              fillColor: Colors.grey[100],
              // border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(5, 15, 15, 15),
              isDense: true,
              //   focusedBorder: OutlineInputBorder(
              //    borderRadius: getBorderRadius(),
              //    borderSide: const BorderSide(color: Colors.grey, width: 0.2),
              //  ),
              //  enabledBorder: OutlineInputBorder(
              //    borderRadius:getBorderRadius(),
              //   // borderSide: const BorderSide(color: Colors.grey, width: 0.2),
              //  ),
              border: OutlineInputBorder(
                borderRadius: getBorderRadius(),
              ),
              suffixIcon: widget.isTextEmpty ? null : getSuffixIcon(),
              prefixIcon: getPrefixIcon(),
            ),
          ),
        ],
      ),
    );
  }

  getTextLabel() {
    return Text(widget.labelName);
  }

  Widget getPrefixIcon() {
    switch (widget.inputType) {
      case InputType.email:
        {
          return const Icon(
            Icons.email,
            color: Colors.red,
          );
        }

      case InputType.search:
        {
          return const Icon(
            Icons.search,
            color: Colors.grey,
          );
        }

      case InputType.email:
        {
          return const Icon(
            Icons.email,
            color: Colors.red,
          );
        }

      case InputType.password:
        {
          return const Icon(
            Icons.security_outlined,
            color: Colors.red,
          );
        }

      default:
        return Icon(
          widget.prefixIcon ?? Icons.account_box_rounded,
          color: Colors.red,
        );
    }
  }

  getSuffixIcon() {
    switch (widget.inputType) {
      case InputType.search:
        {
          return IconButton(
              onPressed: () {
                if (widget.textEditingController != null &&
                    !widget.isTextEmpty) {
                  setState(() {
                    widget.textEditingController?.clear();
                    widget.isTextEmpty = true;
                  });
                }
              },
              icon: const Icon(
                Icons.clear,
                color: Colors.grey,
              ));
        }

      default:
        return null;
    }
  }

  getBorderRadius() {
    switch (widget.inputType) {
      case InputType.search:
        return BorderRadius.circular(30.0);

      default:
        return BorderRadius.circular(15.0);
    }
  }

  test() {
    TextField(
      onChanged: (textValue) {
        widget.onChanged(textValue);
      },
      onSubmitted: (textValue) {
        widget.onSubmitted(textValue);
      },
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(5, 15, 15, 15),
        hintText: widget.hint,
        label: widget.showInsideLabel ? getTextLabel() : null,
        counterText: '',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        prefixIcon: getPrefixIcon(),
      ),
      readOnly: widget.readOnly,
    );
  }

  void checkIfTextIsNotEmpty(String textValue) {
    setState(() {
      widget.isTextEmpty = textValue.isEmpty;
    });
  }

  getInputFormatters() {
    return null;
//    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  }
}
