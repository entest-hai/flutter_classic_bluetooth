import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Message {
  final String message;
  final int id;
  Message({this.message, this.id});
}

class ChatState {
  bool isConnecting;
  bool isConnected;
  List<Message> messages;
  ChatState({this.isConnecting = true, this.isConnected = false, this.messages});
}

class ChatCubit extends Cubit<ChatState> {
  BluetoothConnection connection;
  List<Message> _messages = [];
  ChatCubit() : super(ChatState(messages: []));

  void establishConnection(BluetoothDevice device){

    if (connection != null){
      connection.dispose();
      emit(ChatState(
        messages: [],
        isConnecting: true,
        isConnected: false,
      ));
    }

    if (!this.state.isConnected){
      BluetoothConnection.toAddress(device.address).then((_connection){
        print("Connected to device");
        connection = _connection;
        emit(ChatState(
          messages: [],
          isConnected: true,
          isConnecting: false,
        ));
      }
      );
    }
  }

  void addMessage(String message) async {

    String cleanMessage = message.trim();

    _messages.add(Message(message: cleanMessage, id: this.state.messages.length + 1));

    try {
      connection.output.add(utf8.encode(cleanMessage + "\r\n"));
      await connection.output.allSent;
      print("send message to blutooth device");

    } catch(e){
      print(e.toString());
    }

    emit(ChatState(
        isConnected: true,
        isConnecting: false,
        messages: _messages));
  }

}
