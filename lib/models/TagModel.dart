class TagModel {
  final int? tagId;
  final int contactId;
  final int interestId;

  const TagModel({
    this.tagId,
    required this.contactId,
    required this.interestId,
  });

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      tagId: map['TagId'] as int?,
      contactId: map['ContactId'] as int,
      interestId: map['InterestId'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'TagId': tagId, // This will be null for new records
      'ContactId': contactId,
      'InterestId': interestId,
    };
  }

  @override
  String toString() {
    return 'Tag{TagId: $tagId, ContactId: $contactId, InterestId: $interestId}';
  }
}
