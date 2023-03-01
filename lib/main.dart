import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart'; // show getDatabasesPath, openDatabase;
import 'dart:io'; // show Platform, Directory;
import 'package:path_provider/path_provider.dart';
import 'package:squadmaker/models/attendance.dart';
import 'models/player.dart';
import 'models/gender.dart';
import 'models/league.dart';
import 'models/user.dart';
import 'models/attendance.dart';

void main() async {
  String appDocPath = "";

  WidgetsFlutterBinding.ensureInitialized();

  // Must use FFI package for SQFlite_3 for Windows Platforms
  if (Platform.isWindows) {
    Directory appDocDir = await getApplicationSupportDirectory();
    appDocPath = appDocDir.path;
    sqfliteFfiInit();
    // Change the default factory. On iOS/Android, if not using sqlite_flutter_lib you can forget
    // this step, it will use the sqlite version available on the system.
    databaseFactory = databaseFactoryFfi;
  } else {
    appDocPath = await getDatabasesPath();
  }

  // Start building database and initialize tables that need it
  var database = await openDatabase(
    join(appDocPath, "squadmaker.db"),
    onCreate: (db, version) async {
      await db.execute(Gender.createSQLTable());
      await db.execute(Player.createSQLTable());
      await db.execute(League.createSQLTable());
      await db.execute(User.createSQLTable());
      await db.execute(Attendance.createSQLTable());
      await Gender.initialize(db);
    },
    version: 1,
  );
  print(await Gender.list(database));

  // TEST create a player
  var player1 = Player(
    name: "Player1",
    gender: Gender(id: 1, name: "man"),
    //pronouns: "He/Him",
    //birthday: DateTime.utc(1995, 11, 27).toString(),
    phone: "+11234567890",
    email: "me@mail.com",
    //placeFrom: "Tucson, AZ",
    //photo: "/path/to/my/photo",
  );
  await player1.insert(database);
  print(await Player.list(database));

  // Test create a league
  var league1 = League(
    name: "Cool Guys League",
    teamName: "The Cool Guys",
    sport: "Kickball",
    captain: "Joe Schmo",
  );
  await league1.insert(database);
  print(await League.list(database));

  // Test create a user
  var user1 = User(
    name: "Tahostan Schrader",
    email: "tahostan@groton.com",
  );
  await user1.insert(database);
  print(await User.list(database));

  // Test create an attendance
  var attendance1 =
      Attendance(player: player1, game: "Game #1", attended: true);
  await attendance1.insert(database);
  print(await Attendance.list(database));
//   // TEST list
//   print(await Player.players(db));

//   // TEST update
//   player1.gender = Gender.woman.toString();
//   await player1.update(db);

//   // TEST delete
//   await player1.delete(db);
// //  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
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
