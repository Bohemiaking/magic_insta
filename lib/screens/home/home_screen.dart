import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magic_insta/services/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String copiedText = '';
  List<String> urls = [];

  Future<void> retrieveCopiedText() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      setState(() {
        copiedText = data.text!;
      });
      _fetchImages();
    } else {}
  }

  _fetchImages() async {
    urls.clear();
    ApiService api = ApiService();
    await api
        .post('https://magic-saver.onrender.com/download', {'url': copiedText}).then(
            (respone) {
      if (respone.statusCode == 200) {
        for (var element in respone.data['download_urls']) {
          urls.add(element);
        }
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            ElevatedButton(
                onPressed: retrieveCopiedText, child: Text('Paste link')),
            Text(copiedText),
            for (var element in urls) ...[Image.network(element)]
          ],
        ),
      ),
    );
  }
}
