import 'package:flutter/material.dart';
import 'package:football_news/models/news_entry.dart';
import 'package:football_news/widgets/left_drawer.dart';
import 'package:football_news/screens/news_detail.dart';
import 'package:football_news/widgets/news_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

// Pick ONE baseUrl for your environment:
const String baseUrl = 'http://localhost:8000';       // Flutter Web / desktop
// const baseUrl = 'http://10.0.2.2:8000';     // Android emulator

class NewsEntryListPage extends StatefulWidget {
  const NewsEntryListPage({super.key});

  @override
  State<NewsEntryListPage> createState() => _NewsEntryListPageState();
}

class _NewsEntryListPageState extends State<NewsEntryListPage> {
  late Future<List<NewsEntry>> _newsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the future only once, when dependencies are available
    if (!mounted) return;
    _newsFuture = _fetchNews();
  }

  Future<List<NewsEntry>> _fetchNews() async {
    try {
      // Read the request from Provider
      final request = context.read<CookieRequest>();
      
      // Use the same baseUrl constant
      final data = await request.get('$baseUrl/json/');
      
      // Debug: Print what we get
      print('API Response received: ${data.runtimeType}');
      
      if (data is! List) {
        throw Exception('Unexpected JSON shape: ${data.runtimeType}');
      }
      
      final items = data.map<NewsEntry>((e) => NewsEntry.fromJson(e as Map<String, dynamic>)).toList();
      print('Successfully parsed ${items.length} news items');
      return items;
    } catch (e) {
      print('Error fetching news: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Entry List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<NewsEntry>>(
        future: _newsFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snap.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Error loading news:',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snap.error.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Debug info:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Base URL: $baseUrl/json/'),
                  ],
                ),
              ),
            );
          }
          
          final items = snap.data ?? const <NewsEntry>[];
          
          if (items.isEmpty) {
            return const Center(
              child: Text('No news available yet.'),
            );
          }
          
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) => NewsEntryCard(
              news: items[i],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailPage(
                      news: items[i],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}