import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:redux/redux.dart';
import '../actions/signup_actions.dart';
import 'dart:core';
class SignupState {
  final String email;
  final String password;
  final bool isLoading;
  final String error;
  final String nameLoc;
  final String licenseLoc;
  final String privateKeyLoc;
  final String summary;
  SignupState({
    this.email = '',	
    this.password = '',
    this.isLoading = false,
    this.error = '',
    this.licenseLoc='',
    this.nameLoc='',
    this.privateKeyLoc='',
    this.summary=''
  });
 SignupState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? error,
    String? licenseLoc,
    String? nameLoc,
    String? privateKeyLoc,
    String? summary
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      licenseLoc: licenseLoc ?? this.licenseLoc,
      nameLoc:  nameLoc ?? this. nameLoc,
     privateKeyLoc: privateKeyLoc ?? this.privateKeyLoc,
     summary: summary ?? this.summary,

    );
  }
 
}


SignupState signupReducer(SignupState state, dynamic action) {
  if (action is UpdateEmailAction) {
    return state.copyWith(email: action.email);
  } else if (action is UpdatePasswordAction) {
    return state.copyWith(password: action.password); 
  }
  else if (action is UpdateSummaryAction) {
    return state.copyWith(summary: action.summary);
  }
   else if (action is UpdatelicenseLocAction) {
    return state.copyWith( licenseLoc: action.licenseLoc);
  } 
   else if (action is UpdatenameLocAction) {
    return state.copyWith(nameLoc: action.nameLoc);
  }
   else if (action is UpdateprivateKeyLocAction) {
    return state.copyWith( privateKeyLoc: action.privateKeyLoc);
  }
  else if (action is SignupRequestAction) {
   
    return state.copyWith(isLoading: true, error: '');
  } else if (action is SignupSuccessAction) {
   // print("sign up success");
    SignupSuccessAction();
    return state.copyWith(isLoading: false);
  } else if (action is SignupFailureAction) {
     print("sign up failure");
    return state.copyWith(isLoading: false, error: action.error);
  }
  return state;
}

