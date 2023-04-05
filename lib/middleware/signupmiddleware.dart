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
      const String rpcUrl = 'http://192.168.0.6:8545';
      var privateKey="a56c81d3e4c25d73e4dc97db93f5b8cf4e208700fc4bdedf0ded046e3feb945a";
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

