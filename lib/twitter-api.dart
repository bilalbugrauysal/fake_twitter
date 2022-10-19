import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;

const twitterApiKey = "sMqJNRCKTtI6M50vzdbB3OY8i";
const twitterSecret = "OCKxT8s0kP04X5P8hRk4VgKIjFJNMspXX1DJdiwuL4TvZQA3eH";
const twitterAccessKey = "243757617-PKIiDW3mh0AD7pen2FL96x6rub58bAQNCkFLdScR";
const twitterAccessSecret = "I4CA8g4xl6ePzhHgRm2T7tcXKsNZccTIDtwPG4FkQFoX4";
const twitterBearerToken =
    "AAAAAAAAAAAAAAAAAAAAAC4SRQEAAAAAtz%2FsbiWFk8VBDBziG%2BU3tKFglr4%3DBxZwRhvkzHJDmdErQCPBKP7ZGWPAlrTW7YJxqR1sav0Pt0D7wX";

class FakeTwitterApi {
  static final instance = v2.TwitterApi(
    bearerToken: twitterBearerToken,
    oauthTokens: const v2.OAuthTokens(
      consumerKey: twitterApiKey,
      consumerSecret: twitterSecret,
      accessToken: twitterAccessKey,
      accessTokenSecret: twitterAccessSecret,
    ),
    retryConfig: v2.RetryConfig.ofRegularIntervals(
      maxAttempts: 5,
      intervalInSeconds: 3,
    ),
    //! The default timeout is 10 seconds.
    timeout: Duration(seconds: 20),
  );
}
