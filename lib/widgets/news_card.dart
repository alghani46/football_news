import 'package:flutter/material.dart';
import 'package:football_news/screens/newslist_form.dart';
import 'package:football_news/screens/news_entry_list.dart';
import 'package:football_news/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

// Pick ONE baseUrl that matches where your Django runs:
//   - Web/desktop: 'http://localhost:8000'
//   - Android emulator: 'http://10.0.2.2:8000'
//   - Physical device (same Wi-Fi): 'http://<YOUR_PC_LAN_IP>:8000'
const String baseUrl = 'http://localhost:8000';

class NewsItem extends StatelessWidget {
  final String name;
  final IconData icon;
  const NewsItem({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    // 1) Add CookieRequest via Provider
    final request = context.watch<CookieRequest>();

    return InkWell(
      // 2) Make onTap async so we can await logout()
      onTap: () async {
        // Navigation / actions
        if (name == "Add News" || name == "Tambah Berita") {
          // Show SnackBar for Add News
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("You pressed the $name button!")),
            );
          // Go to form
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewsFormPage()),
          );
        } else if (name == "See Football News") {
          // Show SnackBar for See Football News
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("You pressed the $name button!")),
            );
          // Go to list page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewsEntryListPage()),
          );
        } else if (name == "Logout") {
          // Handle logout WITHOUT showing the generic notification
          try {
            final response = await request.logout(
                "$baseUrl/auth/logout/");
            print('Logout response: $response');
            
            if (context.mounted) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Logged out successfully!"),
                ),
              );
              
              // Navigate back to login page and clear the stack
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false, // Remove all routes
              );
            }
          } catch (e) {
            print('Logout error: $e');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error logging out: $e"),
                ),
              );
            }
          }
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
