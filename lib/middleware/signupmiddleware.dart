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
      
    
      print(privateKeyLoc);
      String CollectionAssigned= "09182828288"; //TO BE DONE WITH FIREBASE
      const String rpcUrl = 'http://192.168.21.17:8545';
      var privateKey="84b3a09b659eb637e292c01323da782cb8615238e12dcd2f3144b7e98c1c062d";
      
      final client = Web3Client(rpcUrl, Client());
      final credentials = EthPrivateKey.fromHex(privateKeyLoc);
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
void signUpPat( var nameLoc, var licenseLoc, var privateKeyLoc) async {
      
    
      print(privateKeyLoc);
      String CollectionAssigned= "09182828288"; //TO BE DONE WITH FIREBASE
      const String rpcUrl = 'http://192.168.21.17:8545';
      var privateKey="84b3a09b659eb637e292c01323da782cb8615238e12dcd2f3144b7e98c1c062d";
      
      final client = Web3Client(rpcUrl, Client());
      final credentials = EthPrivateKey.fromHex(privateKeyLoc);
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
void login(int value) async {
      
    
      // print(licenseLoc);
      try{
         String CollectionAssigned= "09182828288"; //TO BE DONE WITH FIREBASE
      const String rpcUrl = 'http://192.168.21.17:8545';
      var privateKey="b40e4cd35e8abb512493aa9a61e7bfa3f8fd1c601c56888e5cd79fd816ebd090";
      final client = Web3Client(rpcUrl, Client());
      final credentials = EthPrivateKey.fromHex(privateKey);
      final address = credentials.address;  
      final abiString = await rootBundle.rootBundle.loadString('assets/Hospital.json');
      var abiJson = jsonDecode(abiString);
      
      var abi = jsonEncode(abiJson['abi']);
      var contractAddress = EthereumAddress.fromHex( abiJson['networks']['5777']['address']);
      print(contractAddress);
      final contract = DeployedContract(ContractAbi.fromJson(abi, 'Hospital'), contractAddress );
      final write = contract.function('write');
      await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: write,
        parameters: [BigInt.from(1234)]
      ),
    );
    print("Successful login");
      }
     catch(e){
      print("Error logging in");
     }
   
  }
ThunkAction<SignupState> signupThunkDoc = (Store<SignupState> store) async {
  store.dispatch(SignupRequestAction());
  try {
    // send a request to the server with store.state.email and store.state.password
    // handle the response
    print("Email: ${store.state.nameLoc}");
    signUpHosp("Arun","ll",store.state.privateKeyLoc);
    store.dispatch(SignupSuccessAction());

  } catch (e) {
    store.dispatch(SignupFailureAction(e.toString()));
  }
};
ThunkAction<SignupState> signupThunkPat = (Store<SignupState> store) async {
  store.dispatch(SignupRequestAction());
  try {
    // send a request to the server with store.state.email and store.state.password
    // handle the response
    print("Email: ${store.state.nameLoc}");
    signUpHosp("Arun","ll",store.state.privateKeyLoc);
    store.dispatch(SignupSuccessAction());

  } catch (e) {
    store.dispatch(SignupFailureAction(e.toString()));
  }
};
ThunkAction<SignupState> loginThunkDoc = (Store<SignupState> store) async {
  store.dispatch(LoginRequestAction());
  try {
    // send a request to the server with store.state.email and store.state.password
    // handle the response
    // print("type ${store.state.nameLoc.runtimeType}");
    login(6);
    print("login successful");
    store.dispatch(SignupSuccessAction());

  } catch (e) {
    store.dispatch(SignupFailureAction(e.toString()));
  }
};

