import 'package:expense_track/providers/loginsignup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginSignupPage extends StatelessWidget {
  const LoginSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginSignupProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          // appBar: AppBar(title: Text('Expense Track')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
              
                  Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(onPressed: (){
                            provider.toggleLogin();
                          }, child: Text('Login', style: TextStyle(color:
                          provider.isLogin ? Colors.white : Colors.purple),),
                          style: ElevatedButton.styleFrom(backgroundColor:
                          provider.isLogin ? Colors.purple : Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        )),
                        Expanded(
                          child: ElevatedButton(onPressed: (){
                            provider.toggleLogin();
                          }, child: Text('Signup', style: TextStyle(color:
                          !provider.isLogin ? Colors.white : Colors.purple),),
                            style: ElevatedButton.styleFrom(backgroundColor:
                            !provider.isLogin ? Colors.purple : Colors.white,shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),),
                        ),
              
              
                      ],
                    ),
                  ),
                  if(provider.isLogin)
                    Image.asset('assets/images/login_img.png'),
              
                  if(!provider.isLogin)
                    _textField('Enter Name', TextInputType.text, provider.nameError, false,
                        'Enter Name',1, (value){provider.name = value;}),
                    SizedBox(height: 10,),
                    _textField('Enter Email', TextInputType.emailAddress,
                        provider.emailError, false, 'Enter Email', 1,
                        (value){provider.email = value;}),
                    SizedBox(height: 10,),
                    _textField('Password', TextInputType.visiblePassword,
                        provider.passwordError, true, 'Password', 1,
                        (value){provider.password = value;}),
                    SizedBox(height: 10,),
                    if(!provider.isLogin)
                    _textField('Confirm Password', TextInputType.visiblePassword,
                        provider.confirmPasswordError, true, 'Confirm Password', 1,
                        (value){provider.confirmPassword = value;}),
              
              
              
              
                  SizedBox(height: 16,),
                  Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    child: provider.isLoading ? Center(child: CircularProgressIndicator()) :
                    ElevatedButton(
                      onPressed: () {
                        if (provider.isLogin) {
                          provider.login(context); // Call login method
                        } else {
                          provider.signUp(); // Call signup method
                        }
                      },
                      child: Text(provider.isLogin ? 'Login' : 'Sign Up', style: TextStyle(color:
                      Colors.white),),
                      style: ElevatedButton.styleFrom(backgroundColor:
                      Colors.purple,shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  TextButton(
                    onPressed: provider.toggleLogin,
                    child: Text(provider.isLogin ? 'Create an account' : 'Already have an account? Login'),
                  ),
              
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
Widget _textField(
  String label, // Label text
  TextInputType keyboardType, // Keyboard type (e.g., text, number)
  String? errorMessage, // Error message (optional)
  bool isObscure, // For obscured text (e.g., password)
  String? hintText, // Hint text (optional)
  maxlines,
  Function(String) onChanged,
) {
  return TextField(
    keyboardType: keyboardType,
    obscureText: isObscure,
    maxLines: 1,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label, // Label displayed above the text field
      hintText: hintText, // Hint text displayed inside the text field
      errorText: errorMessage?.isNotEmpty== true ? errorMessage : null, // Display error message if any

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey, width: 1.0)
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.black)
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.purple, width: 2.0), // Focused border color
      ),
    ),
  );
}