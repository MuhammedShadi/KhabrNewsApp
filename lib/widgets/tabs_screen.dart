import 'package:flutter/material.dart';
import 'package:khbr_app/model/category_item.dart';
import 'package:khbr_app/screens/choices_categories.dart';
import 'package:khbr_app/screens/index.dart';
import 'package:khbr_app/screens/subscribed_categories.dart';

CateItems cateItems;

class TabsScreen extends StatefulWidget {
  static const routName = "/Tabs";

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    _pages = [
      {
        'page': IndexScreen(),
        'title': 'الرئيسية',
      },
      {
        'page': ChoicesCategories(),
        'title': 'التصنيفات',
      },
      {
        'page': SubscribedCategoriesScreen(),
        'title': 'المفضلة',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.red,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.category),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
          ),
        ],
        onTap: _selectPage,
      ),
    );
  }
}
