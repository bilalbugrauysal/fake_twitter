import 'package:fake_twitter/twitter-api.dart';
import 'package:fake_twitter/widgets/card-subtitle-aligned-right.dart';
import 'package:fake_twitter/widgets/fake-app-bar.dart';
import 'package:flutter/material.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserData? userData;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FakeAppBar(
          context: context,
          profileImage: userData!.profileImageUrl!,
          name: '${userData!.name} - Profile',
          userId: userData!.id),
      body: Visibility(
        visible: userData != null,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            CardSubtitleAlignedRight(
                value: userData!.username, title: 'Username'),
            CardSubtitleAlignedRight(value: userData!.id, title: 'Id'),
            CardSubtitleAlignedRight(
                value: userData!.description, title: 'Description'),
            CardSubtitleAlignedRight(
                value: userData!.isProtected.toString(), title: 'Private'),
            CardSubtitleAlignedRight(
                value: userData!.isVerified.toString(), title: 'Verified'),
            CardSubtitleAlignedRight(value: userData!.url, title: 'Url'),
            CardSubtitleAlignedRight(
                value: userData!.location, title: 'Location'),
          ]),
          // separatorBuilder: (BuildContext context, int index) =>
          //     const Divider(),
        ),
      ),
    );
  }

  Future<void> getProfileData() async {
    final me = await FakeTwitterApi.instance.usersService.lookupMe(userFields: [
      UserField.profileImageUrl,
      UserField.location,
      UserField.url,
      UserField.description,
      UserField.protected,
      UserField.verified,
    ]);
    setState(() {
      userData = me.data;
    });
  }
}
