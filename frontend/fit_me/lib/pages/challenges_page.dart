import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//OPAKUJ ELEMENTY LISTY W WIDGET CARD TAK SAMO ARTICLE PAGE

class ChallengesPage extends StatelessWidget {
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available challenges'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Challenges').snapshots(),
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

              return ListTile(
                  title: Text(title),
                  subtitle: Text(text),
                  trailing: ElevatedButton(
                    onPressed: isCompleted ? null : () => completeChallenge(challengesData[index].id),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(isCompleted ? 'Challenge completed' : 'Complete challenge'),
                      ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                      ),
                    ],
                  ),
                    
                  ),
              );
            },
          );
        },
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
