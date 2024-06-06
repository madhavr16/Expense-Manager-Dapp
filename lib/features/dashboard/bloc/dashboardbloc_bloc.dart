import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:expense_manager_dapp/models/transaction_model.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

part 'dashboardbloc_event.dart';
part 'dashboardbloc_state.dart';

class DashboardblocBloc extends Bloc<DashboardblocEvent, DashboardblocState> {
  DashboardblocBloc() : super(DashboardblocInitial()) {
    on<DashboardInitialFetchEvent>(dashboardInitialFetchEvent);
    on<DashboardDepositEvent>(dashboardDepositEvent);
    on<DashboardWithdrawEvent>(dashboardWithdrawEvent);
  }

  List<TransactionModel> transactions = [];
  Web3Client? _web3Client;
  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _creds;
  int balance = 0;

  //functions
  late DeployedContract _deployedContract;
  late ContractFunction _deposit;
  late ContractFunction _withdraw;
  late ContractFunction _getBalance;
  late ContractFunction _getAllTransactions;

  FutureOr<void> dashboardInitialFetchEvent(DashboardInitialFetchEvent event, Emitter<DashboardblocState> emit) async{
    emit(DashboardLoadingState());
    try{
      String rpcUrl = 'http://192.168.18.41:7546';
      String socketUrl = 'ws://192.168.18.41:7546';
      String privateKey = '0xa9940dd755236e66c84c97405593c16ad593fcedc6aa8eb3e7bf755b426e98d0';
       _web3Client = Web3Client(
          rpcUrl, 
          http.Client(),
          socketConnector: () {
            return IOWebSocketChannel.connect(socketUrl).cast<String>();
          },
        );

        //get ABI
        String abiFile = await rootBundle.loadString('build/contracts/ExpenseManagerContract.json');
        var jsondecoded = jsonDecode(abiFile);
        _abiCode = ContractAbi.fromJson(jsonEncode(jsondecoded['abi']), 'ExpenseManagerContract');
        _contractAddress = EthereumAddress.fromHex('0x3e79aC5C18Cb674c2C724c2263E2D9430DdEDCF7');
        _creds = EthPrivateKey.fromHex(privateKey);

        // get deployed contract
        _deployedContract = DeployedContract(_abiCode, _contractAddress);
        _deposit = _deployedContract.function('deposit');
        _withdraw = _deployedContract.function('withdraw');
        _getBalance = _deployedContract.function('getBalance');
        _getAllTransactions = _deployedContract.function('getAllTransactions');

        final transactionsData = await _web3Client!.call(
          contract: _deployedContract, 
          function: _getAllTransactions, 
          params: []
        );
        final balanceData = await _web3Client!.call(
          contract: _deployedContract, 
          function: _getBalance, 
          params: [EthereumAddress.fromHex("0x9E8F6Cc36a7a7Cb54a47DB5D0ef2aa9A0948C5Bd")]
        );
        List<TransactionModel> trans = [];
        for(int i = 0; i < transactionsData[0].length; i++){
          TransactionModel transactionModel = TransactionModel(
            user : transactionsData[0][i].toString(),
            amount : transactionsData[1][i].toInt(),
            reason : transactionsData[2][i],
            time : DateTime.fromMicrosecondsSinceEpoch(transactionsData[3][i].toInt()),
          );
          trans.add(transactionModel);
        }
        transactions = trans;
        int bal = balanceData[0].toInt();
        balance = bal;
        emit(DashboardSuccessState(transactions: transactions, balance: balance));
      }catch(e){
        log(e.toString());
        emit(DashboardErrorState());
      }
  }

  FutureOr<void> dashboardDepositEvent(DashboardDepositEvent event, Emitter<DashboardblocState> emit) async{
    try {
      final transaction = Transaction.callContract(
        contract: _deployedContract, 
        function: _deposit, 
        parameters: [BigInt.from(event.transactionModel.amount), event.transactionModel.reason],
        value: EtherAmount.inWei(BigInt.from(event.transactionModel.amount))
      );
      final result = await _web3Client!.sendTransaction(
        _creds, 
        transaction, 
        chainId: 1337,
        fetchChainIdFromNetworkId: false
      );
      log(result.toString());
      add(DashboardInitialFetchEvent());
    } catch (e) {
      log(e.toString());
    }
  }

  FutureOr<void> dashboardWithdrawEvent(DashboardWithdrawEvent event, Emitter<DashboardblocState> emit) async{
    try {
      final transaction = Transaction.callContract(
        contract: _deployedContract, 
        function: _withdraw, 
        parameters: [BigInt.from(event.transactionModel.amount), event.transactionModel.reason],
      );
      final result = await _web3Client!.sendTransaction(
        _creds, 
        transaction, 
        chainId: 1337,
        fetchChainIdFromNetworkId: false
      );
      log(result.toString());
      add(DashboardInitialFetchEvent());
    } catch (e) {
      log(e.toString());
    }
  }
}
