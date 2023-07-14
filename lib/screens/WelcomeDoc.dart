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
import './helperFunc/listDisplayPatientListInwelcomeDoctor.dart';
import './helperFunc/displaySummaryTable.dart';
import '../env.sample.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class ContentsOfList {
  String title;
  IconData image;
  ContentsOfList(this.title, this.image);
}
class WelcomeDoc extends StatelessWidget {
  final BuildContext context;
  WelcomeDoc({Key? key, required this.context}) : super(key: key);
  void summarizedText(SignupViewModel viewModel) async {
    try {
      final response = await http
          .post(Uri.parse("${Env.URL_PREFIX}/sum/summarizedPatdetails/"));
      
      
      //print("SUCCESS");
      if (response.statusCode == 200) {
        print(response.body);
          viewModel.onSummaryChanged(response.body);
      } else {
        print("FAIL");
      }
    } catch (e) {
      print(e.toString());
    }
    // final items = json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final List<ContentsOfList> infoBank = [
      ContentsOfList("Arun S", Icons.person),
      // ContentsOfList("Anita P", Icons.person),
    ];
    return StoreConnector<SignupState, SignupViewModel>(
      converter: (Store<SignupState> store) => SignupViewModel.fromStore(store),
      builder: (BuildContext context, SignupViewModel viewModel) => Scaffold(
       appBar: AppBar(
  automaticallyImplyLeading: false,
  title: Text('Welcome Doctor'),
  actions: <Widget>[
    IconButton(
      icon: Icon(Icons.logout),
      onPressed: () {
        // Do something
        router.go('/');
      },
    ),
  ],
),
        // appBar: AppBar(
        //   title: Text('Hi Doctor'),
        // ),
        // body: MyListItem(image: Icons.person,title: "hello",onViewRecordPressed:(() {
          
        // }),onViewSummaryPressed:() => {},)
         body: ListView.builder(
      itemCount: infoBank.length,
      itemBuilder: (context, index) {
        return MyListItem(
          title: infoBank[index].title,
          image: infoBank[index].image,
          onViewRecordPressed: () {
            // Handle View Record button press
            viewModel.onViewRecordButtonPressed();
          },
          onViewSummaryPressed: () {
            // Handle View Summary button press
            viewModel.onViewSummaryButtonPressed();
            router.go('/viewSummary');

          },
        );}
        // body:  Column(
        //   children: [
        //   //   ElevatedButton(
        //   //   // here is where I added my DecoratedBox
        //   //   onPressed: (){summarizedText(viewModel);},
        //   //   child: Text('Summarize document!'),
        //   // ),

        //    Expanded(child: SizedBox(height: 200.0,child: MyList(title: "PATIENT LIST", content: "HELLO", router: router))),
        //   //  Container(
        //   //                 padding: EdgeInsets.symmetric(horizontal: 20.0),
        //   //                 child: Text(
        //   //                   viewModel.summary
        //   //                 ),
        //   //               ),
            
        //   ]
        // ),
        
    //  body:    Column(
    //    children: [
    //      Expanded(child: MyList(title: "PATIENT LIST", content: "HELLO", router: router)),
    //    ],
    //  ),
          //  Container(
        //  body: MyList(content: "Hello",title:"table look", router:router),
        // body: PatientSummaryTable(content: "Hello",title:"table look", router:router),
    //  body: Container(
    //   padding: EdgeInsets.all(16),
    //   child: Row(
    //     children: [
    //       Icon(Icons.person),
    //       SizedBox(width: 16),
    //       Text("Hello"),
    //       Spacer(),
    //       Column(
    //         children: [
    //           ElevatedButton(
    //             onPressed: ()=>{},
    //             child: Text('View Record'),
    //           ),
    //             SizedBox(width: 2),
    //       ElevatedButton(
    //         onPressed: ()=>{},
    //         child: Text('View Summary'),
    //       ),
    //         ],
    //       ),
        
    //     ],))
      ),
    ));
  }
}

class SignupViewModel {
  final String email;
  final String password;
  final String nameLoc;
  final String licenseLoc;
  final String summary;
  final String privateKeyLoc;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final Function(String) onnameLocChanged;
  final Function(String) onlicenseLocChanged;
  final Function(String) onprivateKeyChanged;
  final Function(String) onSummaryChanged;
  final Function() onViewRecordButtonPressed;
  final Function() onViewSummaryButtonPressed;
  SignupViewModel({
    required this.email,
    required this.password,
    required this.summary,
    required this.nameLoc,
    required this.licenseLoc,
    required this.privateKeyLoc,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onnameLocChanged,
    required this.onlicenseLocChanged,
    required this.onprivateKeyChanged,
    required this.onViewRecordButtonPressed,
    required this.onViewSummaryButtonPressed,
    required this.onSummaryChanged
  });

  static SignupViewModel fromStore(Store<SignupState> store) {
    return SignupViewModel(
        email: store.state.email,
        password: store.state.password,
        summary:store.state.summary,
        nameLoc: store.state.nameLoc,
        licenseLoc: store.state.licenseLoc,
        privateKeyLoc: store.state.privateKeyLoc,
        onEmailChanged: (email) => store.dispatch(UpdateEmailAction(email)),
        
        onSummaryChanged: (summary) => store.dispatch(UpdateSummaryAction(summary)),
        onPasswordChanged: (password) =>
            store.dispatch(UpdatePasswordAction(password)),
        onnameLocChanged: (nameLoc) =>
            store.dispatch(UpdatelicenseLocAction(nameLoc)),
        onlicenseLocChanged: (licenseLoc) =>
            store.dispatch(UpdatelicenseLocAction(licenseLoc)),
        onprivateKeyChanged: (privateKey) =>
            store.dispatch(UpdateprivateKeyLocAction(privateKey)),
       onViewRecordButtonPressed: () {
          store.dispatch(loginThunkDoc);
        },
        onViewSummaryButtonPressed: () {
          store.dispatch(loginThunkDoc);
        }
        );
  }
}
