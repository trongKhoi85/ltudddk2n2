import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled15/screens/sign_in/sign_in_screen.dart';

import 'components/infor_screen.dart';
import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    void _showLogoutConfirmationDialog(BuildContext context) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Đăng xuất"),
            content: Text("Bạn có chắc chắn muốn đăng xuất?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Không"),
              ),
              TextButton(
                onPressed: () async {
                  // Clear "Remember Me" status
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('rememberMe', false);

                  // Sign out the user
                  await FirebaseAuth.instance.signOut();

                  // Navigate to SignInScreen
                  Navigator.pushReplacementNamed(context, SignInScreen.routeName);
                },
                child: Text("Có"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(
              "Profile",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 80),
            const ProfilePic(),
            const SizedBox(height: 20),
            Text("${user?.email ?? ''}"),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Tài khoản của tôi",
              icon: "assets/icons/User Icon.svg",
              press: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalInfoWidget(),
                  ),
                ),
              },
            ),
            ProfileMenu(
              text: "Thông báo",
              icon: "assets/icons/Bell.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Cài đặt",
              icon: "assets/icons/Settings.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Trung tâm hỗ trợ",
              icon: "assets/icons/Question mark.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Đăng xuất",
              icon: "assets/icons/Log out.svg",
              press: () => _showLogoutConfirmationDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
