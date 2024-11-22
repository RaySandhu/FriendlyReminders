import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friendlyreminder/widgets/StyledTextField.dart';

class SuggestionTextField extends StatefulWidget {
  final TextEditingController controller;
  final List<String> allSuggestions;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final void Function(String)? onChanged;

  SuggestionTextField({
    Key? key,
    required this.controller,
    required this.allSuggestions,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.nextFocusNode,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLines = 1,
    this.onChanged,
  }) : super(key: key);

  @override
  _SuggestionTextFieldState createState() => _SuggestionTextFieldState();
}

class _SuggestionTextFieldState extends State<SuggestionTextField> {
  OverlayEntry? _overlayEntry;
  List<String> suggestions = [];

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)!.insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height,
        left: offset.dx,
        width: size.width,
        child: Material(
          elevation: 4.0,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(suggestions[index]),
                onTap: () {
                  setState(() {
                    widget.controller.text = suggestions[index];
                    _hideOverlay();
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)!.insert(_overlayEntry!);
    } else {
      _updateOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StyledTextField(
      controller: widget.controller,
      hintText: widget.hintText,
      prefixIcon: widget.prefixIcon,
      keyboardType: widget.keyboardType,
      focusNode: widget.focusNode,
      nextFocusNode: widget.nextFocusNode,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.maxLines,
      onChanged: (text) {
        setState(() {
          suggestions = widget.allSuggestions
              .where((suggestion) =>
                  suggestion.toLowerCase().contains(text.toLowerCase()))
              .toList();
          if (text.isNotEmpty && suggestions.isNotEmpty) {
            _showOverlay();
          } else {
            _hideOverlay();
          }
        });
        if (widget.onChanged != null) {
          widget.onChanged!(text);
        }
      },
    );
  }
}
