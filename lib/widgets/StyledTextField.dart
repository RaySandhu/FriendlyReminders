import 'package:flutter/material.dart';

class StyledTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final int? maxLines;

  const StyledTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.prefixIcon,
      this.maxLines = 1});

  @override
  State<StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<StyledTextField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: widget.controller,
              onChanged: (text) => setState(() {
                widget.controller.text.isEmpty;
              }),
              maxLines: widget.maxLines,
              decoration: InputDecoration(
                prefixIcon: Icon(widget.prefixIcon),
                suffixIcon: widget.controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            widget.controller.clear();
                          });
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
