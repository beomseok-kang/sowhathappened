import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sowhathappened/home_page.dart';
import 'package:sowhathappened/loading.dart';
import 'package:sowhathappened/models/feeling.dart';
import 'package:sowhathappened/models/user.dart';
import 'package:sowhathappened/services/auth.dart';
import 'package:sowhathappened/services/database.dart';
import 'package:sowhathappened/style/style_standard.dart';
import 'package:sowhathappened/UI/list_tile.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  int _selectedIndex = 0;

  final AuthService _auth = AuthService();
  PageController _pageController = PageController(initialPage: 0);

  _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Container();
    } else {
      return StreamBuilder<FeelingData>(
        stream: DatabaseService(uid: user.uid).feelingData,
        builder: (BuildContext context, AsyncSnapshot fSnapshot) {
          FeelingData feelingData = fSnapshot.data;

          return StreamBuilder<UserData>(
              stream: DatabaseService(uid: user.uid).userData,
              builder: (BuildContext context, AsyncSnapshot uSnapshot) {
                UserData userData = uSnapshot.data;

                if (uSnapshot.data == null || fSnapshot.data == null) {
                  return Scaffold(
                      body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Loading(),
                    ],
                  ));
                } else {
                  return Scaffold(
                    backgroundColor: bgColor(),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                          Text(userData.nickname),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              showLogoutAlertDialog(context);
                            },
                            child: Container(
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: colorOnSelection(),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 13),
                                          blurRadius: 31,
                                          color: shadowColor())
                                    ]),
                                child: Center(
                                    child: Text(
                                  '로그아웃',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: FlatButton(
                                  child: Text(
                                    '내가 쓴 글',
                                    style: selectionStyle(_selectedIndex, 0),
                                  ),
                                  onPressed: () {
                                    _pageController.animateToPage(0,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.fastOutSlowIn);
                                  },
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: FlatButton(
                                  child: Text(
                                    '좋아요를 누른 글',
                                    style: selectionStyle(_selectedIndex, 1),
                                  ),
                                  onPressed: () {
                                    _pageController.animateToPage(1,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.fastOutSlowIn);
                                  },
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: _onPageChanged,
                              scrollDirection: Axis.horizontal,
                              physics: PageScrollPhysics(),
                              children: <Widget>[
                                SizedBox(
                                  child: userData.written.length > 0
                                      ? ListView.builder(
                                          padding: EdgeInsets.only(bottom: 12),
                                          physics: BouncingScrollPhysics(),
                                          itemCount: userData.written.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            final props = ListViewTileProps(
                                              postIndex: userData.written[index].keys.first,
                                              texts: [],
                                              text: userData.written[index].values.first[1]['글'],
                                              topics: userData.written[index].values.first[0]['주제'],
                                              type: userData.written[index].values.first[2]['타입']
                                            );
                                            return ListViewTile(
                                              context: context,
                                              index: index,
                                              uid: user.uid,
                                              props: props,
                                            );
                                          })
                                          : Text('아직 쓴 글이 없습니다.'),
                                ),
                                SizedBox(
                                  child: feelingData.writing.length > 0
                                      ? ListView.builder(
                                          padding: EdgeInsets.only(bottom: 12),
                                          physics: BouncingScrollPhysics(),
                                          itemCount: feelingData.writing.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            final postIndex = feelingData.postIndex[index];
                                            final props = ListViewTileProps(
                                              postIndex: postIndex,
                                              texts: [],
                                              text: feelingData.writing[index],
                                              topics: feelingData.topics[index][postIndex],
                                              type: feelingData.type[index][postIndex]
                                            );
                                            return ListViewTile(
                                              context: context,
                                              index: index,
                                              uid: user.uid,
                                              props: props,
                                            );
                                          })
                                      : Text('좋아요를 누른 글이 없습니다.'),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              });
        },
      );
    }
  }

  showLogoutAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text('로그아웃'),
      content: Text(
        '로그아웃 하시겠습니까?',
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            '아니오',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(
            '예',
            style: TextStyle(color: Colors.blue),
          ),
          onPressed: () async {
            await _auth.signOut();
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        )
      ],
      elevation: 4.0,
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
