// class UserEntity {
//   final String id;
//   final String email;
//   final String name;

//   UserEntity({
//     required this.id,
//     required this.email,
//     required this.name, String? imageURL,
//   });
// }

class UserEntity {

  String ? fullName;
  String ? email;
  String ? imageURL;

  UserEntity({
    this.fullName,
    this.email,
    this.imageURL
  });
}