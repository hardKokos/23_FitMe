import 'package:flutter/material.dart';
import 'package:fit_me/pages/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userUid() {
    return Text(
      user?.email ?? 'User email',
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lime.shade400,
      ),
      child: const Text(
        'Sign Out',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

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
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        color: Colors.grey[850],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUid(),
            _signOutButton(),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => ArticlePage()),
            //     );
            //   },
            //   child: const Text('Go to Article Page'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => ChallengesPage()),
            //     );
            //   },
            //   child: const Text('Go to Challenges Page'),
            // ),
          ],
        ),
      ),
    );
  }
}
