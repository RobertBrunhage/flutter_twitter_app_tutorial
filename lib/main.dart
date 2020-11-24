import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'twitter_controller.dart';
import 'twitter_repository.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            color: const Color(0xffE9EFFD),
            padding: const EdgeInsets.only(top: kToolbarHeight),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Calm tweeter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(top: kToolbarHeight * 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(42),
                topRight: Radius.circular(42),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Spacer(),
                TweetResponse(),
                Spacer(),
                CustomInputField(
                  onPressed: () => postTweet(context, textEditingController),
                  textEditingController: textEditingController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void postTweet(BuildContext context, TextEditingController tweetTextEditingController) async {
    if (tweetTextEditingController.text.isEmpty) return;

    final result = await context.read(twitterControllerProvider).postTweet(tweetTextEditingController.text);
    if (result.isRight()) {
      tweetTextEditingController.clear();
    }
  }
}

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    Key key,
    @required this.textEditingController,
    @required this.onPressed,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 4,
      maxLength: 280,
      maxLengthEnforced: true,
      decoration: InputDecoration(
        hintText: 'How are you all doing?',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: ClipOval(
          child: Material(
            color: Colors.white.withOpacity(0.0),
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(Icons.send),
            ),
          ),
        ),
        filled: true,
        fillColor: const Color(0xffF6F8FD),
      ),
    );
  }
}

class TweetResponse extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final tweetControllerState = useProvider(twitterControllerProvider.state);
    final theme = Theme.of(context).textTheme.headline6.copyWith(color: const Color(0xff2F3A5D));
    return tweetControllerState.when(
      data: (data) => Text(data.isEmpty ? 'Write a tweet 😊' : 'Tweet: $data', style: theme),
      loading: () => CircularProgressIndicator(),
      error: (err, sr) {
        if (err is Failure) {
          return Text(err.message, style: theme);
        }
        return Text('An unexpected error occurred 😢', style: theme);
      },
    );
  }
}
