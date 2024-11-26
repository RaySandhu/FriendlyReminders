class ContactInterestModel {
  final int contactId;
  final int groupId;

  const ContactInterestModel({
    required this.contactId,
    required this.groupId,
  });

  factory ContactInterestModel.fromMap(Map<String, dynamic> map) {
    return ContactInterestModel(
      contactId: map['ContactId'] as int,
      groupId: map['GroupId'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ContactId': contactId,
      'GroupId': groupId,
    };
  }

  @override
  String toString() {
    return 'ContactInterest{ContactId: $contactId, GroupId: $groupId}';
  }
}
