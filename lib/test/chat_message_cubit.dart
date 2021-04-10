import 'dart:convert';
import 'dart:typed_data';

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
  String _messageBuffer = '';
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

        // listen to message incoming
        connection.input.listen(onDataReceived).onDone(() {

        });
      }).catchError((error){
        print("Cannot connect, exception occured");
        print(error);
      });
    }
  }

  void onDataReceived(Uint8List data){

    // Buffer for parse data
    int backspacesCounter = 0;

    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >=0; i --){
      if (data[i] == 8 || data[i] == 127){
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0){
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0){
      final message = Message(
        id: this.state.messages.length % 2 == 0 ? this.state.messages.length + 1 : this.state.messages.length + 2,
        message: backspacesCounter > 0
            ? _messageBuffer.substring(0, _messageBuffer.length - backspacesCounter)
            : _messageBuffer + dataString.substring(0, index),);
      _messages.add(message);
      emit(ChatState(
        messages: _messages,
        isConnected: this.state.isConnected,
        isConnecting: this.state.isConnecting,
      ));
      _messageBuffer = dataString.substring(index);

    } else {
      _messageBuffer = (backspacesCounter > 0 ?
      _messageBuffer.substring(0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }

  }

  void addMessage(String message) async {

    String cleanMessage = message.trim();

    _messages.add(Message(message: cleanMessage, id: this.state.messages.length % 2 == 0 ? this.state.messages.length + 2 : this.state.messages.length + 1));

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
