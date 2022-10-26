import 'package:fake_twitter/screens/tweet-detail.dart';
import 'package:fake_twitter/twitter-api.dart';
import 'package:fake_twitter/widgets/fake-app-bar.dart';
import 'package:fake_twitter/widgets/tweet-card.dart';
import 'package:flutter/material.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? profileImage;
  String? name;
  String? userId;
  List<TweetData> tweets = [];
  List<UserData> users = [];

  @override
  void initState() {
    super.initState();
    getProfileData().then((value) => getTweets());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FakeAppBar(
          context: context,
          profileImage: profileImage,
          name: '$name - Home',
          userId: userId),
      drawer: Drawer(
        child: ListView(children: <Widget>[
          const DrawerHeader(
            child: Text('Header'),
          ),
          ListTile(
            title: Text('First Menu Item'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Second Menu Item'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text('About'),
            onTap: () {},
          ),
        ]),
      ),
      body: Visibility(
        visible: tweets.length > 0,
        child: RefreshIndicator(
          onRefresh: getTweets,
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: tweets.length,
            itemBuilder: (BuildContext context, int index) {
              final tweet = tweets![index];
              final user = users.where((e) => e.id == tweet.authorId).first;
              return TweetCard(tweet: tweet, user: user);
            },
            // separatorBuilder: (BuildContext context, int index) =>
            //     const Divider(),
          ),
        ),
      ),
    );
  }

  Future<void> getProfileData() async {
    final me = await FakeTwitterApi.instance.usersService
        .lookupMe(userFields: [UserField.profileImageUrl]);
    setState(() {
      profileImage = me.data.profileImageUrl;
      name = me.data.name;
      userId = me.data.id;
    });
  }

  Future<void> getTweets() async {
    final res = await FakeTwitterApi.instance.tweetsService.lookupHomeTimeline(
      userId: userId!,
      expansions: [TweetExpansion.authorId],
      tweetFields: [TweetField.entities],
      userFields: [UserField.profileImageUrl, UserField.username],
    );
    setState(() {
      tweets = res.data;
      if (res.hasIncludes && res.includes != null) {
        users = res.includes!.users!;
      }
    });
  }
}
