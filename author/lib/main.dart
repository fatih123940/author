import 'package:author/view/books_page.dart';
import 'package:flutter/material.dart';

void main () {
  runApp(AuthorApp());
}

class AuthorApp extends StatelessWidget {
  const AuthorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BooksPage(),
    );
  }
}
