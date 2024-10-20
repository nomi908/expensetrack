
import 'package:expense_track/providers/loginsignup_provider.dart';
import 'package:expense_track/providers/profile_provider.dart';
import 'package:expense_track/screens/loginsignupscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense Track'),),
        body: Consumer<ProfileProvider>(
            builder: (context, provider, _) {
              if(provider.userData == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  InkWell(
                    onTap: () async{
                      await provider.pickImage();
                      if(provider.image != null) {
                       try{
                         await provider.UploadImageToFirebase(provider.user!.uid);
                         await provider.FetchUserData();
                       }catch(e){
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),));
                       }
                      }
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: provider.profileImageUrl != null
                          ? NetworkImage(provider.profileImageUrl!)
                              : provider.image != null ? FileImage(provider.image!) : null,
                          child: provider.image == null && provider.profileImageUrl ==null
                              ? const Icon(Icons.person, size: 60,) : null,
                        ),
                        if(provider.isUploading)
                          const CircularProgressIndicator(),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                              iconSize: 30,
                              onPressed: () async {
                                await provider.pickImage();
                                if(provider.image != null) {
                                  try{
                                    await provider.UploadImageToFirebase(provider.user!.uid);
                                    await provider.FetchUserData();
                                  }catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),));
                                  }
                                }
                              },
                              icon: const Icon(Icons.camera),

                            ),
                        ),


                      ],

                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Profile",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),
                  Text("Name: ${provider.userData!['firstName']}"),
                  const SizedBox(height: 5),
                  Text("Email: ${provider.userData!['email']}"),
                  const SizedBox(height: 5),
                  // Text("Phone:"),
                  // const SizedBox(height: 5),
                  // Text("Address:"),
                  // const SizedBox(height: 20),

                  // Padding(
                  //   padding: const EdgeInsets.all(16),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: ElevatedButton(onPressed: () {},
                  //             child: const Text("Edit Profile", style: TextStyle(
                  //                 color: Colors.white),),
                  //             style: ElevatedButton.styleFrom(backgroundColor:
                  //             Colors.purple, shape:
                  //             RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(10)))),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 4,),
                  Consumer<LoginSignupProvider>(
                      builder: (context, provider, _){
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(onPressed: () {
                                  provider.signout();
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginSignupPage()));
                                },
                                    child: const Text("Sign Out", style: TextStyle(
                                        color: Colors.white),),
                                    style: ElevatedButton.styleFrom(backgroundColor:
                                    Colors.purple, shape:
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)))),
                              ),
                            ],
                          ),
                        );}
                  ),


                ],
              );

            }),
    );


  }

}



