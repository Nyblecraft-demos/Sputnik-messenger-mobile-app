import 'package:sputnik/main.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart' as StreamChat;

class ChatService {
  final client = StreamChat.StreamChatClient(
    getstreamKey,
    logLevel: StreamChat.Level.WARNING,
    connectTimeout: Duration(seconds: 20),
    receiveTimeout: Duration(milliseconds: 20),
  );

  StreamChat.User get currentUser => client.state.currentUser as StreamChat.User;
}
