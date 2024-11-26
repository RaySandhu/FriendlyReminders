import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/models/GroupModel.dart';

class ContactWithInterestsModel {
  final ContactModel contact;
  final List<GroupModel> interests;

  const ContactWithInterestsModel({
    required this.contact,
    required this.interests,
  });

  @override
  String toString() {
    return 'ContactWithInterestsModel{contact: $contact, interests: $interests}';
  }
}
