import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ChallengesPage extends StatelessWidget {
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 1));

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(

      body: Container(
        color: Colors.grey[850],
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Challenges')
              .where('uid', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            var challengesData = snapshot.data!.docs;
            return ListView.builder(
              itemCount: challengesData.length,
              itemBuilder: (context, index) {
                var title = challengesData[index]['title'];
                var text = challengesData[index]['text'];
                var isCompleted = challengesData[index]['isCompleted'] ?? false;

                return Card(
                  color: Colors.grey[700],
                  child: ListTile(
                    title: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      text,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: ElevatedButton(
                      onPressed: isCompleted
                          ? null
                          : () => completeChallenge(challengesData[index].id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lime.shade400,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(isCompleted
                              ? 'Challenge completed'
                              : 'Complete challenge'),
                          ConfettiWidget(
                            confettiController: _confettiController,
                            blastDirectionality:
                                BlastDirectionality.explosive,
                            shouldLoop: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void completeChallenge(String documentId) async {
    await FirebaseFirestore.instance.collection('Challenges').doc(documentId).update({
      'isCompleted': true,
    });
    _confettiController.play();
  }
}
