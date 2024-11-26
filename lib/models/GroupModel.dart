class GroupModel {
  final int? id;
  final String name;

  const GroupModel({
    this.id,
    required this.name,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['GroupId'] as int?,
      name: map['GroupName'] as String,
    );
  }

  update({String? name}) {
    return GroupModel(
      id: this.id, // id stays the same
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'GroupId': id, // This will be null for new records
      'GroupName': name,
    };
  }

  @override
  String toString() {
    return 'GroupModel{GroupId: $id, GroupName: $name}';
  }
}
