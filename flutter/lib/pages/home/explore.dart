import 'package:flutter/material.dart';
import 'package:tedxspeakers/models/talk.dart';
import 'package:tedxspeakers/repository/talk_repository.dart';
import 'package:tedxspeakers/pages/talks/card.dart';

class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Talk>?>(
      future: TalksRepository().getRandomTalks(20),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return TalkCard(
                  thisTalk: snapshot.data![index]
                );
              },
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
    );
  }
}