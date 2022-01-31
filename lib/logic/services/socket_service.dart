import 'package:get_it/get_it.dart';
import 'package:sputnik/logic/locators/user_time_reward.dart';
import 'package:sputnik/logic/model/auth_model.dart';
import 'package:sputnik/ui/helpers/phone_services/lifecycle/app_lifecycle.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:hive/hive.dart';
import 'package:sputnik/config/hive_config.dart';
import 'package:flutter/material.dart';


class SocketService {
    final Box userBox = Hive.box(BNames.authModel);
    final userReward = GetIt.instance.get<UserRewardInterval>();

    String get token {
      AuthModel authModel = userBox.get(BNames.authModel);
      return authModel.token;
    }
    IO.Socket? socket;
    late LifecycleEventHandler eventHandler;

    SocketService(){
      eventHandler = LifecycleEventHandler(
      
        resumeCallBack: () async => {
          print("Resume socket"),
          startSocket(),
          userReward.needToReload = true,
        },
        suspendingCallBack: () async => {
          print("Suspend socket"),
          stopSocket(),
        },
      
      );
    }

    void startSocket() async{
      socket = IO.io(
              'wss://api.sputnik-1.com',
              IO.OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
                  //.setExtraHeaders({'token': token}) // optional
                  .setAuth({'token': token}).build());
      socket?.onConnect((data) {
            debugPrint('client:  socket io:  on connect:  data = ${data?.toString()}');
          });
          try {
            socket?.onConnectError((data) => debugPrint('client:  socket io:  on connect error:  data = ${data?.toString()}'));
            socket?.onConnectTimeout((data) => debugPrint('client:  socket io:  on connect timeout:  data = ${data?.toString()}'));
            socket?.onConnecting((data) => debugPrint('client:  socket io:  on connecting:  data = ${data?.toString()}'));
            socket?.onDisconnect((data) => debugPrint('client:  socket io:  on disconnect:  data = $data'));
            socket?.onError((data) => debugPrint('client:  socket io:  on error:  data = ${data?.toString()}'));
            socket?.onReconnect((data) => debugPrint('client:  socket io:  on reconnect:  data = ${data?.toString()}'));
            socket?.onReconnectAttempt((data) => debugPrint('client:  socket io:  on reconnect attempt:  data = ${data?.toString()}'));
            socket?.onReconnectFailed((data) => debugPrint('client:  socket io:  on reconnect failed:  data = ${data?.toString()}'));
            socket?.onReconnectError((data) => debugPrint('client:  socket io:  on reconnect error:  data = ${data?.toString()}'));
            socket?.onReconnecting((data) => debugPrint('client:  socket io:  on reconnecting:  data = ${data?.toString()}'));
            socket?.onPing((data) => debugPrint('client:  socket io:  on ping:  data = ${data?.toString()}'));
            socket?.onPong((data) => debugPrint('client:  socket io:  on pong:  data = ${data?.toString()}'));
            //socket.onclose(() => debugPrint('client:  socket io:  on close'));
          } catch (e, s) {
            print(s);
            debugPrint('client:  socket io:  error:  e = $e}');
          }

          socket?.connect();
    }

    void stopSocket(){
        socket?.disconnect();
    }

}