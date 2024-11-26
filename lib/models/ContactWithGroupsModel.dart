import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/models/GroupModel.dart';

class ContactWithGroupsModel {
  final ContactModel contact;
  final List<GroupModel> groups;

  const ContactWithGroupsModel({
    required this.contact,
    required this.groups,
  });

  @override
  String toString() {
    return 'ContactWithGroupsModel{contact: $contact, groups: $groups}';
  }
}
