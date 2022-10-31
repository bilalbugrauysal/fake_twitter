import 'dart:convert';
import 'dart:developer';

import 'package:fake_twitter/twitter-api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';

class TweetDetailPage extends StatefulWidget {
  final String tweetId;
  const TweetDetailPage({required this.tweetId, super.key});

  @override
  State<TweetDetailPage> createState() => _TweetDetailPageState();
}

class _TweetDetailPageState extends State<TweetDetailPage> {
  TweetData? tweet;
  List<UserData> users = [];

  @override
  void initState() {
    super.initState();
    FakeTwitterApi.instance.tweets.lookupById(
      tweetId: widget.tweetId,
      expansions: [
        // TweetExpansion.attachmentsMediaKeys,
        TweetExpansion.authorId,
        TweetExpansion.inReplyToUserId,
        // TweetExpansion.attachmentsPollIds,
        TweetExpansion.entitiesMentionsUsername,
        // TweetExpansion.geoPlaceId,
        // TweetExpansion.referencedTweetsId,
        // TweetExpansion.referencedTweetsIdAuthorId
      ],
      tweetFields: [
        TweetField.attachments,
        TweetField.authorId,
        TweetField.contextAnnotations,
        TweetField.conversationId,
        TweetField.createdAt,
        // TweetField.geo,
        TweetField.inReplyToUserId,
        TweetField.lang,
        // TweetField.privateMetrics,
        // TweetField.organicMetrics,
        // TweetField.promotedMetrics,
        TweetField.publicMetrics,
        // TweetField.possiblySensitive,
        TweetField.referencedTweets,
        TweetField.replySettings,
        TweetField.source,
        TweetField.text,
        // TweetField.editControls,
        TweetField.withheld,
      ],
      userFields: [
        // UserField.description,
        UserField.name,
        UserField.username,
        // UserField.url,
        UserField.profileImageUrl,
        // UserField.location,
        UserField.pinnedTweetId,
        UserField.protected,
        UserField.verified,
        // UserField.publicMetrics,
        // UserField.entities,
        // UserField.createdAt,
        // UserField.withheld,
      ],
    ).then((res) => {
          setState(() {
            log(json.encode(res.toJson()));
            tweet = res.data;
            if (res.hasIncludes && res.includes != null) {
              users = res.includes!.users!;
            }
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Thread"),
      ),
      body: Visibility(
        visible: tweet != null,
        replacement:
            Container(child: const Center(child: CircularProgressIndicator())),
        child: tweet != null
            ? TweetDetailCard(tweet: tweet!, users: users, key: widget.key)
            : Container(),
      ),
    );
  }
}

class TweetDetailCard extends StatefulWidget {
  final TweetData tweet;
  final List<UserData> users;

  const TweetDetailCard({required this.tweet, required this.users, super.key});

  @override
  State<TweetDetailCard> createState() => _TweetDetailCardState();
}

class _TweetDetailCardState extends State<TweetDetailCard> {
  @override
  Widget build(BuildContext context) {
    final user = widget.users
        .where((element) => element.id == widget.tweet.authorId)
        .first;
    final dateFormatter = DateFormat("hh:mm a - d MMM yy");
    return ListView(
      children: [
        Container(
          child: ListTile(
            leading: user.profileImageUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(user.profileImageUrl!),
                  )
                : const CircleAvatar(
                    backgroundColor: Colors.grey,
                  ),
            title: user.isVerified!
                ? Row(
                    children: [
                      Text(user.name),
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.verified,
                          color: Color.fromRGBO(29, 162, 239, 1),
                          size: 16,
                        ),
                      ),
                    ],
                  )
                : Text(user.name),
            subtitle: Text("@${user.username}"),
            trailing: IconButton(
                onPressed: () => print("TODO: Menu"),
                icon: const Icon(Icons.keyboard_arrow_down_rounded)),
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.tweet.text),
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 8, bottom: 8),
            child: Row(children: [
              widget.tweet.createdAt != null
                  ? Text(
                      dateFormatter.format(widget.tweet.createdAt!),
                      style: const TextStyle(color: Colors.grey),
                    )
                  : const Text(""),
              const SizedBox(width: 8),
              widget.tweet.source != null
                  ? Text(
                      widget.tweet.source!,
                      style: const TextStyle(color: Colors.blue),
                    )
                  : const Text("")
            ]),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Divider(),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 8, bottom: 8),
            child: Row(children: [
              const SizedBox(width: 8),
              Text(widget.tweet.publicMetrics?.replyCount.toString() ?? "0",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 8),
              const Text("comments", style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 8),
              Text(widget.tweet.publicMetrics?.likeCount.toString() ?? "0",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 8),
              const Text("Likes", style: TextStyle(color: Colors.grey)),
            ]),
          ),
        ),
        const Padding(
          padding:
              const EdgeInsets.only(left: 16.0, right: 16.0, top: 8, bottom: 8),
          child: Divider(),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const FaIcon(FontAwesomeIcons.comment, size: 15),
              const FaIcon(FontAwesomeIcons.retweet, size: 15),
              const FaIcon(FontAwesomeIcons.heart, size: 15),
              const FaIcon(FontAwesomeIcons.shareNodes, size: 15),
            ],
          ),
        )
      ],
    );
  }
}
