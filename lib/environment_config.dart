import 'package:hooks_riverpod/hooks_riverpod.dart';

class EnvironmentConfig {
  // We add the api key by running 'flutter run --dart-define=apiKey=MYKEY`
  final apiKey = const String.fromEnvironment("apiKey");
  final apiKeySecret = const String.fromEnvironment("apiKeySecret");
  final accessToken = const String.fromEnvironment("accessToken");
  final accessTokenSecret = const String.fromEnvironment("accessTokenSecret");
}

final environmentConfigProvider = Provider<EnvironmentConfig>((ref) {
  return EnvironmentConfig();
});
