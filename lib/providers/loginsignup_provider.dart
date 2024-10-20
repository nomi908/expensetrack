
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_track/screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginSignupProvider extends ChangeNotifier {
  bool isLogin = true;
  String email ="";
  String password ="";
  String name = "";
  String confirmPassword ="";
  String error = "";
  bool isLoading = false;


  String nameError = "";
  String emailError = "";
  String passwordError = "";
  String confirmPasswordError = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void toggleLogin() {
    isLogin = !isLogin;
    error = '';
    passwordError = '';
    emailError = '';
    notifyListeners();
  }

//login event
  Future<void> login(BuildContext context)async {
    isLoading = true;
    notifyListeners();

    // Reset error messages
    nameError = '';
    emailError = '';
    passwordError = '';
    confirmPasswordError = '';

    // Validate email and password
    if (email.trim().isEmpty || password.isEmpty) {
      if (email.trim().isEmpty) {
        emailError = 'Email is required.';
      }
      if (password.isEmpty) {
        passwordError = 'Password is required.';
      }
      isLoading = false; // Ensure loading is stopped in case of validation failure
      notifyListeners();
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password,
      );
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setBool('isLoggedIn', true);
      // await prefs.setString('userId', userCredential.user!.uid);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(),));

    } catch (e) {
      // Handle the error and set a user-friendly error message
      if (e is FirebaseAuthException) {
        emailError = e.message.toString();
      }
      notifyListeners();
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }


  ///createuser event
  Future<void> signUp() async {
    isLoading = true;
    notifyListeners();
    print('provider name: "${name}", email: "${email}", password: "${password}", confirmPassword: "${confirmPassword}"');

    // Reset error messages
    nameError = '';
    emailError = '';
    passwordError = '';
    confirmPasswordError = '';

    if(name.trim().isEmpty){
      nameError = 'Name is required';
    }else if(email.trim().isEmpty){
      emailError = 'Email is required';
    }else if(!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email.trim())){
      emailError = 'Email is bad';
    }else if(password.isEmpty){
      passwordError = 'Password is required';
    }else if(confirmPassword.isEmpty){
      confirmPasswordError = 'Confirm password is required';
    }else if(password != confirmPassword){
      passwordError = 'Password do not match';
    }else if(password.length < 6){
      passwordError = 'Password must be at least 6 characters';
    }

    if(nameError.isNotEmpty || emailError.isNotEmpty || passwordError.isNotEmpty || confirmPasswordError.isNotEmpty){
      error = '${nameError.isNotEmpty ?
      '$nameError\n' : ''}${emailError.isNotEmpty ? '$emailError\n' :
      ''}${passwordError.isNotEmpty ? '$passwordError\n' : ''}${confirmPasswordError.isNotEmpty
          ? confirmPasswordError : ''}';

      isLoading = false;
      notifyListeners();
      return;
    }


    try {

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(

          email: email.trim(),
          password: password
      );

      //get user.id
      String userID = userCredential.user!.uid;


      //create a user documents in firestore
      await _db.collection('users').doc(userID).set({
        'firstName': name.split(' ').first,
        'lastName': name.split(' ').length > 1 ? name.split(' ').last : '',
        'email': email.trim(),
        'bio': '',
      });

      print('User signed up: ${userCredential.user}');

      isLogin = true;
      error = '';
      notifyListeners();

    } catch (e) {
      error = 'Signup failed: ${e.toString()}';
      notifyListeners();

    }finally{
      isLoading = false;
      notifyListeners();
    }

  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await _db.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('failed to fetch user data: ${e.toString()}');
    }
    return null;
  }

//signout
  Future<void> signout() async{
    await _auth.signOut();
  }
}