import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tedxspeakers/models/tabs.dart';
import 'package:tedxspeakers/pages/home/lessons.dart';
import 'package:tedxspeakers/pages/home/explore.dart';
//import 'package:tedxspeakers/pages/home/explore.dart';

final indexTabProvider = StateProvider<int>((ref) => 0);

final List<HomeTab> tabList = [
  HomeTab(
    label: "Lessons",
    icon: Icons.book,
    content: const LessonsTab(),
  ),
  HomeTab(
    label: "Explore",
    icon: Icons.explore,
    content: const ExploreTab(),
  ),
];

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: tabList[ref.watch(indexTabProvider)].content,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          ref.read(indexTabProvider.notifier).state = index;
        },
        selectedIndex: ref.watch(indexTabProvider),
        destinations: tabList
            .map(
              (singleScreenTab) => NavigationDestination(
                icon: Icon(singleScreenTab.icon),
                label: singleScreenTab.label,
              ),
            )
            .toList(),
      ),
    );
  }
}