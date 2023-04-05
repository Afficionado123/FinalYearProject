import 'package:english_words/english_words.dart';
import 'package:redux/redux.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/LoginAsPatOrDoc.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' as rootBundle;
import 'dart:io';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:web_socket_channel/io.dart';
import './screens/SignUp.dart';
import './screens/LoginAsPatOrDoc.dart';
import 'package:redux_thunk/redux_thunk.dart';
import './reducers/signupState.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import './screens/Login.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
bool shouldUseFirestoreEmulator = false;
Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (shouldUseFirestoreEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }
  final store = Store<SignupState>(
    signupReducer,
    initialState: SignupState(),
    middleware: [thunkMiddleware],
  );
  
  
 // runApp( MyApp());
  runApp(MyApp(store: store,router: _router));
}
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {

        return AddUser("ddd","eeee",9,context);
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details',
          builder: (BuildContext context, GoRouterState state) {
            return LoginThreeState();
          },
        ),
         GoRoute(
          path: 'loginPage',
          builder: (BuildContext context, GoRouterState state) {
            return LoginScreen(context:context);
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  
  final Store<SignupState> store;
  final GoRouter router;
  MyApp({Key? key, required this.store, required this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<SignupState>(
       store: store,
      child: MaterialApp.router(
      routerConfig: _router,
    )
    );
  }
}
class AddUser extends StatelessWidget {
  final String fullName;
  final String company;
  final int age;
   final BuildContext context;

  AddUser(this.fullName, this.company, this.age, this.context);

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'full_name': fullName, // John Doe
            'company': company, // Stokes and Sons
            'age': age // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }
     Future<void> addFileWithPicker() async{
      // Call the user's CollectionReference to add a new user
     FilePickerResult? result = await FilePicker.platform.pickFiles();
     // Create a storage reference from our app
     
      if (result != null) {
        PlatformFile file = result.files.first;
         final storageRef = FirebaseStorage.instance.ref();
      
      // Create a reference to "mountains.jpg"
      final mountainsRef = storageRef.child("mountains.jpg");

      // Create a reference to 'images/mountains.jpg'
      final mountainImagesRef = storageRef.child("images/mountains.jpg");

      // While the file names are the same, the references point to different files
      assert(mountainsRef.name == mountainImagesRef.name);
      assert(mountainsRef.fullPath != mountainImagesRef.fullPath);
        print(file.name);
        print(file.bytes);
        print(file.size);
        print(file.extension);
        print(file.path);
      } else {
        // User canceled the picker
      }
    }
 Future<void> uploadFile() async {
  final result = await FilePicker.platform.pickFiles();
  
  if (result == null) print("didnt,find");
  else{
  // final path= result.files.single.path!;
  // File file= File(path);
  // if (file.existsSync()) {
  // final Filename=basename(file!.path);
  // final destination="files/$Filename";

  // Create a storage reference from our app
//  final storageRef = FirebaseStorage.instance.ref();
 
// // // Create a reference to "mountains.jpg"
// // final mountainsRef = storageRef.child(Filename);

// // // // Create a reference to 'images/mountains.jpg'
// //  final mountainImagesRef = storageRef.child(destination);
//  final ref=getTemporaryDirectory();
//  Directory appDocDir = await getApplicationDocumentsDirectory();
//  String filePath = '${appDocDir.absolute}/$';
//  print(filePath);
// File filesToUp = File(filePath);
// // While the file names are the same, the references point to different files
//await mountainsRef.putFile(filesToUp);
// } else {
//   // The file does not exist, handle the error.
//   print("FILE ERROR");
// }
  
//  final downloadUrl=await mountainsRef.getDownloadURL();
// print("Successful!");
// print(downloadUrl);
  }
  // Create a storage reference from our app
final storageRef = FirebaseStorage.instance.ref();
final path= result.files.single.path!;
  File file= File(path);
// Create a reference to "mountains.jpg"
final mountainsRef = storageRef.child("mountains.jpg");

// Create a reference to 'images/mountains.jpg'
final mountainImagesRef = storageRef.child("images/mountains.jpg");

// While the file names are the same, the references point to different files
assert(mountainsRef.name == mountainImagesRef.name);
assert(mountainsRef.fullPath != mountainImagesRef.fullPath);
 Directory appDocDir = await getApplicationDocumentsDirectory();
String filePath = '${appDocDir.absolute}/file-to-upload.png';
File file = File(filePath);

try {
  await mountainsRef.putFile(file);
} on firebase_core.FirebaseException catch (e) {

}

  
}

     return Center(
      child: TextButton(onPressed: uploadFile,
      child: Text("Add File"))
     );
    // return Center(
      
    //    child: TextButton(
    //     onPressed: addUser,
    //     child: Text(
    //       "Add User",
    //     ),
        
    //      ),
    //  );
  }
}
// class MyAppState extends ChangeNotifier {
//   var current = "EHR Record functionality";
//   var isLoggedIn=false;
//   var privateKey = 'a9429f1d48dad916f475b5f6271aa92b8983cccaa1f1f40cac5d8e8c359d2f53'; 
//   var patientList = <String>[];
//   var collectionOfPatient=Null;

//    void getNext() {
//     current =  "EHR Record functionality";
//     notifyListeners();
//   }
  
//   void signUpHosp(String nameLoc, String licenseLoc, String privateKeyLoc) async {
    
//       String CollectionAssigned= "#09182828288"; //TO BE DONE WITH FIREBASE
//       const String rpcUrl = 'http://192.168.178.17:8545';
//       final client = Web3Client(rpcUrl, Client());
//       final credentials = EthPrivateKey.fromHex(privateKey);
//       final address = credentials.address;  
//       final abiString = await rootBundle.rootBundle.loadString('assets/Hospital.json');
//       var abiJson = jsonDecode(abiString);
//       print(abiJson['abi']);
//       var abi = jsonEncode(abiJson['abi']);
//       var contractAddress = EthereumAddress.fromHex( abiJson['networks']['5777']['address']);
//       final contract = DeployedContract(ContractAbi.fromJson(abi, 'Hospital'), contractAddress );
//       final signupHospital = contract.function('signupHospital');
//       await client.sendTransaction(
//       credentials,
//       Transaction.callContract(
//         contract: contract,
//         function: signupHospital,
//         parameters: [nameLoc, licenseLoc,  CollectionAssigned]
//       ),
//     );
//     print("Successful signUp");
//       notifyListeners();
//   }
  // Future loginLogoutChangeStateOfIsLoggedInAndPrivateKey(String privateKeyLoc) async{
             
  //         const String rpcUrl = 'http://192.168.178.17:8545';
  //         final client = Web3Client(rpcUrl, Client());
  //         privateKey=privateKeyLoc;
  //         final credentials = EthPrivateKey.fromHex(privateKey);
  //         final address = credentials.address;  
  //         final abiString = await rootBundle.rootBundle.loadString('assets/Hospital.json');
  //         var abiJson = jsonDecode(abiString);
  //         print(abiJson['abi']);
  //         var abi = jsonEncode(abiJson['abi']);
  //         var contractAddress = EthereumAddress.fromHex( abiJson['networks']['5777']['address']);
  //         final contract = DeployedContract(ContractAbi.fromJson(abi, 'Hospital'), contractAddress );
       
  //         final loginLogoutHospital = contract.function('LoginLogoutHos');
  //         final loggedInStatus = contract.event('loggedInStatus');
  //         final getPatientList= contract.event('getPatientList');
  //         await client.sendTransaction(
  //         credentials,
  //         Transaction.callContract(
  //         contract: contract,
  //         function: loginLogoutHospital,
  //         parameters: []
  //       ),
  //     );
  //       var loginToggle=client
  //     .events(FilterOptions.events(contract: contract, event: loggedInStatus ))
  //     .take(1)
  //     .listen((event) async {
  //   final decoded = loggedInStatus.decodeResults(event.topics!,event.data!);
  //    isLoggedIn=decoded[0];
  //    print("Decoded:$decoded");
  //     notifyListeners();
  // });
  // if(isLoggedIn==true){
  //    var findRegisteredPatientList=client
  //     .events(FilterOptions.events(contract: contract, event: getPatientList ))
  //     .take(1)
  //     .listen((event) {
  //   final decoded = loggedInStatus.decodeResults(event.topics!,event.data!);
  //    patientList =decoded[0];
  //    print("Patient list");
  //    print(patientList);
  // });
  // }
  //         notifyListeners();
  // }
  // void assignCollectionId(String patAddLoc, String collectionId) async 
  // {
  //     const String rpcUrl = 'http://192.168.178.17:8545';
  //     final client = Web3Client(rpcUrl, Client());
  //     final credentials = EthPrivateKey.fromHex(privateKey);
  //     final address = credentials.address;  
  //     final abiString = await rootBundle.rootBundle.loadString('assets/Hospital.json');
  //     var abiJson = jsonDecode(abiString);
  //     print(abiJson['abi']);
  //     var abi = jsonEncode(abiJson['abi']);
  //     var contractAddress = EthereumAddress.fromHex( abiJson['networks']['5777']['address']);  
  //     final contract = DeployedContract(ContractAbi.fromJson(abi, 'Hospital'), contractAddress );
  //     final assignCollectionId = contract.function('assignCollectionId');
  //     var patAdd=EthereumAddress.fromHex(patAddLoc);
  //     await client.sendTransaction(
  //   credentials,
  //   Transaction.callContract(
  //     contract: contract,
  //     function: assignCollectionId,
  //     parameters: [patAdd,collectionId],
  //   ),
  // );
  // }
  // void getCollectionId(String patAddLoc) async {
  //       const String rpcUrl = 'http://192.168.178.17:8545';
  //       final client = Web3Client(rpcUrl, Client());
  //       final credentials = EthPrivateKey.fromHex(privateKey);
  //       final address = credentials.address;  
  //       final abiString = await rootBundle.rootBundle.loadString('assets/Hospital.json');
  //       var abiJson = jsonDecode(abiString);
  //       print(abiJson['abi']);
  //       var abi = jsonEncode(abiJson['abi']);
  //       var contractAddress = EthereumAddress.fromHex( abiJson['networks']['5777']['address']);
  //       var patAdd=EthereumAddress.fromHex(patAddLoc);
  //       final contract = DeployedContract(ContractAbi.fromJson(abi, 'Hospital'), contractAddress );
  //       final  getCollectionId= contract.function('getCollectionId');
  //       final getCollectionIdRes= await client.call(
  //     contract: contract, function: getCollectionId, params: [patAdd]);
  //       //collectionOfPatient=getCollectionIdRes[0];
  //       print( getCollectionIdRes);
     
  //       notifyListeners();
  // }
  void viewRecords(){
    // FIREBASE
  }
  // void patientRegistration() async {
  //     const String rpcUrl = 'http://192.168.178.17:8545';
  //     final client = Web3Client(rpcUrl, Client());
  //     final credentials = EthPrivateKey.fromHex(privateKey);
  //     final address = credentials.address;  
  //     final abiString = await rootBundle.rootBundle.loadString('assets/Patient.json');
  //     var abiJson = jsonDecode(abiString);
  //     print(abiJson['abi']);
  //     var abi = jsonEncode(abiJson['abi']);
  //     var contractAddress = EthereumAddress.fromHex( abiJson['networks']['5777']['address']);
  //     final contract = DeployedContract(ContractAbi.fromJson(abi, 'Hospital'), contractAddress );
  // }
  // void contractCall() async {
  // // start a client we can use to send transactions
  
  // const String rpcUrl = 'http://192.168.178.17:8545';
  // final client = Web3Client(rpcUrl, Client());
  // final credentials = EthPrivateKey.fromHex(privateKey);
  // final address = credentials.address;  
  // final abiString = await rootBundle.rootBundle.loadString('assets/Hospital.json');
  // var abiJson = jsonDecode(abiString);
  // print(abiJson['abi']);
  // var abi = jsonEncode(abiJson['abi']);
  // var contractAddress = EthereumAddress.fromHex( abiJson['networks']['5777']['address']);
  // final contract = DeployedContract(ContractAbi.fromJson(abi, 'Hospital'), contractAddress );
  // final setName = contract.function('setName');
  // final getVal= contract.function('getVal');
  // final getIt = contract.event('getIt');
  // // final balance = await client.call(
  // //     contract: contract, function: balanceFunction, params: [ownAddress]);
  // print("ContractAdd:");
  // await client.sendTransaction(
  //   credentials,
  //   Transaction.callContract(
  //     contract: contract,
  //     function: setName,
  //     parameters: ["heloo"],
  //   ),
  // );
  // final numCall= await client.call(
  //     contract: contract, function: getVal, params: [address]);
  // print(numCall);
  // final subscription = client
  //     .events(FilterOptions.events(contract: contract, event: getIt))
  //     .take(1)
  //     .listen((event) {
  //   final decoded = getIt.decodeResults(event.topics!,event.data!);
  //   print(decoded[0]);
  // });

  //print( contractAddress);
     
  // print(address.hexEip55);
  // print(await client.getBalance(address));
  

  //  var httpClient = Client();
  // // You tried the code below and it didn't work
  // // var ethClient = new Web3Client('http://localhost:8545', httpClient);

  // // Try this code instead. (Replace "192.168.1.33" with the IP of your server)
  // var ethClient = Web3Client('http://192.168.178.17:8545', httpClient);
  
  // print(ethClient.getBlockNumber());
  
  // await client.dispose();
//}  

  var favorites = <String>[];


class MyHomePage extends StatelessWidget {
  
  FirebaseFirestore firestore = FirebaseFirestore.instance;
 
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();
    var pair= "EHR Hospital functionality";
   return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body:  
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           AddUser("Hey","go to hell",23,context),
            ElevatedButton(
              onPressed: () => print("works"),
              child: const Text('home', style: TextStyle(color: Colors.deepPurpleAccent),),
            ),
            //  ElevatedButton(
            //   onPressed: () => context.go('/details'),
            //   child: const Text('Go to the Details screen'),
            // ),
          ],
        ),
      ),
      
     
      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       ElevatedButton(
      //         onPressed: () => context.go('/'),
      //         child: const Text('home'),
      //       ),
      //        ElevatedButton(
      //         onPressed: () => context.go('/details'),
      //         child: const Text('Go to the Details screen'),
      //       ),
      //     ],
      //   ),
      // ),
    );
    //return LoginThreeState();
    
    //return SignupScreen();
    // return Scaffold(
    //       body: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             SignupScreen(),
    //             // BigCard(pair: pair),
    //             // Column(
    //             //     mainAxisSize: MainAxisSize.min,
    //             //   children: [
    //             //     ElevatedButton(
    //             //       onPressed: () {
    //             //         appState.contractCall();
    //             //       },
                      
    //             //       child: Text('Next'),
               
    //             //     ),
                   
    //             //       ElevatedButton(
    //             //       onPressed: () {
    //             //         print('SignUp Doctor pressed!');
    //             //          appState.signUpHosp("Shrishti","800099","E4444H");
    //             //       },
    //             //       child: Text("Sign Up Doctor"),
               
    //             //     ),
    //             //      ElevatedButton(
    //             //       onPressed: ()async {
    //             //         print('Login pressed!');
    //             //          await appState.loginLogoutChangeStateOfIsLoggedInAndPrivateKey(appState.privateKey);
    //             //          print("LoggedIn? ${appState.isLoggedIn}");
    //             //       },
    //             //       child: Text("Login/Logout"),
               
    //             //     ),
    //             //      ElevatedButton(
    //             //       onPressed: () {
    //             //         print('AssignCollectionId pressed!');
    //             //          appState.assignCollectionId("0x194724c9820B99cd7A586b59c069E04604Db1180","djdjjjj");
    //             //       },
    //             //       child: Text("AssignCollectionId"),
               
    //             //     ),
    //             //     ElevatedButton(
    //             //       onPressed: () {
    //             //         print('Get CollectionId pressed!');
    //             //          appState.getCollectionId("0x194724c9820B99cd7A586b59c069E04604Db1180");
    //             //       },
    //             //       child: Text("Get CollectionId"),
               
    //             //     ),
                    
                    
    //             //   ],
    //             // ),
    //           ],
    //         ),
    //       ),
    //     );
    
  }
}

// class Like extends StatelessWidget {
//   const Like({
//     Key? key,
//   }) : super(key: key);
 
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var col=Colors.pink;
//     var fav=appState.favorites;
   
//     if( fav.contains(appState.current))
//     {
//       col=Colors.pink;
//     }
//     else
//     {
//       col=Colors.grey;
//     }
//     return Row(
      
//       children: [
//         ElevatedButton(  onPressed: () {
//                     print('button pressed!');
//                      appState.toggleFavorite();
//                   },
//                     child:Icon(
//           Icons.favorite,
//           color: col,
//           size: 24.0,
//           semanticLabel: 'Text to announce in accessibility modes',
//         ),),Text("LIKE")
        
        
//       ],
//     );
//   }
// }

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final String pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      elevation: 30,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair,style: style, semanticsLabel: pair),
        
      ),
    );
  }
}