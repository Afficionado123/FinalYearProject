import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/models/firebase_file.dart';
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
import './helperFunc/listDisplayPatientListInwelcomePatient.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart' as fd;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './viewRec.dart';

 class PDFViewerFromUrl extends StatelessWidget {
   const PDFViewerFromUrl({Key? key, required this.url}) : super(key: key);

   final String url;

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: const Text('PDF From Url'),
       ),
       body: const PDF().fromUrl(
         url,
         placeholder: (double progress) => Center(child: Text('$progress %')),
         errorWidget: (dynamic error) => Center(child: Text(error.toString())),
       ),
     );
   }
 }

class WelcomePatient extends StatelessWidget {
 final BuildContext context;

 WelcomePatient({Key? key, required this.context}) : super(key: key);

 Future getPdfAndUpload() async{
    var rng = Random();
    String randomName="";

    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }

    File file;
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    

    if (result != null ) {
      String fileName = '$randomName.pdf';
      String url;
      print(fileName);
      if(result.files.isNotEmpty){
        String? path = result.files.single.path;
        file = File(path!);
        url = await savePdf(fileName, file);
      }
    } else {
      print("No file selected");
    }
  }

  final mainReference = fd.FirebaseDatabase.instance.reference().child('Database');
  Future savePdf(String name, File pdfFile) async {
    // await FirebaseAuth.instance.signInAnonymously();
    Reference reference = FirebaseStorage.instance.ref().child(name);
    UploadTask uploadTask = reference.putFile(pdfFile, SettableMetadata(contentType: 'pdf'));
    String url = await (await uploadTask).ref.getDownloadURL();
    print(url);
    // documentFileUpload(url);
    return  url;
  }

  void documentFileUpload(String str) {
    var data = {
      "PDF": str,
    };
    mainReference.child("Documents").child('pdf').set(data).then((v) {
       
    });
  }
   static Future <List<String>> _getDownloadLink(List<Reference> refs)=>Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());
   static Future <List<FirebaseFile>> listAll(String path) async{
       final ref=FirebaseStorage.instance.ref(path);
       final result= await ref.listAll();
       final urls=await _getDownloadLink(result.items);
       return urls.
              asMap()
              .map((index, url){
                final ref=result.items[index];
                final name=ref.name;
                final file= FirebaseFile(ref:ref,name:name,url:url);
                return MapEntry(index, file);
              } )
              .values
              .toList();
  }
 void getDocumentDets() async{
  final snapshot = await mainReference.child("Documents").child('pdf').get();
if (snapshot.exists) {
      print(snapshot.value);
      print(PDF().cachedFromUrl(snapshot.value.toString()));
    
} else {
    print('No data available.');
}
 }
  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final List<ContentsOfList> infoBank = [
      ContentsOfList("2-D Doppler", Icons.heat_pump_rounded),
      ContentsOfList("2-D Echocardiogram - 1", Icons.heat_pump_rounded),
      ContentsOfList("Echocardiogram and Doppler", Icons.heat_pump_rounded),
      ContentsOfList("Abnormal Echocardiogram", Icons.heat_pump_rounded),
      ContentsOfList("Abnormal Stress Test", Icons.heat_pump_rounded),
      
    ];
    return StoreConnector<SignupState, SignupViewModel>(
        converter: (Store<SignupState> store) => SignupViewModel.fromStore(store),
        builder: (BuildContext context, SignupViewModel viewModel) =>Scaffold(

        appBar: AppBar(
  automaticallyImplyLeading: false,
  title: Text('Welcome Patient'),
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
	      //  appBar: AppBar(
	      //    title: Text('Welcome Arun!'),
	      //  ),
	      //  body: Column(
        //            children: [Center(
        //              child: ElevatedButton(
        //                 child: DecoratedBox( // here is where I added my DecoratedBox
        //                   decoration: BoxDecoration(color: Colors.lightBlueAccent),
        //                   child: Text('UPLOAD RECORD!'),
        //                 ),
        //                 onPressed: () => { getPdfAndUpload()},
        //               ),
        //            ),Center(
        //              child: ElevatedButton(
        //                 child: DecoratedBox( // here is where I added my DecoratedBox
        //                   decoration: BoxDecoration(color: Colors.lightBlueAccent),
        //                   child: Text('VIEW RECORD!'),
        //                 ),
        //                 onPressed: () => { print(listAll('/files'))},
        //               ),
        //            )],
        //          ),
        //body:ImageViewer()
        body:MyListWithCircleButton(infoBank: infoBank,context:context)
        //body: Text("hello")
	     ),
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
