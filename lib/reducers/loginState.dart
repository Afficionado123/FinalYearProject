import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:redux/redux.dart';
import '../actions/login_actions.dart';
import 'dart:core';
class LoginState {
  final String privateKey;
  final bool isLoading;
  final bool isLoggedIn;
  LoginState({
      this.privateKey='',
      this.isLoading= false,
      this.isLoggedIn=false

  });
 LoginState copyWith({
    String? privateKey,
    bool? isLoading
  }) {
    return LoginState(
     privateKey: privateKey ?? this.privateKey,
     isLoading: isLoading ?? this.isLoading,
    );
  }
 
}


// LoginState loginReducer(LoginState state, dynamic action) {
//   if (action is UpdatePrivateKeyAction ) {
//     return state.copyWith(privateKey: action.privateKey);
//   } 
//   else if (action is LoginRequestAction) {
   
//     return state.copyWith(isLoading: true, error: '');
//   } else if (action is SignupSuccessAction) {
//    // print("sign up success");
//     SignupSuccessAction();
//     return state.copyWith(isLoading: false);
//   } else if (action is SignupFailureAction) {
//      print("sign up failure");
//     return state.copyWith(isLoading: false, error: action.error);
//   }
//   return state;
// }

