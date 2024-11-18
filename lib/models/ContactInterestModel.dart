class ContactInterestModel {
  final int contactId;
  final int interestId;

  const ContactInterestModel({
    required this.contactId,
    required this.interestId,
  });

  factory ContactInterestModel.fromMap(Map<String, dynamic> map) {
    return ContactInterestModel(
      contactId: map['ContactId'] as int,
      interestId: map['InterestId'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ContactId': contactId,
      'InterestId': interestId,
    };
  }

  @override
  String toString() {
    return 'ContactInterest{ContactId: $contactId, InterestId: $interestId}';
  }
}
