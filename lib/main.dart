import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/api/firebase_auth_provider.dart';
import 'package:final_proj/api/firebase_storage_api.dart';
import 'package:final_proj/api/firestore_donation_provider.dart';
import 'package:final_proj/api/firestore_organization_provider.dart';
import 'package:final_proj/api/firestore_user_provider.dart';
import 'package:final_proj/entities/organization.dart';
import 'package:final_proj/entities/user.dart';
import 'package:final_proj/firebase_options.dart';
import 'package:final_proj/pages/admin_app.dart';
import 'package:final_proj/pages/donate_page.dart';
import 'package:final_proj/pages/organization_app.dart';
import 'package:final_proj/pages/organization_list.dart';
import 'package:final_proj/pages/signin_screen.dart';
import 'package:final_proj/pages/user_app.dart';
import 'package:final_proj/providers/auth_provider.dart';
import 'package:final_proj/providers/cloud_storage_provider.dart';
import 'package:final_proj/providers/donation_provider.dart';
import 'package:final_proj/providers/organizations.dart';
import 'package:final_proj/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var firestore = FirebaseFirestore.instanceFor(app: app);
  var auth = fb_auth.FirebaseAuth.instanceFor(app: app);
  final firebaseStorage = FirebaseStorage.instanceFor(app: app);

  CloudStorageProvider cloudStorageProvider =
      FirebaseStorageProvider(firebaseStorage);

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

  // TODO: Remove dummy User
  final User dummyUser = User(
    uid: 'nccampo',
    name: 'Lone Skum',
    username: 'skum_lone_6767',
    addresses: ['1242 Baltazar, Olongapo', '9387, Los Banos'],
    contactNumber: '+63928191911',
  );

  // TODO: Remove dummy [Organization]
  final Organization dummyOrg = Organization(
      id: 'someRandomIdAasdkjadh',
      name: 'Test Org',
      description: 'Lorem ipsum dolor sit amet, '
          'consectetur adipiscing elit. '
          'Donec vehicula nulla vitae rhoncus convallis. '
          'Suspendisse tempor lectus vitae hendrerit finibus. '
          'Etiam vitae egestas magna. Donec sed faucibus nibh. '
          'Nulla odio metus, pretium vel nunc id, tempus condimentum lectus. '
          'Sed aliquam lobortis nulla, sit amet porta quam gravida vitae. '
          'Maecenas non ullamcorper elit, a venenatis eros. '
          'Sed condimentum massa sit amet felis molestie venenatis.');

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: false,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const SignInPage(),
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
            return MaterialPageRoute(builder: (context) => UserApp(user: user));
          case '/user-dev':
            return MaterialPageRoute(
              builder: (context) => UserApp(
                user: dummyUser,
              ),
            );
          case '/organizations':
            return MaterialPageRoute(
              builder: (context) => const OrganizationList(),
            );

          case '/organization-dev':
            return MaterialPageRoute(
              builder: (context) => OrganizationApp(org: dummyOrg),
            );

          case '/admin':
            return MaterialPageRoute(
              builder: (context) => const AdminApp(),
            );
          default:
            return null;
        }
      },
    );
  }
}
