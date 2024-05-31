import 'package:final_proj/entities/user.dart';
import 'package:final_proj/pages/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
      body: FutureBuilder(
        future: context.watch<AuthProvider>().currentUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.popAndPushNamed(
                context,
                '/user-profile',
                arguments: snapshot.data!,
              );
            });
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
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
                    submitButton,
                    signUpButton
                  ],
                ),
              ),
            ),
          );
        },
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

  String _errorString = "";

  Widget get submitButton => Column(
    children: <Widget>[
      ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            try {
              await context.read<AuthProvider>().login(email!, password!);
            } on Exception catch (e) {
              setState(() {
                _errorString = e.toString();
              });
            }
          }
        },
        child: const Text("Sign In")
      ),
      if (_errorString.isNotEmpty) Text(
        _errorString,
        style: const TextStyle(color: Colors.red),
      ),
    ],
  );

  Widget get signUpButton => Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No account yet?"),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                child: const Text("Sign Up"))
          ],
        ),
      );
}
