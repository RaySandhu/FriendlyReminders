class GroupModel implements Comparable<GroupModel> {
  final int? id;
  final String name;
  final int? size;

  const GroupModel({
    this.id,
    required this.name,
    this.size,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['GroupId'] as int?,
      name: map['GroupName'] as String,
      size: map['GroupSize'] as int?,
    );
  }

  update({String? name, int? size}) {
    return GroupModel(
      id: this.id, // id stays the same
      name: name ?? this.name,
      size: size ?? this.size,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'GroupId': id, // This will be null for new records
      'GroupName': name,
      'GroupSize': size,
    };
  }

  @override
  int compareTo(GroupModel other) {
    return name.compareTo(other.name);
  }

  @override
  String toString() {
    return 'GroupModel{GroupId: $id, GroupName: $name GroupSize: $size}';
  }
}
