import 'package:friendlyreminder/models/ContactModel.dart';

class ContactWithInterestsModel {
  final ContactModel contact;
  final List<String> interests;

  const ContactWithInterestsModel({
    required this.contact,
    required this.interests,
  });

  @override
  String toString() {
    return 'ContactWithInterestsModel{contact: $contact, interests: $interests}';
  }
}
