import 'dart:io';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_twitter_api/environment_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

final twitterApiProvider = Provider<TwitterApi>((ref) {
  final config = ref.watch(environmentConfigProvider);
  print(config.apiKey);
  print(config.apiKeySecret);
  print(config.accessToken);
  print(config.accessTokenSecret);

  final twitterApi = TwitterApi(
    client: TwitterClient(
      consumerKey: config.apiKey,
      consumerSecret: config.apiKeySecret,
      token: config.accessToken,
      secret: config.accessTokenSecret,
    ),
  );

  return twitterApi;
});

final twitterRepositoryProvider = Provider<TwitterRepository>((ref) {
  final twitterApi = ref.watch(twitterApiProvider);

  return TwitterRepository(twitterApi);
});

class TwitterRepository {
  TwitterRepository(this._twitterApi);
  final TwitterApi _twitterApi;

  Future<Either<Failure, String>> post(String status) async {
    try {
      Tweet tweet = await _twitterApi.tweetService.update(status: status);
      return Right(tweet.fullText);
    } on Response catch (response) {
      return Left(Failure(response.reasonPhrase));
    } on SocketException catch (_) {
      return Left(Failure('No internect connection'));
    }
  }
}

class Failure {
  Failure(this.message);

  final String message;
}
