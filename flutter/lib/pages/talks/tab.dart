import 'package:flutter/material.dart';
import 'package:tedxspeakers/styles/dimens.dart';
import 'package:tedxspeakers/models/talk.dart';
import 'package:tedxspeakers/pages/talks/single.dart';

class TalkPreview extends StatelessWidget {
  const TalkPreview({super.key, required this.thisTalk, required this.type});

  final Talk thisTalk;
  final String type;

  List<Widget> _insideContainerList(ThemeData thisTheme) {
    return [
      
      const SizedBox(
        width: Dimens.mainSpace,
        height: Dimens.mainSpace,
      ),
      Expanded(
        child: Text(
          thisTalk.title,
          style: thisTheme.textTheme.titleLarge,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData thisTheme = Theme.of(context);

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleTalkPage(
            slug: thisTalk.slug!,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: type == "list" ? Dimens.smallMargin : Dimens.tinyMargin,
          vertical: Dimens.tinyMargin,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.mainPadding,
          vertical: Dimens.smallPadding,
        ),
        child: switch (type) {
          "list" => Row(
              children: _insideContainerList(thisTheme),
            ),
          "grid" => Column(
              children: _insideContainerList(thisTheme),
            ),
          _ => throw UnimplementedError(),
        },
      ),
    );
  }
}