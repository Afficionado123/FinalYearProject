 import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart' as fd;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' as rootBundle;
import 'dart:io';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 124, 129, 202)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

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

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var isLoggedIn=false;
  var privateKey = '1cb78f0672c24846a9d5cd6d142980afc962d6940c6f3fd1f6dd7a8e583d2c11'; 
  var patientList = <String>[];
  var collectionOfPatient=Null;
   void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

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
  
  void signUpHosp(String nameLoc, String licenseLoc, String privateKeyLoc) async {
    
      String CollectionAssigned= "#09182828288"; //TO BE DONE WITH FIREBASE
      const String rpcUrl = 'http://192.168.0.7:8545';
      final client = Web3Client(rpcUrl, Client());
      final credentials = EthPrivateKey.fromHex(privateKey);
      final address = credentials.address;  
      final abiString = await rootBundle.rootBundle.loadString('assets/Hospital.json');
      var abiJson = jsonDecode(abiString);
      print(abiJson['abi']);
      var abi = jsonEncode(abiJson['abi']);
      var contractAddress = EthereumAddress.fromHex( abiJson['networks']['5777']['address']);
      final contract = DeployedContract(ContractAbi.fromJson(abi, 'Hospital'), contractAddress );
      final signupHospital = contract.function('signupHospital');
      await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: signupHospital,
        parameters: [nameLoc, licenseLoc,  CollectionAssigned]
      ),
    );
    print("Successful signUp");
      notifyListeners();
  }
  Future loginLogoutChangeStateOfIsLoggedInAndPrivateKey(String privateKeyLoc) async{
             
          const String rpcUrl = 'http://192.168.0.7:8545';
          final client = Web3Client(rpcUrl, Client());
          privateKey=privateKeyLoc;
          final credentials = EthPrivateKey.fromHex(privateKey);
          final address = credentials.address;  
          final abiString = await rootBundle.rootBundle.loadString('assets/Hospital.json');
          var abiJson = jsonDecode(abiString);
          print(abiJson['abi']);
          var abi = jsonEncode(abiJson['abi']);
          var contractAddress = EthereumAddress.fromHex( abiJson['networks']['5777']['address']);
          final contract = DeployedContract(ContractAbi.fromJson(abi, 'Hospital'), contractAddress );
       
          final loginLogoutHospital = contract.function('LoginLogoutHos');
          final loggedInStatus = contract.event('loggedInStatus');
          final getPatientList= contract.event('getPatientList');
          await client.sendTransaction(
          credentials,
          Transaction.callContract(
          contract: contract,
          function: loginLogoutHospital,
          parameters: []
        ),
      );
        var loginToggle=client
      .events(FilterOptions.events(contract: contract, event: loggedInStatus ))
      .take(1)
      .listen((event) async {
    final decoded = loggedInStatus.decodeResults(event.topics!,event.data!);
     isLoggedIn=decoded[0];
     print("Decoded:$decoded");
      notifyListeners();
  });
  if(isLoggedIn==true){
     var findRegisteredPatientList=client
      .events(FilterOptions.events(contract: contract, event: getPatientList ))
      .take(1)
      .listen((event) {
    final decoded = loggedInStatus.decodeResults(event.topics!,event.data!);
     patientList =decoded[0];
     print("Patient list");
     print(patientList);
  });
  }
          notifyListeners();
  }
  void assignCollectionId(String patAddLoc, String collectionId) async 
  {
      const String rpcUrl = 'http://192.168.0.7:8545';
      final client = Web3Client(rpcUrl, Client());
      final credentials = EthPrivateKey.fromHex(privateKey);
      final address = credentials.address;  
      final abiString = await rootBundle.rootBundle.loadString('assets/Hospital.json');
      var abiJson = jsonDecode(abiString);
      print(abiJson['abi']);
      var abi = jsonEncode(abiJson['abi']);
      var contractAddress = EthereumAddress.fromHex( abiJson['networks']['5777']['address']);  
      final contract = DeployedContract(ContractAbi.fromJson(abi, 'Hospital'), contractAddress );
      final assignCollectionId = contract.function('assignCollectionId');
      var patAdd=EthereumAddress.fromHex(patAddLoc);
      await client.sendTransaction(
    credentials,
    Transaction.callContract(
      contract: contract,
      function: assignCollectionId,
      parameters: [patAdd,collectionId],
    ),
  );
  }
  void getCollectionId(String patAddLoc) async {
        const String rpcUrl = 'http://192.168.0.7:8545';
        final client = Web3Client(rpcUrl, Client());
        final credentials = EthPrivateKey.fromHex(privateKey);
        final address = credentials.address;  
        final abiString = await rootBundle.rootBundle.loadString('assets/Hospital.json');
        var abiJson = jsonDecode(abiString);
        print(abiJson['abi']);
        var abi = jsonEncode(abiJson['abi']);
        var contractAddress = EthereumAddress.fromHex( abiJson['networks']['5777']['address']);
        var patAdd=EthereumAddress.fromHex(patAddLoc);
        final contract = DeployedContract(ContractAbi.fromJson(abi, 'Hospital'), contractAddress );
        final  getCollectionId= contract.function('getCollectionId');
        final getCollectionIdRes= await client.call(
      contract: contract, function: getCollectionId, params: [patAdd]);
        //collectionOfPatient=getCollectionIdRes[0];
        print( getCollectionIdRes);
     
        notifyListeners();
  }
  void viewRecords(){
    // FIREBASE
  }
  void patientRegistration() async {
      const String rpcUrl = 'http://192.168.0.7:8545';
      final client = Web3Client(rpcUrl, Client());
      final credentials = EthPrivateKey.fromHex(privateKey);
      final address = credentials.address;  
      final abiString = await rootBundle.rootBundle.loadString('assets/Patient.json');
      var abiJson = jsonDecode(abiString);
      print(abiJson['abi']);
      var abi = jsonEncode(abiJson['abi']);
      var contractAddress = EthereumAddress.fromHex( abiJson['networks']['5777']['address']);
      final contract = DeployedContract(ContractAbi.fromJson(abi, 'Hospital'), contractAddress );
  }
  void contractCall() async {
  // start a client we can use to send transactions
  
  const String rpcUrl = 'http://192.168.0.7:8545';
  final client = Web3Client(rpcUrl, Client());
  final credentials = EthPrivateKey.fromHex(privateKey);
  final address = credentials.address;  
  final abiString = await rootBundle.rootBundle.loadString('assets/Hospital.json');
  var abiJson = jsonDecode(abiString);
  print(abiJson['abi']);
  var abi = jsonEncode(abiJson['abi']);
  var contractAddress = EthereumAddress.fromHex( abiJson['networks']['5777']['address']);
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Hospital'), contractAddress );
  final setName = contract.function('setName');
  final getVal= contract.function('getVal');
  final getIt = contract.event('getIt');
  // final balance = await client.call(
  //     contract: contract, function: balanceFunction, params: [ownAddress]);
  print("ContractAdd:");
  await client.sendTransaction(
    credentials,
    Transaction.callContract(
      contract: contract,
      function: setName,
      parameters: ["heloo"],
    ),
  );
  final numCall= await client.call(
      contract: contract, function: getVal, params: [address]);
  print(numCall);
  final subscription = client
      .events(FilterOptions.events(contract: contract, event: getIt))
      .take(1)
      .listen((event) {
    final decoded = getIt.decodeResults(event.topics!,event.data!);
    print(decoded[0]);
  });

  //print( contractAddress);
     
  // print(address.hexEip55);
  // print(await client.getBalance(address));
  

  //  var httpClient = Client();
  // // You tried the code below and it didn't work
  // // var ethClient = new Web3Client('http://localhost:8545', httpClient);

  // // Try this code instead. (Replace "192.168.1.33" with the IP of your server)
  // var ethClient = Web3Client('http://192.168.0.7:8545', httpClient);
  
  // print(ethClient.getBlockNumber());
  
  // await client.dispose();
  
 
  
}
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
  
}

class MyHomePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair= appState.current;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A random idea:'),
            BigCard(pair: pair),
            Column(
                mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    appState.contractCall();
                  },
                  
                  child: Text('Next'),
           
                ),
                ElevatedButton(
                  onPressed: () {
                    print('button pressed!');
                     appState.getNext();
                  },
                  child: Like(),
           
                ),
                  ElevatedButton(
                  onPressed: () {
                    print('SignUp Doctor pressed!');
                     appState.signUpHosp("Shrishti","800099","E4444H");
                  },
                  child: Text("Sign Up Doctor"),
           
                ),
                 ElevatedButton(
                  onPressed: ()async {
                    print('Login pressed!');
                     await appState.loginLogoutChangeStateOfIsLoggedInAndPrivateKey(appState.privateKey);
                     print("LoggedIn? ${appState.isLoggedIn}");
                  },
                  child: Text("Login/Logout"),
           
                ),
                 ElevatedButton(
                  onPressed: () {
                    print('AssignCollectionId pressed!');
                     appState.assignCollectionId("0x1352a01C497022AbD675C9e1ba16Cc6ed235cD61","djdjjjj");
                  },
                  child: Text("AssignCollectionId"),
           
                ),
                ElevatedButton(
                  onPressed: () {
                    print('Get CollectionId pressed!');
                     appState.getCollectionId("0x1352a01C497022AbD675C9e1ba16Cc6ed235cD61");
                  },
                  child: Text("Get CollectionId"),
           
                ),
                
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Like extends StatelessWidget {
  const Like({
    Key? key,
  }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var col=Colors.pink;
    var fav=appState.favorites;
   
    if( fav.contains(appState.current))
    {
      col=Colors.pink;
    }
    else
    {
      col=Colors.grey;
    }
    return Row(
      
      children: [
        ElevatedButton(  onPressed: () {
                    print('button pressed!');
                     appState.toggleFavorite();
                  },
                    child:Icon(
          Icons.favorite,
          color: col,
          size: 24.0,
          semanticLabel: 'Text to announce in accessibility modes',
        ),),Text("LIKE")
        
        
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      elevation: 30,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text("Click to upload the file",style: style, semanticsLabel: pair.asPascalCase,),
        
      ),
    );
  }
}