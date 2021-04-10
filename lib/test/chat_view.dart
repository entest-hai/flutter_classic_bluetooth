import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'chat_message_cubit.dart';

class BluetoothChatView extends StatefulWidget {
  final BluetoothDevice bluetoothDevice;
  BluetoothChatView({this.bluetoothDevice});
  @override
  State<StatefulWidget> createState() {
    return _BluetoothChatState();
  }
}

class _BluetoothChatState extends State<BluetoothChatView> {
  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live chat with ${widget.bluetoothDevice.name}"),),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(child: BlocBuilder<ChatCubit,ChatState>(builder: (context,state){
              return ListView(
                padding: const EdgeInsets.all(12.0),
                controller: scrollController,
                children: buildMessages(state.messages),);
            },)
            ),
            Row(
              children: [
                Flexible(child: BlocBuilder<ChatCubit, ChatState>(builder: (context,state){
                  return Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: TextField(
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      style: const TextStyle(fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: state.isConnecting
                            ? 'Wait until connected...'
                            : state.isConnected
                            ? 'Type your message...'
                            : 'Chat got disconnected',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      enabled: state.isConnected,
                    ),
                  );
                },)
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.send),

                    // check connected before sending message
                    onPressed: () async {
                        if (textEditingController.text.trim().length > 0) {
                          BlocProvider.of<ChatCubit>(context).addMessage(
                              textEditingController.text
                          );
                          textEditingController.clear();
                          scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 333),
                              curve: Curves.easeOut);
                        }
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> buildMessages(List<Message> messages) {
    List<Widget> list = messages
        .map((message) => Row(
      mainAxisAlignment: message.id % 2 == 0
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          child: Text(
            message.message,
            style: TextStyle(color: Colors.white),
          ),
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
          width: 222.0,
          decoration: BoxDecoration(
              color: message.id % 2 == 0 ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(7.0)),
        )
      ],
    ))
        .toList();
    return list;
  }
}