
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionProvider extends ChangeNotifier {

  List<Map<String, dynamic>> _transactions = [];
  String _transactionType = 'Income';
  String _amount = '';
  String _category = '';
  String _description = '';
  DateTime? _selecteddateTime;
  bool _isLoading = false;
  String _currentDocId = '';

  String get currentDocId => _currentDocId;
  bool get isLoadingState => _isLoading;
  String get amount => _amount;
  String get category => _category;
  String get description => _description;
  DateTime? get selecteddateTime => _selecteddateTime;
  List<Map<String, dynamic>> get transactions => _transactions;
  String get transactionType => _transactionType;

  void setCurrentDocId(String docId) {
    _currentDocId = docId;
    notifyListeners();
  }
  void setAmount(String amount) {
    _amount = amount;
    notifyListeners();
  }

  void setCategory(String category) {
    _category = category;
    notifyListeners();
  }

  void setDescription(String description) {
    _description = description;
    notifyListeners();
  }

  void setSelecteddateTime(DateTime dateTime) {
    _selecteddateTime = dateTime;
    notifyListeners();
  }

  Future<void> openDatePicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selecteddateTime ?? DateTime.now(),
        firstDate: DateTime(2000), lastDate: DateTime(2102));
    if(pickedDate != null){
      TimeOfDay currentTime = TimeOfDay.now();
      DateTime combineDateTime =
          DateTime(pickedDate.year, pickedDate.month, pickedDate.day, currentTime.hour, currentTime.minute);
      setSelecteddateTime(combineDateTime);
    }

  }


  //for radiobtn
  void setTransactionType(String type) {
    _transactionType = type;
    notifyListeners();
  }

  Future<void> addTransaction(Map<String,dynamic> transaction) async {
    _isLoading = true;
    notifyListeners();

    User? user = FirebaseAuth.instance.currentUser;

    if(user != null){
      transaction['userId'] = user!.uid;
      transaction['transactionType'] = _transactionType;
      transaction['amount'] = double.parse(_amount);
      transaction['category'] = _category;
      transaction['description'] = _description;
      transaction['dateTime'] = _selecteddateTime;

      _transactions.add(transaction);
      await FirebaseFirestore.instance.collection('users')
          .doc(user!.uid)
          .collection('transactions')
          .add(transaction);

        resetinputs();
      _isLoading = false;
      notifyListeners();
    }else{
      throw Exception('user not loggedIn');
    }

  }

  void resetinputs(){
    _amount = '';
    _category = '';
    _description = '';
    _selecteddateTime = null;
    _transactionType = 'Income';
    notifyListeners();
  }

  Future<void> updateTransaction(Map<String, dynamic> transaction) async {
    _isLoading = true;
    notifyListeners();
    print("Submitting Transaction Data:");
    print("Amount: ${amount}");
    print("Category: ${category}");
    print("Description: ${description}");
    print("DateTime: ${selecteddateTime}");


    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user == null) {
      _isLoading = false; // Set loading to false
      notifyListeners(); // Notify listeners
      throw Exception('User not logged in');
    }

    // Proceed with the update if user is logged in
    if (_currentDocId.isNotEmpty) {
      transaction['userId'] = user.uid;
      transaction['transactionType'] = _transactionType;
      transaction['amount'] = double.parse(_amount);
      transaction['category'] = _category;
      transaction['description'] = _description;
      transaction['dateTime'] = _selecteddateTime;

      try {
        print('Updating transaction with ID: $_currentDocId');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('transactions')
            .doc(_currentDocId)
            .update(transaction);

        int index = _transactions.indexWhere((t) => t['transactionId'] == _currentDocId);
        if (index != -1) {
          _transactions[index] = transaction;
        }
        resetinputs();
      } catch (e) {
        print('Error updating transaction: $e');
        // Handle error
      } finally {
        _isLoading = false; // Reset loading state
        notifyListeners();
      }
    } else {
      _isLoading = false; // Reset loading state
      notifyListeners();
      throw Exception('Current document ID is empty');
    }
  }


  Future<void> deleteTransaction(String transactionId) async {
    _isLoading = true;
    notifyListeners();

    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user == null) {
      _isLoading = false; // Set loading to false
      notifyListeners(); // Notify listeners
      throw Exception('User not logged in');
    }

    try {
      // Delete the transaction document using the provided transaction ID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(transactionId) // Use the passed transaction ID
          .delete();

      // Remove the transaction from the local list
      _transactions.removeWhere((t) => t['transactionId'] == transactionId);

      resetinputs(); // Reset inputs if necessary
    } catch (e) {
      print('Error deleting transaction: $e');
      // Handle error (you might want to show a message to the user)
    } finally {
      _isLoading = false; // Reset loading state
      notifyListeners(); // Notify listeners
    }
  }


}