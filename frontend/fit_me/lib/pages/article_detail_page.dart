import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleDetailPage extends StatefulWidget {
  final String documentId;
  final String title;
  final String text;

  const ArticleDetailPage(
      {super.key,
      required this.documentId,
      required this.title,
      required this.text});

  @override
  // ignore: library_private_types_in_public_api
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late bool isRead;

  @override
  void initState() {
    super.initState();

    isRead =
        false; //jeśli początkowa wartość isRead == true, to najpierw wyświetli się jako isRead == false, a po chwili wygląd zmienia na isRead==true
    FirebaseFirestore.instance
        .collection('Articles')
        .doc(widget.documentId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          isRead = documentSnapshot['isRead'] ?? false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Row(
    children: [
      Flexible(
        child: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      SizedBox(width: 8),
      ElevatedButton(
        onPressed: () {
          toggleReadStatus();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isRead ? Colors.red[400] : Colors.green,
        ),
        child: Text(isRead ? 'Mark as Unread' : 'Mark as Read'),
      ),
    ],
  ),
  backgroundColor: Colors.lime.shade400,
),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleReadStatus() async {
    setState(() {
      isRead = !isRead;
    });

    await FirebaseFirestore.instance
        .collection('Articles')
        .doc(widget.documentId)
        .update({'isRead': isRead});
  }
}
