import 'package:flutter/material.dart';
import 'article_page.dart';
import 'challenges_page.dart';

class DailyActivitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Container(
        color: Colors.grey[850],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lime.shade400,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticlePage(),
                    ),
                  );
                },
                child: Text('Go to Articles'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lime.shade400,
                  ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChallengesPage(),
                    ),
                  );
                },
                child: Text('Go to Challenges'),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
