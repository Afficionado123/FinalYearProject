
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import '../reducers/loginState.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'dart:io';
class UpdatePrivateKeyAction {
  final String privateKey;

  UpdatePrivateKeyAction(this.privateKey);

  @override
  String toString() {
    print("logInPrivateKey $privateKey");
    return 'UpdatePrivateKeyAction{email: $privateKey}';
  }
}

// class UpdatelicenseLocAction {
//   final String licenseLoc;

//   UpdatelicenseLocAction(this.licenseLoc);

//   @override
//   String toString() {
//     return 'UpdatelicenseLocAction{licenseLoc: $licenseLoc}';
//   }
// }
// class UpdatenameLocAction{
//   final String nameLoc;

//   UpdatenameLocAction(this.nameLoc);

//   @override
//   String toString() {
//     return 'UpdatenameLocAction{nameLoc: $nameLoc}';
//   }
// }
// class UpdateprivateKeyLocAction{
//   final String privateKeyLoc;

//   UpdateprivateKeyLocAction(this.privateKeyLoc);

//   @override
//   String toString() {
//     return 'UpdateprivateKeyLocAction{privateKey: $privateKeyLoc}';
//   }
// }
class LoginRequestAction {
   
     @override
  String toString() {
    print("Succesful Login of Hospital!");
    return "Successful";
  }
}

class LoginSuccessAction {

   @override
  String toString() {
   
    return ("hhhh");
  }
}

class LoginFailureAction {
  final String error;

  LoginFailureAction(this.error);

  @override
  String toString() {
    return 'LoginFailureAction{error: $error}';
  }
}
