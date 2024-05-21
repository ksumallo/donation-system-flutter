import 'package:final_proj/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_proj/providers/auth_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool showSignInErrorMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  heading,
                  emailField,
                  passwordField,
                  showSignInErrorMessage ? signInErrorMessage : Container(),
                  submitButton
                ],
              ),
            )),
      ),
    );
  }

  Widget get heading => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Sign In",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      );

  Widget get emailField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Email"),
              hintText: "juandelacruz09@gmail.com"),
          onSaved: (value) => setState(() => email = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your email";
            }
            return null;
          },
        ),
      );

  Widget get passwordField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Password"),
              hintText: "******"),
          obscureText: true,
          onSaved: (value) => setState(() => password = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your password";
            }
            return null;
          },
        ),
      );

  Widget get signInErrorMessage => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Invalid email or password",
          style: TextStyle(color: Colors.red),
        ),
      );

  Widget get submitButton => ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          try {
            User user = await context
              .read<AuthProvider>()
              .login(email!, password!);
            if (mounted) Navigator.popAndPushNamed(context, "/user-profile", arguments: user);
          }
          on Exception catch (e) {
            print(e.toString());
          }
          }
      },
      child: const Text("Sign In"));

}
