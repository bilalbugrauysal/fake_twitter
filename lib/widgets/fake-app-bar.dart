import 'package:fake_twitter/screens/home-page.dart';
import 'package:fake_twitter/screens/own-tweets-page.dart';
import 'package:fake_twitter/screens/profile-page.dart';
import 'package:flutter/material.dart';

class FakeAppBar extends AppBar {
  FakeAppBar(
      {required BuildContext context,
      String? profileImage,
      String? name,
      String? userId})
      : super(
            leading: IconButton(
              icon: profileImage != null
                  ? CircleAvatar(backgroundImage: NetworkImage(profileImage))
                  : CircleAvatar(
                      backgroundColor: Colors.grey,
                    ),
              iconSize: 70,
              onPressed: () {
                navigateToPage(context, ProfilePage());
              },
            ),
            title: Text("${name}"),
            backgroundColor: const Color(0xFF1DA1F2),
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  navigateToPage(context, HomePage());
                },
              ),
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  navigateToPage(context, OwnTweetsPage());
                },
              ),
            ]);

  static Future<void> navigateToPage(
      BuildContext context, Widget widget) async {
    final route = MaterialPageRoute(builder: (context) => widget);
    await Navigator.push(context, route);
  }
}
