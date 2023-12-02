import 'package:fit_me/pages/article_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fit Me',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Adjusted text color
          ),
        ),
        backgroundColor: Colors.lime.shade400,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.grey[850],
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Articles').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            var articlesData = snapshot.data!.docs;
            return ListView.builder(
              itemCount: articlesData.length,
              itemBuilder: (context, index) {
                var title = articlesData[index]['title'];
                var text = articlesData[index]['text'];
                var isRead = articlesData[index]['isRead'];
                var documentId = articlesData[index].id;
                int maxTextLength = 40;
                var truncatedText = text.length > maxTextLength
                    ? text.substring(0, maxTextLength) + '...'
                    : text;

                return Card(
                  color: isRead ? Colors.grey[700] : Colors.grey[400],
                  child: ListTile(
                    title: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      truncatedText,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailPage(
                              documentId: documentId, title: title, text: text),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
