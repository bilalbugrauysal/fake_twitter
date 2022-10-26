import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';

import '../screens/tweet-detail.dart';

class TweetCard extends StatelessWidget {
  TweetCard({super.key, required this.tweet, required this.user});

  TweetData tweet;
  UserData user;

  @override
  Widget build(BuildContext context) {
    print(tweet);
    return Card(
      child: Column(children: [
        ListTile(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TweetDetailPage(
                        tweetId: tweet.id,
                      ))),
          leading: user.profileImageUrl != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(user.profileImageUrl!))
              : const CircleAvatar(backgroundColor: Colors.grey),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Text(
                  "${user.name}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text("@${user.username}")
              ],
            ),
            Padding(padding: EdgeInsets.all(4)),
            Text('${tweet.text}')
          ]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const FaIcon(FontAwesomeIcons.comment),
            const SizedBox(width: 8),
            //Text('${tweet.id}'),
            const SizedBox(width: 8),

            const FaIcon(FontAwesomeIcons.retweet),
            const SizedBox(width: 8),
            //Text('${tweet.id}'),
            const SizedBox(width: 8),

            const FaIcon(FontAwesomeIcons.heart),
            const SizedBox(width: 8),
            //Text('${tweet.id}'),
            const SizedBox(width: 8),

            const FaIcon(FontAwesomeIcons.upload),
            // Use Builder to get the widget context
            const SizedBox(width: 8),
          ],
        ),
      ]),
    );
  }
}
