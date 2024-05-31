import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/api/firebase_auth_provider.dart';
import 'package:final_proj/api/firebase_storage_api.dart';
import 'package:final_proj/api/firestore_donation_provider.dart';
import 'package:final_proj/api/firestore_user_provider.dart';
import 'package:final_proj/api/firestore_organization_provider.dart';
import 'package:final_proj/entities/organization.dart';
import 'package:final_proj/entities/user.dart';
import 'package:final_proj/firebase_options.dart';
import 'package:final_proj/pages/donate_page.dart';
import 'package:final_proj/pages/organization_list.dart';
import 'package:final_proj/pages/signin_screen.dart';
import 'package:final_proj/providers/auth_provider.dart';
import 'package:final_proj/providers/cloud_storage_provider.dart';
import 'package:final_proj/providers/donation_provider.dart';
import 'package:final_proj/providers/organizations.dart';
import 'package:final_proj/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:final_proj/pages/user_profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var firestore = FirebaseFirestore.instanceFor(app: app);
  var auth = fb_auth.FirebaseAuth.instanceFor(app: app);
  final firebaseStorage = FirebaseStorage.instanceFor(app: app);

  CloudStorageProvider cloudStorageProvider = FirebaseStorageProvider(firebaseStorage);

  UserProvider userProvider = FirestoreUserProvider(firestore);
  OrganizationProvider organizationProvider = FirestoreOrganizationProvider(
    firestore,
    userProvider: userProvider,
  );
  AuthProvider authProvider = FirebaseAuthProvider(auth, userProvider);
  DonationProvider donationProvider = FirestoreDonationProvider(
    firestore: firestore,
    userProvider: userProvider,
    organizationProvider: organizationProvider,
    cloudStorage: cloudStorageProvider,
  );

  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider(
          create: (context) => organizationProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => userProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => authProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => donationProvider,
        ),
      ],
      child: MyApp(authProvider),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AuthProvider _auth;

  const MyApp(this._auth, {super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLifecycleListener _listener;
  
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) =>
                  const SignInPage(),
            );
          case '/donate-dev':
            return MaterialPageRoute(
              builder: (context) => DonatePage(
                receipient: Organization(
                  id: "test-org",
                  name: "Test Organization",
                ),
              ),
            );
          case '/user-profile':
            User user = settings.arguments as User;
            return MaterialPageRoute(builder: (context) => UserProfile(user: user));
          case '/user-profile-dev':
            return MaterialPageRoute(
              builder: (context) => UserProfile(
                user: User(
                  uid: 'nccampo',
                  name: 'Nathan Campo',
                  username: 'nccampo',
                  addresses: ['1242 Baltazar, Olongapo', '9387, Los Banos'],
                  contactNumber: '+63928191911',
                ),
              ),
            );
          case '/organizations':
            return MaterialPageRoute(
              builder: (context) => const OrganizationList(),
            );

          default:
            return null;
        }
      },
    );
  }
}
