import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends ChangeNotifier {

  User? _user;
  Map<String,dynamic>? _userData;
  File? _image;
  String? _profileImageUrl;
  bool _isUploading = false;

  bool get isUploading => _isUploading;
  File? get image => _image;
  User? get user => _user;
  Map<String,dynamic>? get userData => _userData;
  String? get profileImageUrl => _profileImageUrl;


  ProfileProvider(){
    _user = FirebaseAuth.instance.currentUser;
    _listenToUserChanges();
  }


  // Listen for changes in user authentication
  void _listenToUserChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      if (_user != null) {
        FetchUserData();  // Fetch user data when user logs in or changes
      } else {
        _userData = null;  // Clear user data on logout
        _profileImageUrl = null;
      }
      notifyListeners();
    });
  }


  Future<void> FetchUserData() async {
    if(_user != null){
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();

      _userData = userDoc.data() as Map<String,dynamic>;
      _profileImageUrl = _userData!['profile_image'];

      notifyListeners();
    }
  }
  //pick image from gallery
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? _pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if(_pickedFile !=null){
      _image = File(_pickedFile.path);
      notifyListeners();
    }
  }

  //upload image to firebase
  Future<void> UploadImageToFirebase(String userId)  async {
    if(_image != null){
      _isUploading = true;
      notifyListeners();
      final stroageRef = FirebaseStorage.instance.ref().child('user_profiles/$userId/profile_image.jpg');
      await stroageRef.putFile(_image!);
      final imageUrl = await stroageRef.getDownloadURL();

      //store image url
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profile_image': imageUrl
      });

      _profileImageUrl = imageUrl;
      _isUploading = false;
      notifyListeners();
    }
  }
}