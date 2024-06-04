import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? name;
  String? username;
  late List<String?> addresses;
  String? contactNumber;
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _contactNumberController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [heading, emailField, passwordField, nameField, usernameField,
                contactNumberField, submitButton],
              ),
            )),
      ),
    );
  }

  Widget get heading => const Padding(
    padding: EdgeInsets.only(bottom: 32, top: 48),
    child: Text(
      "Sign Up",
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
  );

 Widget get emailField => Padding(
  padding: const EdgeInsets.only(bottom: 30),
  child: TextFormField(
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      labelText: "Email",
      hintText: "Enter a valid email",
    ),
    onSaved: (value) => setState(() => email = value),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Please enter an email address";
      }

      // regex for email validation:
      //email format: ('letters, digits, and underscores), hyphen (-), or period (.)' @ 'domain name' '.' 'domain extension')
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return "Please enter a valid email address";
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
      labelText: "Password",
      hintText: "At least 6 characters",
    ),
    obscureText: true,
    onSaved: (value) => setState(() => password = value),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Please enter a valid password";
      } else if (value.length < 6) {
        return "Password must be at least 6 characters";
      } 
      return null;
    },
  ),
);

Widget get nameField => Padding(
  padding: const EdgeInsets.only(bottom: 30),
  child: TextFormField(
    controller: _nameController,
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      labelText: "Name",
      hintText: "Enter your name",
    ),
    onSaved: (value) {
      // save the first name to a variable
    },
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Name is required"; //require error mssg
      }
      return null;
    },
  ),
);

Widget get usernameField => Padding(
  padding: const EdgeInsets.only(bottom: 30),
  child: TextFormField(
    controller: _usernameController,
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      labelText: "User Name",
      hintText: "Enter username",
    ),
    onSaved: (value) {

    },
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Last Name is required"; //require error mssg
      }
      return null;
    },
  ),
);

Widget get contactNumberField => Padding(
  padding: const EdgeInsets.only(bottom: 30),
  child: TextFormField(
    controller: _contactNumberController,
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      labelText: "Contact Number",
      hintText: "Enter contact number",
    ),
    onSaved: (value) {

    },
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Last Name is required"; //require error mssg
      }
      return null;
    },
  ),
);

  Widget get submitButton => ElevatedButton(
  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final name = _nameController.text;
      final username = _usernameController.text;
      final contactNumber = _contactNumberController.text;
      final addresses = ['My House, Elm Street'];

      await context.read<AuthProvider>().register(email!, password!, name, username, addresses, contactNumber);
      if (mounted) { 
        Navigator.pop(context);
      }
    }
  },
  child: const Text("Sign Up"),
);

}