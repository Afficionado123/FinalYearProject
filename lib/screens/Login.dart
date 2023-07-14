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

class LoginScreen extends StatelessWidget {
 final BuildContext context;

 LoginScreen({Key? key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    return StoreConnector<SignupState, SignupViewModel>(
        converter: (Store<SignupState> store) => SignupViewModel.fromStore(store),
        builder: (BuildContext context, SignupViewModel viewModel) => Scaffold(
        backgroundColor: Color.fromRGBO(199,246,245,1.0),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: (MediaQuery.of(context).size.height /2)-200
            ),
            Container(
              padding: EdgeInsets.all(20.0),

              child: Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: RoundedDiagonalPathClipper(),
                    child: Container(
                      height: 400,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        color: Colors.white,
                      ),
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 90.0,),
                         Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextField(
                              cursorColor: Color.fromRGBO(10,145,171,1.0),
                                onChanged: (hosName) => viewModel.onnameLocChanged(hosName),
                              style: TextStyle(color: Color.fromRGBO(10,145,171,1.0)),
                              decoration: InputDecoration(
                                  hintText: "Hospital Name",
                                  hintStyle: TextStyle(color: Color.fromRGBO(10,145,171,1.0)),
                                  border: InputBorder.none,
                                  icon: Icon(Icons.lock, color: Color.fromRGBO(10,145,171,1.0),)
                              ),
                            )
                        ),
                         Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextField(
                              cursorColor: Color.fromRGBO(10,145,171,1.0),
                                onChanged: (licenseLoc) => viewModel.onlicenseLocChanged(licenseLoc),
                              style: TextStyle(color: Color.fromRGBO(10,145,171,1.0)),
                              decoration: InputDecoration(
                                  hintText: "License Number",
                                  hintStyle: TextStyle(color: Color.fromRGBO(10,145,171,1.0)),
                                  border: InputBorder.none,
                                  icon: Icon(Icons.lock, color: Color.fromRGBO(10,145,171,1.0),)
                              ),
                            )
                        ),
                         Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextField(
                              cursorColor: Color.fromRGBO(10,145,171,1.0),
                                onChanged: (privateKey) => viewModel.onprivateKeyChanged(privateKey),
                              style: TextStyle(color: Color.fromRGBO(10,145,171,1.0)),
                              decoration: InputDecoration(
                                  hintText: "Private Key",
                                  hintStyle: TextStyle(color: Color.fromRGBO(10,145,171,1.0)),
                                  border: InputBorder.none,
                                  icon: Icon(Icons.lock, color: Color.fromRGBO(10,145,171,1.0),)
                              ),
                            )
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            cursorColor: Color.fromRGBO(10,145,171,1.0),
                            onChanged: (email) => viewModel.onEmailChanged(email),
                            style: TextStyle( color: Color.fromRGBO(10,145,171,1.0)),
                            decoration: InputDecoration(
                                hintText: "Email address",
                                
                                hintStyle: TextStyle(color: Color.fromRGBO(10,145,171,1.0)),
                                border: InputBorder.none,
                                icon: Icon(Icons.email, color: Color.fromRGBO(10,145,171,1.0),)
                            ),
                          ),
                        ),
                     
                        Container(child: Divider(color: Color.fromRGBO(10,145,171,1.0),), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: TextButton(
                                child: Text('Forgot Password', style: TextStyle(color: Color.fromRGBO(10,145,171,1.0),),),
                               
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                      ],
                    ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Color.fromRGBO(10,145,171,1.0),
                        child: Icon(Icons.medical_information),
                      ),
                    ],
                  ),
                  Container(
                    height: 420,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () async{
                          try{
                               viewModel.onSignupButtonPressed();
                          
                            await showDialog(
            context: context,
            builder: (BuildContext context) {
                return MyModal(
                    title: 'SignUp Status',
                    content: 'SignUp Successful!',
                    router: router,
                );
            },
        );
                          }
                       
                          catch(e){
                            print("error");
                          }
                          
                       
                        print(viewModel.email);
                      },

                        style:ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                        backgroundColor: Color.fromRGBO(10,145,171,1.0),
                        ),
                        child: Text("Sign Up", style: TextStyle(color: Colors.white)),
                       
                       
                      ),
                      
                      
                    ),
                  ),
                 
                ],
                
              ),
            ),
              Container(
                              child: TextButton(
                                child: Text("Already have an account? Login", style: TextStyle(color: Color.fromRGBO(10,145,171,1.0),),),
                               
                                onPressed: () {router.go('/loginDoctor');},
                              ),
                            ),
          ],
        ),
    ));
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
