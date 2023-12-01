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
      color: Colors.grey[850], // Kolor szary dla tła kontenera
      child: StreamBuilder(
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

              return Card(
                color:  Colors.grey[700],
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
                    onPressed: isCompleted ? null : () => completeChallenge(challengesData[index].id),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lime.shade400, // Background color
                      ),
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
