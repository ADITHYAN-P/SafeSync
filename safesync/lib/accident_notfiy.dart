import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AccidentN extends StatefulWidget {
  const AccidentN({super.key});

  @override
  State<AccidentN> createState() => _AccidentNState();
}

class _AccidentNState extends State<AccidentN> {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://accident-backend-qjlv.onrender.com/ws'),
  );
  void wait() async {
    await channel.ready;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    wait();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: channel.stream,
            builder: (context, snapshot) {
              return Text(snapshot.hasData ? '${snapshot.data}' : '');
            },
          )
        ],
      ),
    );
  }
}
