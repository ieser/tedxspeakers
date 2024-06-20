import 'package:flutter/material.dart';
import 'package:tedxspeakers/styles/dimens.dart';
import 'package:tedxspeakers/models/lesson.dart';
import 'package:tedxspeakers/repository/lesson_repository.dart';

class SingleLessonPage extends StatelessWidget {
  SingleLessonPage({super.key, required this.idLesson});

  final int idLesson;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start a new lesson"),
      ),
      body: FutureBuilder<Lesson>(
        future: LessonsRepository().getLesson(idLesson),
        builder: (_, AsyncSnapshot<Lesson> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final lesson = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0), 
                child : Column(
                  children: [
                    
                    Text(
                      '${lesson.title}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...lesson.capthers.map((capther) {
                      return ListTile(
                        title: Text(capther.title,
                            style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )
                        ),
                        subtitle: Text(capther.paragraph),
                      );
                    }).toList(),
                  ],
                ),
              )
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}