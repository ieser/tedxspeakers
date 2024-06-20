import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/lesson.dart';

Future<List<Lesson>> initEmptyList() async {

  Iterable list = json.decode("[]");
  var lessons = list.map((model) => Lesson.fromJSON(model)).toList();
  return lessons;

}


class LessonsRepository {
  LessonsRepository();

  Future<List<Lesson>> getAllLessons() async {
    var url = Uri.parse('https://d3sdsphmgd.execute-api.us-east-1.amazonaws.com/default/getAllLessons');

    final http.Response response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Object>{
        'doc_per_page': 20
      }),
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      
      var lessons = list.map((model) => Lesson.fromJSON(model)).toList();
      return lessons;
    } else {
      throw Exception('Failed to load lessons');
    }
        
  }


  Future<Lesson> getLesson(int id) async {

    var url = Uri.parse('https://bkjcyoiikh.execute-api.us-east-1.amazonaws.com/default/getLesson');

    final http.Response response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Object>{
        'lesson_id': id
      }),
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      var lessons = list.map((model) => Lesson.fromJSON(model)).toList();
      return lessons[0];
    } else {
      throw Exception('Failed to load lessons');
    }
        
  }
}