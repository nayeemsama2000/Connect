import 'package:connect/Utils/app_colors.dart';
import 'package:connect/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  List<dynamic> _users = [];
  List<dynamic> _filteredUsers = [];
  String _searchText = "";
  String? _myId;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    _myId = prefs.getString("userId");

    final users = await ApiService.getUsers();

    // remove yourself from the list
    final filtered = users.where((u) => u["_id"] != _myId).toList();

    setState(() {
      _users = filtered;
      _filteredUsers = filtered;
    });
  }

  void _search(String text) {
    setState(() {
      _searchText = text;
      _filteredUsers = _users
          .where((u) =>
          u["name"].toString().toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      appBar: AppBar(title: const Text("Chats"),backgroundColor: AppColors.primaryBlue,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Card(color: AppColors.primaryWhite,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))),child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: _search,
                  decoration: const InputDecoration(
                    hintText: "Search users...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: _filteredUsers.isEmpty
                    ? const Center(child: Text("No users found"))
                    : RefreshIndicator(
                  onRefresh: () async {
                    _loadUsers();
                  },
                  child: ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(user["name"],style: TextStyle(color: Colors.black,fontSize: 18),),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                receiverId: user["_id"],
                                receiverName: user["name"],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),),
      )
    );
  }
}
