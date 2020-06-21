import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sowhathappened/alert_login.dart';
import 'package:sowhathappened/models/user.dart';
import 'package:sowhathappened/style/style_standard.dart';
import 'package:sowhathappened/subsubpage_read/subsubpage_readpost.dart';
import 'package:sowhathappened/subsubpage_write/subsubpage_relays.dart';

class RankList extends StatelessWidget {
  final QuerySnapshot qs;
  final String qsType;
  final Widget title;

  RankList({@required this.qs, @required this.qsType, @required this.title});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Column(
      children: <Widget>[
        Row(
          children: [
            SizedBox(width: 30,),
            title,
            Spacer(),
            SizedBox(
              width: 100,
              height: 22,
              child: InkWell(
                onTap: () {
                  if (user == null) {
                    showLoginAlertDialog(context);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RelayJoin(
                                type: qsType,
                              )),
                    );
                  }
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    '전체 보기',
                    style: TextStyle(fontSize: 12, color: Colors.black38),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
              padding: EdgeInsets.fromLTRB(18, 0, 30, 20),
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: qs.documents.length,
              itemBuilder: (BuildContext context, int index) {
                final user = Provider.of<User>(context);
                return Container(
                  margin: EdgeInsets.fromLTRB(12, 5, 0, 30),
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 13),
                          blurRadius: 31,
                          color: shadowColor())
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReadPost(
                                  qs.documents[index].data['포스트인덱스'],
                                  qsType,
                                  user != null ? user.uid : 'Null')));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(223, 239, 255, 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                    color: colorOnSelection(), fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 4.0, 10, 4),
                            height: 78,
                            child: Text(
                              qs.documents[index].data['글'][0],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              softWrap: true,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 5, 5, 25),
                            child: Text(
                              '주제: ' +
                                  cutBracket(qs.documents[index].data['주제']
                                      .toString()),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 7,
                            ),
                            Icon(
                              Icons.favorite,
                              color: colorForLike(),
                              size: 15,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              '${qs.documents[index].data['좋아요 수']}',
                              style: TextStyle(fontSize: 12),
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
