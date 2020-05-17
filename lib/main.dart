import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Sam\'s Flutter App ', storage: CounterStorage()),
    );
  }
}

// class GetData {
//   Future<http.Response> fetchData(http.Client client) async {
//     return client.get('http://jsonplaceholder.typicode.com/photos')
//   }
// }

class CounterStorage {
  Future<String> get _localpath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localfile async {
    final path = await _localpath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localfile;
      String contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localfile;
    return file.writeAsString('$counter');
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final CounterStorage storage;

  MyHomePage({Key key, this.title, @required this.storage}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter;

  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter() async {
    setState(() {
      _counter++;
    });

    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new ListView.builder(
        itemCount: _counter,
        itemBuilder: (context, index) {
          return new ListTile(
              leading: const Icon(FontAwesomeIcons.book),
              title: Text('This is a list item'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SecondPage()));
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Second Page'),
        ),
        body: Center(
          child: RaisedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              label: Text('push me'),
              icon: new Icon(FontAwesomeIcons.stepBackward)),
        ));
  }
}
