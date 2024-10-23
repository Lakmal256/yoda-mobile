import 'dart:typed_data';

class UserDto {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? profilePicture;
  String? designation;
  String? dateOfBirth;
  String? mobile;
  DateTime? joiningDate;
  String? department;
  String? employeeNumber;

  Uint8List? imageBytes;

  UserDto();

  factory UserDto.fromJson(Map<String, dynamic> data) {
    var joiningDate = data["joiningDate"];
    joiningDate = joiningDate != null ? DateTime.tryParse(joiningDate) : null;
    return UserDto()
      ..id = data["id"]
      ..firstName = data["firstName"]
      ..lastName = data["lastName"]
      ..email = data["email"]
      ..profilePicture = data["profilePicture"]
      ..designation = data["designation"]
      ..dateOfBirth = data["dateOfBirth"]
      ..mobile = data["mobile"]
      ..joiningDate = joiningDate
      ..department = data["department"]
      ..employeeNumber = data["employeeNo"];
  }
}
