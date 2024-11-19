class InterestModel {
  final int? id;
  final String name;

  const InterestModel({
    this.id,
    required this.name,
  });

  factory InterestModel.fromMap(Map<String, dynamic> map) {
    return InterestModel(
      id: map['InterestId'] as int?,
      name: map['InterestName'] as String,
    );
  }

  update({String? name}) {
    return InterestModel(
      id: this.id, // id stays the same
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'InterestId': id, // This will be null for new records
      'InterestName': name,
    };
  }

  @override
  String toString() {
    return 'Interest{InterestId: $id, InterestName: $name}';
  }
}
