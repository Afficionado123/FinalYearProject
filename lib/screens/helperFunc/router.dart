import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../Login.dart';
import '../LoginAsPatOrDoc.dart';
import '../SignUp.dart';
import '../WelcomeDoc.dart';
import '../WelcomePatient.dart';
import '../LoginDoctor.dart';
import '../LoginPatient.dart';
import './displaySummaryTable.dart';
import '../SignUpPatient.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../../main.dart';
import './viewRecord.dart';
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {

       return LoginThreeState(context:context);
       // return LoginScreen(context:context);
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'signUpDoctor',
          builder: (BuildContext context, GoRouterState state) {
            return LoginScreen(context:context);
          },
        ),
        GoRoute(
          path: 'signUpPatient',
          builder: (BuildContext context, GoRouterState state) {
            return SignUpPatient(context:context);
          },
        ),
         GoRoute(
          path: 'loginPage',
          builder: (BuildContext context, GoRouterState state) {
            return   AddUser("ddd","eeee",9,context);
          
          },
        ),
        GoRoute(
          path: 'loginPatient',
          builder: (BuildContext context, GoRouterState state) {
            return LoginPatient(context: context,);
          
          },
        ),
         GoRoute(
          path: 'loginDoctor',
          builder: (BuildContext context, GoRouterState state) {
            return  LoginDoctor(context: context);
          
          },
            
        ),
         GoRoute(
          path: 'welcomePatient',
          builder: (BuildContext context, GoRouterState state) {
            return   WelcomePatient(context: context);
          
          },
            
        ), GoRoute(
          path: 'welcomeDoctor',
          builder: (BuildContext context, GoRouterState state) {
            return   WelcomeDoc(context: context);
          
          },
            
        ),
        GoRoute(
          path: 'viewPatientRecordsByDoc',
          builder: (BuildContext context, GoRouterState state) {
            return   WelcomeDoc(context: context);
          
          },
            
        ),
        GoRoute(
          path: 'viewSummary',
          name:"df",
          builder: (BuildContext context, GoRouterState state) {
            return  PatientSummaryTable(title:"Patient Summary",content: "Content/Summary",context:context);
          
          },
            
        ),
        GoRoute(
            path: 'pdf/',
            name: 'pdf',
            pageBuilder: (context, state) {
        final pdfPath = state.queryParameters['pdfPath']!;
        final decodedPath = Uri.decodeComponent(pdfPath);
  
     return PdfViewPage(pdfPath: decodedPath ) as Page<dynamic>;
      },

          ),
        
      ],
    ),
  ],
);