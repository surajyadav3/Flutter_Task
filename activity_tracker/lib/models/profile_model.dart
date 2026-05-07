class ProfileModel {
  String userId;
  String name;
  int age;
  double weight;
  int stepsTarget;

  ProfileModel({
    required this.userId,
    required this.name,
    required this.age,
    required this.weight,
    required this.stepsTarget,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'name': name,
        'age': age,
        'weight': weight,
        'stepsTarget': stepsTarget,
      };

  factory ProfileModel.fromMap(Map<String, dynamic> map) => ProfileModel(
        userId: map['userId'] ?? '',
        name: map['name'] ?? '',
        age: map['age'] ?? 0,
        weight: (map['weight'] ?? 0).toDouble(),
        stepsTarget: map['stepsTarget'] ?? 10000,
      );
}
