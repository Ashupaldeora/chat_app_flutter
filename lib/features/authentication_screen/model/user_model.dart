class UserModel {
  final String email, profilePic, name, uid, deviceToken;

  final bool isOnline;
  final List<String> searchableKeywords;

  UserModel({
    required this.email,
    required this.profilePic,
    required this.name,
    required this.uid,
    required this.isOnline,
    required this.searchableKeywords,
    required this.deviceToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'profilePic': profilePic,
      'name': name,
      'uid': uid,
      'isOnline': isOnline,
      'searchableKeywords': searchableKeywords,
      'deviceToken': deviceToken
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? "",
      profilePic: map['profilePic'] ?? "",
      name: map['name'] ?? "",
      uid: map['uid'] ?? "",
      isOnline: map['isOnline'] as bool,
      searchableKeywords: List<String>.from(
        map['searchableKeywords'] ?? <dynamic>[],
      ),
      deviceToken: map['deviceToken'] ?? "",
    );
  }

  UserModel copyWith({
    String? email,
    String? profilePic,
    String? name,
    String? uid,
    bool? isOnline,
    List<String>? searchableKeywords,
    String? deviceToken,
  }) {
    return UserModel(
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      name: name ?? this.name,
      uid: uid ?? this.uid,
      isOnline: isOnline ?? this.isOnline,
      searchableKeywords: searchableKeywords ?? this.searchableKeywords,
      deviceToken: deviceToken ?? this.deviceToken,
    );
  }
}
