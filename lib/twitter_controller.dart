import 'package:dartz/dartz.dart';
import 'package:flutter_twitter_api/twitter_repository.dart';
import 'package:hooks_riverpod/all.dart';

final twitterControllerProvider = StateNotifierProvider<TwitterController>((ref) {
  final twitterRepository = ref.watch(twitterRepositoryProvider);

  return TwitterController(twitterRepository);
});

class TwitterController extends StateNotifier<AsyncValue<String>> {
  TwitterController(
    this._twitterRepository, [
    AsyncValue<String> state,
  ]) : super(state ?? AsyncValue.data(''));
  final TwitterRepository _twitterRepository;

  Future<Either<Failure, String>> postTweet(String tweetMessage) async {
    state = AsyncValue.loading();
    final result = await _twitterRepository.post(tweetMessage);

    result.fold(
      (failure) => state = AsyncValue.error(failure),
      (message) => state = AsyncValue.data(message),
    );

    return result;
  }
}
