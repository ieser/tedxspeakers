import 'package:flutter/material.dart';
import 'package:tedxspeakers/styles/dimens.dart';
import 'package:tedxspeakers/models/talk.dart';
import 'package:tedxspeakers/repository/talk_repository.dart';

class SingleTalkPage extends StatelessWidget {
  SingleTalkPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("See this Ted Talk"),
      ),
      body: FutureBuilder<Talk>(
        future: TalksRepository().getTalk(slug),
        builder: (_, AsyncSnapshot<Talk> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Talk myTalk = snapshot.data!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(Dimens.mainPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start
                  
                ),
              );
            } else {
              return const Center(
                child: Text("Errore"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}