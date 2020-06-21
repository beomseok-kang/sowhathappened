import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sowhathappened/UI/list_tile.dart';
import 'package:sowhathappened/loading.dart';
import 'package:sowhathappened/models/user.dart';
import 'package:sowhathappened/style/style_standard.dart';
import 'package:sowhathappened/subsubpage_write/subsubpage_newrelay.dart';

class RelayJoin extends StatefulWidget {
  final String type;

  RelayJoin({@required this.type});

  @override
  _RelayJoinState createState() => _RelayJoinState(type);
}

class _RelayJoinState extends State<RelayJoin> {
  String type;

  _RelayJoinState(this.type);

  QuerySnapshot qs;

  @override
  void initState() {
    Firestore.instance
        .collection(type)
        .where('릴레이종료', isEqualTo: false)
        .orderBy("날짜시간", descending: true)
        .limit(10)
        .getDocuments()
        .then((snapshots) {
      setState(() {
        qs = snapshots;
      });
    });
    super.initState();
  }

  Future<void> refreshList() async {
    initState();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor(),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: appBarColor(),
        title:
            Text(type == 'short' ? '짧은 글 릴레이' : '긴 글 릴레이', style: titleStyle()),
      ),
      body: qs != null
          ? _buildBody()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Loading(),
              ],
            ),
    );
  }

  Widget _buildBody() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width - 24,
              decoration: BoxDecoration(
                color: colorOnSelection(),
                borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 13),
                        blurRadius: 31,
                        color: shadowColor()
                    )
                  ]
              ),
              child: FlatButton(
                child: Text(
                  type == 'short' ? '새 짧은 글 릴레이' : '새 긴 글 릴레이',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewRelay(
                              type: type,
                            )),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(type == 'short' ? '최신 짧은 글 릴레이' : '최신 긴 글 릴레이',
                style: headingStyle()),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: SizedBox(
                width: double.maxFinite,
                child: RefreshIndicator(
                  onRefresh: refreshList,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 12),
                    scrollDirection: Axis.vertical,
                    itemCount: qs.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = Provider.of<User>(context);
                      return ListViewTile(
                          context: context,
                          index: index,
                          uid: user.uid,
                          qs: qs);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
