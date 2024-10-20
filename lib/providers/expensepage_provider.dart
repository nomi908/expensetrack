import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExpensePageProvider extends ChangeNotifier{

  List<Map<String, dynamic>> _alltransaction = [];
  double _incomeTransaction = 0.0;
  double _expenseTransaction = 0.0;
  bool _isLoading = false;




  List<Map<String, dynamic>> get alltransaction => _alltransaction;
  double get totalAmount => _incomeTransaction - _expenseTransaction;
  double get incomeTransaction => _incomeTransaction;
  double get expenseTransaction => _expenseTransaction;
  bool get isLoadingState => _isLoading;


  Future<void> getallTransaction() async {
    _isLoading = true;
    notifyListeners();
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      try{

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.
        collection('users').doc(user.uid).collection('transactions')
            .orderBy('dateTime', descending: true).get();
        print('querySnapshot: ${querySnapshot.docs.length}');

        _incomeTransaction = 0.0;
        _expenseTransaction = 0.0;

        _alltransaction.clear();
        for(var doc in querySnapshot.docs){

          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String transactionId = doc.id;

          data['transactionId'] = transactionId;

          print('trnasaction data: $data');
          if(data['transactionType'] == 'Income'){
            _incomeTransaction += data['amount'];
          }else if(data['transactionType'] == 'Expense'){
            _expenseTransaction += data['amount'];
          }

          _alltransaction.add(data);
        }
        // _alltransaction = _alltransaction.reversed.toList();

        _isLoading = false;
        notifyListeners();

      }catch(e){print('Error fetching data: $e');}

    }else{
      print('user not loggedIn');
    }
  }


  List<Map<String, dynamic>> getFilteredTransactions(DateTime startDate, DateTime endDate) {
    return alltransaction.where((transaction) {
      DateTime transactionDate = (transaction['dateTime'] as Timestamp).toDate();
      return transactionDate.isAfter(startDate) && transactionDate.isBefore(endDate);
    }).toList();
  }
}