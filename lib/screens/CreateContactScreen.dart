import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';
import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/widgets/StyledTextField.dart';
import 'package:friendlyreminder/utilities/PhoneNumberFormatter.dart';

class CreateContactScreen extends StatefulWidget {
  CreateContactScreen({super.key});

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List<String> _suggestions = [];
  @override
  State<CreateContactScreen> createState() => _CreateContactScreenState();
}

class _CreateContactScreenState extends State<CreateContactScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _reminderController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final contactVM = Provider.of<ContactsViewModel>(context, listen: false);

    void _hideOverlay() {
      widget._overlayEntry?.remove();
      widget._overlayEntry = null;
    }

    OverlayEntry _createOverlayEntry() {
      return OverlayEntry(
        builder: (context) => Positioned(
          width: 300,
          child: CompositedTransformFollower(
            link: widget._layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, 50),
            child: Material(
              elevation: 4.0,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget._suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget._suggestions[index]),
                    onTap: () {
                      setState(() {
                        _tagController.text = widget._suggestions[index];
                        _hideOverlay();
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );
    }

    void _showOverlay() {
      if (widget._overlayEntry == null) {
        widget._overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(widget._overlayEntry!);
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create New Contact",
            style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              child: Text("Done"),
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  ContactModel newContact = ContactModel(
                      name: _nameController.text,
                      phone: _phoneController.text,
                      email: _emailController.text,
                      notes: _noteController.text);
                  contactVM.createContact(newContact, []); // REM
                  _nameController.clear();
                  _phoneController.clear();
                  _emailController.clear();
                  _noteController.clear();
                  Navigator.pop(context);
                }
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: Size(0, 0),
              ),
            ),
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            StyledTextField(
              controller: _nameController,
              hintText: "Name",
              prefixIcon: Icons.people,
              focusNode: _nameFocusNode,
              nextFocusNode: _phoneFocusNode,
              textCapitalization: TextCapitalization.words,
            ),
            StyledTextField(
              controller: _phoneController,
              hintText: "Phone",
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              focusNode: _phoneFocusNode,
              nextFocusNode: _emailFocusNode,
              inputFormatters: [PhoneNumberFormatter()],
            ),
            StyledTextField(
              controller: _emailController,
              hintText: "Email",
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              focusNode: _emailFocusNode,
            ),
            // StyledTextField(
            //   controller: _tagController,
            //   hintText: "Tags",
            //   prefixIcon: Icons.label,
            //   onChanged: (text) {
            //     setState(() {
            //       widget._suggestions = contactVM
            //           .getAllUniqueInterests(contactVM.contacts)
            //           .where((interest) =>
            //               interest.toLowerCase().contains(text.toLowerCase()))
            //           .toList();
            //       print(widget._suggestions);
            //       _tagController.text.isNotEmpty;
            //     });
            //   },
            // ),
            // if (widget._suggestions.isNotEmpty)
            //   Expanded(
            //     child: ListView.builder(
            //       itemCount: widget._suggestions.length,
            //       itemBuilder: (context, index) {
            //         return ListTile(
            //           title: Text(widget._suggestions[index]),
            //           onTap: () {
            //             setState(() {
            //               _tagController.text = widget._suggestions[index];
            //               widget._suggestions.clear();
            //             });
            //           },
            //         );
            //       },
            //     ),
            //   ),
            CompositedTransformTarget(
              link: widget._layerLink,
              child: StyledTextField(
                controller: _tagController,
                hintText: "Tags",
                prefixIcon: Icons.label,
                onChanged: (text) {
                  setState(() {
                    widget._suggestions = contactVM
                        .getAllUniqueInterests(contactVM.contacts)
                        .where((interest) =>
                            interest.toLowerCase().contains(text.toLowerCase()))
                        .toList();
                    if (widget._suggestions.isNotEmpty && text.isNotEmpty) {
                      _showOverlay();
                    } else {
                      _hideOverlay();
                    }
                  });
                },
              ),
            ),
            StyledTextField(
                controller: _reminderController,
                hintText: "Reminders",
                prefixIcon: Icons.schedule),
            StyledTextField(
                controller: _noteController,
                hintText: "Notes",
                prefixIcon: Icons.description,
                maxLines: null),
          ],
        ),
      ),
    );
  }
}
