import 'package:flutter/material.dart';
import 'package:tedxspeakers/styles/dimens.dart';
import 'package:tedxspeakers/models/lesson.dart';
import 'package:tedxspeakers/pages/lessons/single.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({super.key, required this.thisLesson});

  final Lesson thisLesson;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleLessonPage(
            idLesson: thisLesson.id
          ),
        ),
      ),
      child:  Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical:4,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 44, 44, 44),
          border: Border.all(
            width: Dimens.smallBorderSideWidth,
            color: const Color.fromARGB(255, 63, 63, 63),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(Dimens.smallRoundedCorner),
          ),
        ),
        child: Row(
          children:[
            Expanded(
              child: Text(
                "#${thisLesson.id}: ${thisLesson.title}",
                textAlign: TextAlign.left,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ]
        ),
      ),
    );
  }
}