import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sowhathappened/Authenticate/login.dart';
import 'package:sowhathappened/models/user.dart';
import 'package:sowhathappened/services/queries.dart';
import 'package:sowhathappened/style/style_standard.dart';
import 'package:sowhathappened/subpage/subpage_account.dart';
import 'package:sowhathappened/subpage/subpage_home.dart';
import 'package:sowhathappened/subpage/subpage_read.dart';
import 'package:sowhathappened/subpage/subpage_write.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
 
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final queries = Provider.of<Queries>(context);

    Future<void> refresh() {
      queries.refreshHome();
      return null;
    }

    Widget _homeWithRefresh() {
      return RefreshIndicator(
        onRefresh: refresh,
        child: Home(
          onMount: () => queries.refreshHome
        ),
      );
    }
    Widget _readWithRefresh() {
      return Read(onRefresh: queries.refreshRead);
    }

    List _pages = [_homeWithRefresh(), Write(), _readWithRefresh(), Account()];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: appBarColor(),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            if (index == 3 && user == null) {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => LoginPage()));
            } else {
              _selectedIndex = index;
            }
          });
        },
        elevation: 0,
        currentIndex: _selectedIndex,
        selectedItemColor: colorOnSelection(),
        unselectedItemColor: colorNotSelected(),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 25,
            ),
            title: SizedBox()
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.create,
              size: 25,
            ),
            title: SizedBox()
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bookmark,
              size: 25,
            ),
            title: SizedBox()
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 25,
            ),
            title: SizedBox()
          ),
        ],
      ),
    );
  }

  

}
