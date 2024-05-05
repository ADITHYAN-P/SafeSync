import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
  final wsUrl = Uri.parse('ws://127.0.0.1:8000/ws');
  final channel = WebSocketChannel.connect(wsUrl);

  await channel.ready;
  

  channel.stream.listen((message) {
    channel.sink.add('received!');
    channel.sink.close(status.goingAway);
  });
}