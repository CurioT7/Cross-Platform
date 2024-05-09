import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocket {
  static IO.Socket? _socket;

  static void initializeSocket() {
    _socket = IO.io('http://192.168.1.8:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.on('connect', (_) {
      print('Connected to socket');
    });

    _socket!.on('disconnect', (_) {
      print('Disconnected from socket');
    });

    _socket!.on('getMessage', (data) {
      print('New message received: $data');
    });
  }

  static void connect() {
    _socket!.connect();
  }

  static void disconnect() {
    _socket!.disconnect();
  }

  static void sendMessage(String message, String recipient) {
    _socket!.emit('newMessage', [message, recipient]);
  }
}
