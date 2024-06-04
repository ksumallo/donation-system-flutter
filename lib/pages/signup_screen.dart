import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'address_widget.dart';

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
  List<String>? addresses;
  String? contactNumber;
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _contactNumberController = TextEditingController();

  void _onAddressesChanged(List<String> newAddresses) {
    setState(() {
      addresses = newAddresses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                heading,
                emailField,
                passwordField,
                nameField,
                usernameField,
                contactNumberField,
                AddressWidget(onAddressChanged: _onAddressesChanged),
                submitButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get heading => const Padding(
    padding: EdgeInsets.only(bottom: 30),
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
        prefixIcon: Icon(Icons.email),
      ),
      onSaved: (value) => setState(() => email = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter an email address";
        }
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
        prefixIcon: Icon(Icons.lock),
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
        prefixIcon: Icon(Icons.person),
      ),
      onSaved: (value) => setState(() => name = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Name is required";
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
        prefixIcon: Icon(Icons.account_circle),
      ),
      onSaved: (value) => setState(() => username = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Username is required";
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
        prefixIcon: Icon(Icons.phone),
      ),
      onSaved: (value) => setState(() => contactNumber = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Contact Number is required";
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

        await context.read<AuthProvider>().register(
          email!,
          password!,
          name,
          username,
          addresses ?? [],
          contactNumber,
        );
        if (mounted) {
          Navigator.pop(context);
        }
      }
    },
    child: const Text("Sign Up"),
  );
}
