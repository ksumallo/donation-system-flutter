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
import 'package:final_proj/pages/admin_app.dart';
import 'package:final_proj/pages/donate_page.dart';
import 'package:final_proj/pages/organization_app.dart';
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
import 'package:final_proj/pages/user_app.dart';

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
      initialRoute: '/organization-dev',
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
            return MaterialPageRoute(
                builder: (context) => UserApp(user: user));
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
