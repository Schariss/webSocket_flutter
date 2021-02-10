import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        channel: new IOWebSocketChannel.connect("wss://echo.websocket.org"),
        title: "Web Socket",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final WebSocketChannel channel;
  MyHomePage({this.channel, this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _text = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web Socket"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Form(
                child: new TextFormField(
              decoration: InputDecoration(labelText: "Send a message"),
              controller: _text,
            )),
            new StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                return new Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () {
          if (_text.text.isNotEmpty) {
            widget.channel.sink.add(_text.text);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
