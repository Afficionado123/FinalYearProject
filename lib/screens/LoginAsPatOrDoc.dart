import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import '../reducers/signupState.dart';
import 'package:flutter/material.dart';
import '../actions/signup_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../middleware/signupmiddleware.dart';
import 'package:go_router/go_router.dart';
import './helperFunc/modals.dart';

class LoginThreeState extends StatelessWidget{
  final BuildContext context;

 LoginThreeState({Key? key, required this.context}) : super(key: key);
 @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    return StoreConnector<SignupState, SignupViewModel>(
        converter: (Store<SignupState> store) => SignupViewModel.fromStore(store),
        builder: (BuildContext context, SignupViewModel viewModel) => Scaffold(
        backgroundColor: Color.fromRGBO(199,246,245,1.0),
        body: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () => router.go('/signUpPatient'),
              child: Card(
                     
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child:Column(
                        children: [Image(image: AssetImage('assets/patientInitial.jpg'),
                        fit: BoxFit.fill,
                        
                        ),
                        Text("PATIENT", style: TextStyle(fontSize: 25))
                        ]
                      ),
                      
                      shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.fromLTRB(10, 90, 10, 30),
                      
                    ),
            ),
        GestureDetector(
           onTap: () => router.go('/signUpDoctor'),
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              children: [Image(image: AssetImage('assets/doctorInitial.jpg'),
              fit: BoxFit.fill
              ),
              Text("DOCTOR", style: TextStyle(fontSize: 25),)
              ]
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: EdgeInsets.fromLTRB(10, 30, 10, 30),
          ),
        ),
          ],
        ),
    )
);
  }
}

class SignupViewModel {
  final String email;
  final String password;
  final String nameLoc;
  final String licenseLoc;
  final String privateKeyLoc;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final Function(String) onnameLocChanged;
  final Function(String) onlicenseLocChanged;
  final Function(String) onprivateKeyChanged;
  final Function() onSignupButtonPressed;

  SignupViewModel({
    required this.email,
    required this.password,
    required this.nameLoc,
    required this.licenseLoc,
    required this.privateKeyLoc,

    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onnameLocChanged,
    required this.onlicenseLocChanged,
    required this.onprivateKeyChanged,
    required this.onSignupButtonPressed,
  });

  static SignupViewModel fromStore(Store<SignupState> store) {
    return SignupViewModel(
        email: store.state.email,
        password: store.state.password,
        nameLoc: store.state.nameLoc,
        licenseLoc: store.state.licenseLoc,
        privateKeyLoc: store.state.privateKeyLoc,
        onEmailChanged: (email) => store.dispatch(UpdateEmailAction(email)),
        onPasswordChanged: (password) =>
            store.dispatch(UpdatePasswordAction(password)),
        onnameLocChanged: (nameLoc) => store.dispatch(UpdatelicenseLocAction(nameLoc)),
        onlicenseLocChanged: (licenseLoc) => store.dispatch(UpdatelicenseLocAction(licenseLoc)),
        onprivateKeyChanged: (privateKey) => store.dispatch(UpdateprivateKeyLocAction(privateKey)),
        onSignupButtonPressed: () {
          store.dispatch(signupThunkDoc);
        });
  }
}
