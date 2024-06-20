import 'package:flutter/material.dart';
import 'package:tedxspeakers/styles/dimens.dart';
import 'package:tedxspeakers/models/talk.dart';
import 'package:tedxspeakers/pages/talks/single.dart';

class TalkCard extends StatelessWidget {
  const TalkCard({super.key, required this.thisTalk});

  final Talk thisTalk;


  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleTalkPage(
            slug: thisTalk.slug
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Dimens.tinyMargin,
          vertical: Dimens.tinyMargin,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff7c94b6),
          image: DecorationImage(
            image: NetworkImage( thisTalk.image ), 
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
            fit: BoxFit.cover
          ),
        ),
        child: Center(
          child: Text( thisTalk.title, 
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        ),

        
      ),
    );
  }
}
