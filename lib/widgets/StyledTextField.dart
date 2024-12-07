import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StyledTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final void Function(String)? onChanged;
  final bool padding;
  final void Function(String)? onSubmitted;
  const StyledTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.nextFocusNode,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLines = 1,
    this.onChanged,
    this.padding = true,
    this.onSubmitted,
  });

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
    return Padding(
      padding: EdgeInsets.all(widget.padding ? 8 : 0),
      child: Stack(
        children: [
          TextField(
            controller: widget.controller,
            maxLines: widget.maxLines,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,
            textCapitalization: widget.textCapitalization,
            textInputAction: widget.nextFocusNode != null
                ? TextInputAction.next
                : TextInputAction.done,
            inputFormatters: widget.inputFormatters,
            onSubmitted: (value) {
              widget.onSubmitted;
              if (widget.nextFocusNode != null) {
                FocusScope.of(context).requestFocus(widget.nextFocusNode);
              }
            },
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(widget.prefixIcon, color: Colors.transparent),
              suffixIcon: isEmpty
                  ? null
                  : const IconButton(
                      icon: Icon(Icons.close, color: Colors.transparent),
                      onPressed: null,
                    ),
              // labelText: widget.hintText,
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: EdgeInsets.all(10),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                child: Icon(widget.prefixIcon),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: !isEmpty ? Colors.grey : Colors.transparent,
                ),
                onPressed: !isEmpty ? () => widget.controller.clear() : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
