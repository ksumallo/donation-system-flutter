import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entities/user.dart';
import '../providers/auth_provider.dart';
import '../providers/organizations.dart';
import '../providers/user_provider.dart';
import '../entities/organization.dart';

class CreateOrganizationPage extends StatefulWidget {
  const CreateOrganizationPage({Key? key}) : super(key: key);

  @override
  _CreateOrganizationPageState createState() => _CreateOrganizationPageState();
}

class _CreateOrganizationPageState extends State<CreateOrganizationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(36));
    return base64Url.encode(values).toLowerCase().replaceAll('/', '').substring(0, len);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Organization'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.business),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the organization name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the organization description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final currentUser = await context.read<AuthProvider>().currentUser;
                      if (currentUser != null) {
                        final newOrganization = Organization(
                          id: getRandString(32), //call function to generate random string
                          name: _nameController.text,
                          description: _descriptionController.text,
                          openForDonations: false,
                          users: [currentUser],
                        );
                        await context.read<OrganizationProvider>().add(newOrganization);
                        
                        Navigator.pop(context);
                      } else {
                        print('Error: Current user not found');
                      }
                    }
                  },
                  child: Text('Create Organization'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
