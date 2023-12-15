import 'package:flutter/material.dart';
import 'article_page.dart';
import 'challenges_page.dart';

class DailyActivitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Fit Me',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.lime.shade400,
          centerTitle: true,
          elevation: 0.0,
          bottom: const TabBar(
            
            indicatorColor: Colors.grey,
            tabs: [
              Tab(
                  child: Text(
                  'Articles',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                  child: Text(
                  'Challenges',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ArticlePage(),
            ChallengesPage(),
          ],
        ),
      ),
    );
  }
}
