import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/common_enum/common_enum.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

MessageStatus getLastMessageStatus(Channel channel, Message message) {
  var listReadStates = channel.state?.read;
  if (listReadStates != null) {
    if (listReadStates.every((s) => s.unreadMessages == 0)) {
      return MessageStatus.read;
    } else if (message.status == MessageSendingStatus.sent) {
      return MessageStatus.recived;
    }
  }

  return MessageStatus.sending;
}

MessageStatus getMineMessageStatus(Channel channel, Message message) {
  if (message.status != MessageSendingStatus.sent) {
    return MessageStatus.sending;
  }
  final currentUser = getIt.get<ChatService>().currentUser;

  final readList = channel.state?.read.where((read) {
        if (read.user.id == currentUser.id) return false;
        return (read.lastRead.isAfter(message.createdAt) ||
            read.lastRead.isAtSameMomentAs(message.createdAt));
      }).toList() ?? [];

  final isAllRead = readList.length >= (channel.memberCount ?? 0) - 1;

  if (isAllRead) {
    return MessageStatus.read;
  }

  return MessageStatus.recived;
}

User? getOpponentUser(Channel channel) {
  final currentUser = getIt.get<ChatService>().currentUser;
  final opponent = channel.state?.members.firstWhere((m) => m.userId != currentUser.id);
  return opponent?.user;
}
