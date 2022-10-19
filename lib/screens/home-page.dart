import 'package:fake_twitter/twitter-api.dart';
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
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: profileImage != null
              ? CircleAvatar(backgroundImage: NetworkImage(profileImage!))
              : CircleAvatar(
                  backgroundColor: Colors.grey,
                ),
        ),
        title: Text("Home - ${name}"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
              final user =
                  users.where((element) => element.id == tweet.authorId).first;
              if (index == 0) {
                print("tweet");
                print(tweet);
              }
              return Card(
                child: ListTile(
                  leading: user.profileImageUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user.profileImageUrl!))
                      : CircleAvatar(
                          backgroundColor: Colors.grey,
                        ),
                  title: Text('${tweet.text}'),
                  subtitle: Text("${user.name} - @${user.username}"),
                ),
              );
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
