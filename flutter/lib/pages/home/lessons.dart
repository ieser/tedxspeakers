import 'package:flutter/material.dart';
import 'package:tedxspeakers/pages/lessons/card.dart';
import 'package:tedxspeakers/repository/lesson_repository.dart';
import 'package:tedxspeakers/models/lesson.dart';

class LessonsTab extends StatelessWidget {
  const LessonsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lesson>?>(
      future: LessonsRepository().getAllLessons(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return  Center(
              child: Text( snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return LessonCard(
                  thisLesson: snapshot.data![index]
                );
              },
            );
          } else {
            return const Center(
              child: Text( 'Errore nel recupero delle lezioni'),
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