import 'package:connect/Utils/app_colors.dart';
import 'package:connect/Utils/app_strings.dart';
import 'package:connect/screens/call_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../services/api_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatScreen({super.key, required this.receiverId, required this.receiverName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<dynamic> _messages = [];
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _controller = TextEditingController();
  String? _myId;
  IO.Socket? socket;

  @override
  void initState() {
    super.initState();
    _connectSocket();

  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _connectSocket() async {
    final prefs = await SharedPreferences.getInstance();
    _myId = prefs.getString("userId");

    socket = IO.io(Urls.baseUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    socket!.connect();

    socket!.onConnect((_) {
      print("Connected to socket server");

      socket!.emit("join", _myId); // join my userId room
    });

    socket!.on("receiveMessage", (data) {
      print('Received message - $data');
      setState(() {
        _messages.add(data);
        _scrollToBottom();
      });
    });

    socket!.on("senderMessage", (data) {
      print('Sender message - $data');
      // setState(() {
      //   _messages.add(data);
      // });
      _scrollToBottom();
    });

    _loadMessages();

  }

  Future<void> _loadMessages() async {
    if (_myId == null) return;
    final msgs = await ApiService.getMessages(_myId!, widget.receiverId);
    print('olddddd $msgs');
    setState(() {_messages = msgs;
    _scrollToBottom(); // scroll after loading
    });

  }

  void _sendMessage() async {
    if (_controller.text.isEmpty || _myId == null) return;

    socket!.emit("sendMessage", {
      "sender": _myId,
      "receiver": widget.receiverId,
      "text": _controller.text,
    });

    // final message = await ApiService.sendMessage(
    //   _myId!,
    //   widget.receiverId,
    //   _controller.text,
    // );
    // if (message != null) {
    //
    // }

    setState(() {
      _messages.add({
        "sender": _myId,
        "receiver": widget.receiverId,
        "text": _controller.text,
      });
      // _messages.add(message);
      _controller.clear();
    });


    _controller.clear();
  }

  @override
  void dispose() {
    socket?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(title: Text("Chat with ${widget.receiverName}"),backgroundColor: AppColors.primaryBlue,actions: [
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CallScreen(userName: widget.receiverName),
              ),
            );
          },
        ),
      ],),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg["sender"] == _myId;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(msg["text"],style: TextStyle(color: isMe ? Colors.white : Colors.black,),),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        filled: true,
                        fillColor: AppColors.secondaryGrey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send,color: Colors.white,),
                  onPressed: _sendMessage,
                  padding: EdgeInsets.all(15),
                  style: IconButton.styleFrom(backgroundColor: AppColors.secondaryBlue),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
