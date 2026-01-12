import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Image.asset('assets/bouncing-ball.gif', scale: 0.5),
            ElevatedButton(
              onPressed: () async {
                var json = await fetchData(1000);
                debugPrint("Json Data: ${json.length}");
              },
              child: Text("Async/Await"),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                var json = await compute(fetchData, 1000);
                debugPrint('Compute  result: length - ${json.length}');
              },
              label: Text('Compute'),
              icon: Icon(Icons.star),
            ),
            // ElevatedButton.icon(
            //   onPressed: () async {
            //     var receivePort = ReceivePort();
            //     await Isolate.spawn(fetchDataIsolate, (
            //     iteration: 1000,
            //     sendPort: receivePort.sendPort,
            //     ));
            //     receivePort.listen((message) {
            //       debugPrint('Isolate progress: $message');
            //     });
            //   },
            //   label: Text('Isolates'),
            //   icon: Icon(Icons.star),
            // )
          ],
        ),
      ),
    );
  }
}

Future<String> fetchData(int iteration) async {
  final jsonData = jsonEncode(
    List.generate(10000, (i) => {'id': i, 'value': 'value of $i'}),
  );

  for (var i = 0; i < iteration; i++) {
    jsonDecode(jsonData);
  }

  return jsonData;
}


// //========> outside the main app
// Future<void> fetchDataIsolate(({int iteration, SendPort sendPort}) data) async {
//   final jsonData = jsonEncode(
//     List.generate(10000, (i) => {'id': i, 'value': 'value of $i'}),
//   );
//
//   for (var i = 1; i <= data.iteration; i++) {
//     jsonDecode(jsonData);
//     var percentage = (i / data.iteration) * 100;
//     if (percentage % 10 == 0) {
//       data.sendPort.send(percentage);
//     }
//   }
// }
