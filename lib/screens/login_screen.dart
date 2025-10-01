import 'package:connect/Utils/app_colors.dart';
import 'package:connect/screens/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
// import 'chat_list_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _loading = false;

  void _login() async {
    if (_nameController.text.isEmpty) return;

    setState(() => _loading = true);

    final user = await ApiService.login(_nameController.text);

    setState(() => _loading = false);

    if (user != null) {
      // Save user locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("userId", user["_id"]);
      await prefs.setString("userName", user["name"]);

      // Go to chat list
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UsersListScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)
          ),
          color: AppColors.primaryWhite,
          margin: EdgeInsets.symmetric(horizontal: 20),
          // decoration: BoxDecoration(
          //   color: AppColors.primaryWhite,
          //   borderRadius: BorderRadius.circular(25)
          // ),
          // padding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  // height: 20,
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      _login.call();
                    },
                    style: TextStyle(color: Colors.black,fontSize: 20),
                    controller: _nameController,
                    decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),labelText: "Enter your name",labelStyle: TextStyle(color: Colors.black54,fontSize: 20),floatingLabelBehavior: FloatingLabelBehavior.never,border: InputBorder.none),
                  ),
                ),
                const SizedBox(height: 20),
                _loading
                    ? const CircularProgressIndicator()
                    : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryBlue),
                                            onPressed: _login,
                                            child: const Text("Login",style: TextStyle(color: Colors.white,fontSize: 18),),
                                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
