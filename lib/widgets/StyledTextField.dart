import 'package:flutter/material.dart';
import 'package:friendlyreminder/utilities/PhoneNumberFormatter.dart';

class StyledTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final int? maxLines;

  const StyledTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.prefixIcon,
      this.keyboardType = TextInputType.text,
      this.focusNode,
      this.nextFocusNode,
      this.maxLines = 1});

  @override
  State<StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<StyledTextField> {
  late bool isEmpty;

  @override
  void initState() {
    super.initState();
    isEmpty = widget.controller.text.isEmpty;

    // Add a listener to the controller
    widget.controller.addListener(() {
      setState(() {
        isEmpty = widget.controller.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: widget.controller,
              maxLines: widget.maxLines,
              focusNode: widget.focusNode,
              keyboardType: widget.keyboardType,
              textInputAction: widget.nextFocusNode != null
                  ? TextInputAction.next
                  : TextInputAction.done,
              inputFormatters: [PhoneNumberFormatter()],
              onSubmitted: (value) {
                if (widget.nextFocusNode != null) {
                  FocusScope.of(context).requestFocus(widget.nextFocusNode);
                }
              },
              decoration: InputDecoration(
                prefixIcon: Icon(widget.prefixIcon),
                suffixIcon: isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          widget.controller.clear();
                        },
                      ),
                hintText: widget.hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
