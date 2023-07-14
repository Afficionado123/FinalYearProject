
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import '../reducers/signupState.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'dart:io';
class UpdateEmailAction {
  final String email;

  UpdateEmailAction(this.email);

  @override
  String toString() {
    print("email $email");
    return 'UpdateEmailAction{email: $email}';
  }
}
class UpdateSummaryAction {
  final String summary;

  UpdateSummaryAction(this.summary);

  @override
  String toString() {
    print("summary $summary");
    return 'UpdateEmailAction{summary: $summary}';
  }
}
class UpdatePasswordAction {
  final String password;

  UpdatePasswordAction(this.password);

  @override
  String toString() {
    return 'UpdatePasswordAction{password: $password}';
  }
}

class UpdatelicenseLocAction {
  final String licenseLoc;

  UpdatelicenseLocAction(this.licenseLoc);

  @override
  String toString() {
    return 'UpdatelicenseLocAction{licenseLoc: $licenseLoc}';
  }
}
class UpdatenameLocAction{
  final String nameLoc;

  UpdatenameLocAction(this.nameLoc);

  @override
  String toString() {
    return 'UpdatenameLocAction{nameLoc: $nameLoc}';
  }
}
class UpdateprivateKeyLocAction{
  final String privateKeyLoc;

  UpdateprivateKeyLocAction(this.privateKeyLoc);

  @override
  String toString() {
    return 'UpdateprivateKeyLocAction{privateKey: $privateKeyLoc}';
  }
}
class SignupRequestAction {
   
     @override
  String toString() {
    print("Succesful signUp");
    return "Successful";
  }
}
class LoginRequestAction {
   
     @override
  String toString() {
    print("Succesful login");
    return "Successful";
  }
}

class SignupSuccessAction {

   @override
  String toString() {
   
    return ("hhhh");
  }
}

class SignupFailureAction {
  final String error;

  SignupFailureAction(this.error);

  @override
  String toString() {
    return 'SignupFailureAction{error: $error}';
  }
}
