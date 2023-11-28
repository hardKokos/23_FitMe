import 'package:fit_me/pages/article_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available articles'),
      ),
      body: StreamBuilder(
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
              var truncatedText = text.length > maxTextLength ? text.substring(0, maxTextLength) + '...' : text;

              return ListTile(
                title: Text(title),
                subtitle: Text(truncatedText),
                tileColor: isRead ? null : Colors.grey[200],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailPage(documentId: documentId ,title: title, text: text),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}