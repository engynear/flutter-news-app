import 'package:flutter/material.dart';
import '../models/news.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class NewsDetailPage extends StatelessWidget {
  final News news;

  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final DateTime publishedDate = DateTime.parse(news.publishedAt);
    final String formattedDate = DateFormat('HH:mm | yyyy-MM-dd').format(publishedDate);

    final String cleanContent = news.content.replaceAll(RegExp(r'\[\+\d+\schars\]'), '');

    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  news.description,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            if (news.urlToImage.isNotEmpty)
              Image.network(news.urlToImage),
            if (news.content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  cleanContent,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => _launchURL(news.url),
                child: Text(
                news.url,
                style: TextStyle(color: Theme.of(context).colorScheme.secondary, decoration: TextDecoration.underline),
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                formattedDate,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
