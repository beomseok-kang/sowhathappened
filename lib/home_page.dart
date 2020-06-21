import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sowhathappened/Authenticate/login.dart';
import 'package:sowhathappened/models/user.dart';
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
  QuerySnapshot qsShort;
  QuerySnapshot qsLong;
  List<DocumentSnapshot> qsShortHot;
  List<DocumentSnapshot> qsLongHot;

  int _selectedIndex = 0;

  List _pages = [Read(), Write(), Read(), Account()];

  @override
  void initState() {
    Firestore.instance
        .collection('short')
        .orderBy("좋아요 수", descending: true)
        .limit(10)
        .getDocuments()
        .then((snapshot) {
      setState(() {
        qsShort = snapshot;
      });
    });
    Firestore.instance
        .collection('long')
        .orderBy("좋아요 수", descending: true)
        .limit(10)
        .getDocuments()
        .then((snapshot) {
      setState(() {
        qsLong = snapshot;
      });
    });
    Firestore.instance
        .collection('short')
        .where("날짜시간",
        isGreaterThanOrEqualTo:
        DateTime.now().subtract(Duration(days: 7)).toString())/////////////////////////////고쳐야하ㅁ//////////////////////////////
        .orderBy("날짜시간", descending: false)
        .orderBy("좋아요 수", descending: true)
        .getDocuments()
        .then((snapshot) {
      setState(() {
        List<DocumentSnapshot> snapshotList = snapshot.documents;

        for (int i=0; i<snapshotList.length; i++) {
          snapshotList.sort((b,a) => a.data['좋아요 수'].compareTo(b.data['좋아요 수']));
        }

        qsShortHot = snapshotList;
      });
    });
    Firestore.instance
        .collection('long')
        .where("날짜시간",
        isGreaterThanOrEqualTo:
        DateTime.now().subtract(Duration(days: 7)).toString())//////////////////////////고쳐야함///////////////////////////////////////
        .orderBy("날짜시간", descending: false)
        .orderBy("좋아요 수", descending: true)
        .getDocuments()
        .then((snapshot) {
      setState(() {
        List<DocumentSnapshot> snapshotList = snapshot.documents;

        for (int i=0; i<snapshotList.length; i++) {
          snapshotList.sort((b,a) => a.data['좋아요 수'].compareTo(b.data['좋아요 수']));
        }

        qsLongHot = snapshotList;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      body: _selectedIndex == 0
          ? RefreshIndicator(
              onRefresh: _onRefresh,
              child: Home(
                qsShortHot: qsShortHot,
                qsLongHot: qsLongHot,
                qsLong: qsLong,
                qsShort: qsShort,
              ),
            )
          : _pages[_selectedIndex],
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

  Future<void> _onRefresh() async {
    await initState();
    return null;
  }
}
