import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'dart:io';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:convert';
import 'package:redux/redux.dart';
import 'package:web_socket_channel/io.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import '../reducers/signupState.dart';
import '../actions/signup_actions.dart';

void signUpHosp( var nameLoc, var licenseLoc, var privateKeyLoc) async {
      
    
      print(licenseLoc);
      String CollectionAssigned= "09182828288"; //TO BE DONE WITH FIREBASE
      const String rpcUrl = '192.168.4.17:7545';
      var privateKey="bb25df6348afc5f3bfa5bd72893667db7a240eaa89ec382cd931cc0503272bd2";
      final client = Web3Client(rpcUrl, Client());
      final credentials = EthPrivateKey.fromHex(privateKey);
      final address = credentials.address;  
      final abiString = await rootBundle.rootBundle.loadString('assets/Hospital.json');
      var abiJson = jsonDecode(abiString);
      
      var abi = jsonEncode(abiJson['abi']);
      var contractAddress = EthereumAddress.fromHex( abiJson['networks']['5777']['address']);
      print(contractAddress);
      final contract = DeployedContract(ContractAbi.fromJson(abi, 'Hospital'), contractAddress );
      final signupHospital = contract.function('signupHospital');
      await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: signupHospital,
        parameters: [nameLoc,licenseLoc,CollectionAssigned]
      ),
    );
    print("Successful signUp");
   
  }

  //  Future loginLogoutChangeStateOfIsLoggedInAndPrivateKey(String privateKeyLoc) async{
             
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
  //}
       
 // }

ThunkAction<SignupState> signupThunkDoc = (Store<SignupState> store) async {
  store.dispatch(SignupRequestAction());
  try {
    // send a request to the server with store.state.email and store.state.password
    // handle the response
    print("type ${store.state.nameLoc.runtimeType}");
    signUpHosp("hh","ll","hhh");
    store.dispatch(SignupSuccessAction());

  } catch (e) {
    store.dispatch(SignupFailureAction(e.toString()));
  }
};

