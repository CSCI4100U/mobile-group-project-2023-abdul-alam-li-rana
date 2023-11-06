import 'dart:typed_data';

class Account{
  String? email;
  Uint8List? profilePicture;

  Account({
    required this.email,
    required this.profilePicture
  });

  Account.fromMap(Map map){
    email = map['email'];
    profilePicture = map['profilePicture'];
  }

  Map<String, dynamic> toMap() => {
    "email" : email,
    "profilePicture" : profilePicture,
  };

  @override
  String toString(){
    return 'Account[email]: $email, profilePicture: $profilePicture';
  }

        
}