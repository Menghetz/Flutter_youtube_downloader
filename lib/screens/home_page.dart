import 'package:flutter/material.dart';
import 'package:youtube_downloader/screens/browser_page.dart';
import 'package:youtube_downloader/screens/paste_link_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Youtube downloader'),
        elevation: 0,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: items,
        selectedItemColor: Colors.red,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }

  List<Widget> pages = [
    PasteLinkPage(),
    BrowserPage()
  ];
  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.paste), label: 'Paste link'),
    BottomNavigationBarItem(icon: Icon(Icons.network_cell), label: 'Browser'),
  ];
}