import 'package:flutter/material.dart';
import 'package:football_news/screens/newslist_form.dart';

class NewsItem extends StatelessWidget {
  final String name;
  final IconData icon;
  const NewsItem({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // SnackBar
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text("Kamu telah menekan tombol $name!")),
          );

        // Navigasi
        if (name == "Tambah Berita") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewsFormPage()),
          );
        }
      },
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Icon(icon),
          title: Text(name),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
