import 'package:flutter/material.dart';
import './listDisplayPatientListInwelcomeDoctor.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/models/firebase_file.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart' as fd;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './modals.dart';
import '../../screens/viewRec.dart';
class ContentsOfList {
  String title;
  IconData image;
  ContentsOfList(this.title, this.image);
}
class MyListWithCircleButton extends StatelessWidget {
  final List<ContentsOfList> infoBank;
  final BuildContext context;
   MyListWithCircleButton({Key? key, required this.infoBank, required this.context}) : super(key: key);
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
      print(fileName);
      if(result.files.isNotEmpty){
        String? path = result.files.single.path;
        file = File(path!);
        savePdf(fileName, file);
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
    documentFileUpload(url);
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
     
    return Stack(
      children: [
        ListView.builder(
          itemCount: infoBank.length,
          itemBuilder: (context, index) {
           return  MyListItemPatientWelcome(
          title: infoBank[index].title,
          image: infoBank[index].image,
          onViewRecordPressed: () {
            // Handle View Record button press
            // const pdfPath = "assets/DocumentToBeSummarized.pdf";
            // router.go(Uri(path: '/pdf/', queryParameters: {'pdfPath': 'DocumentToBeSummarized.pdf'}).toString());
            // router.go(Uri(path: '/pdf', queryParameters: {'pdfPath': pdfPath}).toString());
            // router.go(Uri(path: '/viewSummary'));
            // final decodedPath = Uri.decodeComponent(pdfPath);
            // final String location =router.namedLocation('pdf', pathParameters: {'pdfPath': decodedPath});
            // print(location);
            router.go('/view');
          },
          onViewSummaryPressed: () {
            // Handle View Summary button press
            router.go('/viewSummary');
          },
        );
          },
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () async{
              // Handle button press
              await getPdfAndUpload();
                
                            await showDialog(
            context: context,
            builder: (BuildContext context) {
                return MyModal(
                    title: 'Upload status ',
                    content: 'Upload successful!',
                    router: router,
                );
            });
            },
            child: Icon(Icons.add),
          ),
        ),
        
        Positioned(
          bottom: 16.0,
          left:16.0,
          
          child: ElevatedButton(
            onPressed: () async{
              // Handle button press
               //router.go('/viewSummary');
      
                        
               router.go('/giveAccess');
            },
            child: Text("Give Access"),
          ))
      ],
    );
  }
}
