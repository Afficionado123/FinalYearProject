import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../main.dart';
import './router.dart';
import '../../env.sample.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class ContentsOfList {
  String title;
  IconData image;
  ContentsOfList(this.title, this.image);
}
class PatientSummaryTable extends StatelessWidget {
  final String title;
  final String content;
  // final GoRouter router;
  final BuildContext context;
  Widget _buildWidget() {
    return Text('Hello World!');
  }
  const PatientSummaryTable({Key? key, required this.title, required this.content, required this.context})
      : super(key: key);
  Future<Widget> summarizedText() async {
    try {
      final response = await http.post(Uri.parse("${Env.URL_PREFIX}/sum/summarizedPatdetails/"));
     
  
      //print("SUCCESS");
      if (response.statusCode == 200) {
        print(response.body);
          // viewModel.onSummaryChanged(response.body);
        return Text(response.body);
      } else {
        print("FAIL");
         return Text("Fail");
      }
    } catch (e) {
      print(e.toString());
    }
    return Text("No summary");
    // final items = json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final List<ContentsOfList> infoBank = [
    ContentsOfList("Arun S", Icons.person),
    // ContentsOfList("Anita P", Icons.person),
  ];
  
    return Scaffold(
      // appBar: AppBar(
      //     title: Text('Summary'),
      //   ),
      
      backgroundColor: Colors.white,
      body: 
     
         ListView.separated(
          itemCount: infoBank.length,
         
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            return Column(
              
            children:<Widget>[
              AppBar(
  backgroundColor: Colors.blue,
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      // Do something when the back arrow is pressed.
       router.go('/welcomeDoctor');
    },
  ),
),

              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text("Table",textScaleFactor: 0.01,style: TextStyle(fontWeight:FontWeight.bold,fontSize:5),),
              ),
            

              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Table(
                 
                 textDirection: TextDirection.rtl,
                 defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                 border:TableBorder.all(width: 2.0,color: Colors.blue),
                children: [
                  TableRow(
                    children: [
                      Padding(  padding: const EdgeInsets.all(8.0),child: Text("Date",textScaleFactor: 2,)),
                       Padding(  padding: const EdgeInsets.all(8.0),child: Text("Medical summary",textScaleFactor: 2,)),
                    
                    
                    ]
                  ),
                   TableRow(
                    children: [
                       TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child:   Center(child: Text("From 6th May 2001-9th May 2008",textScaleFactor: 2)),
            )),
                      Padding(padding: const EdgeInsets.all(10),child: Text("He denies any symptoms of coronary heart disease, but he probably has some degree of coronary atherosclerosis, possibly affecting the inferior wall by functional testings.If indeed, he is considered to be a diabetic, a much more aggressive program should be entertained for reducing the risks of atherosclerosis in general, and coronary artery disease in particular.",textScaleFactor: 1)),
                     
                    ]
                  ),
                  TableRow(
                    children: [
                      TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child:   Center(child: Text("From 8th May 2008-9th May 2018",textScaleFactor: 2)),
            )),
                    
                      Padding(  padding: const EdgeInsets.all(10),child: FutureBuilder<Widget>(
      future: summarizedText(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },),)
                     
                    ]
                  ),
                 
                ],
            ),
           
              ),
            ]
          );
          },
        ),
      );
    
}

}