import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sowhathappened/UI/rank_list.dart';
import 'package:sowhathappened/UI/rank_list_doclist.dart';
import 'package:sowhathappened/loading.dart';
import 'package:sowhathappened/services/queries.dart';
import 'package:sowhathappened/style/style_standard.dart';
import 'package:sowhathappened/subsubpage_search/subsubpage_search.dart';

class Home extends StatefulWidget {
  void Function() onMount;

  Home({
    @required this.onMount,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    widget.onMount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final queries = Provider.of<Queries>(context);
    bool _hasData () {
      return queries.qsShort != null
        && queries.qsLong != null
        && queries.qsShortHot != null
        && queries.qsLongHot != null;
    }

    return Scaffold(
      backgroundColor: bgColor(),
      body: _hasData()
          ? _buildBody(queries)
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Loading(),
        ],
      ),
    );
  }

  Widget _buildBody(Queries queries) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 40,),
          Padding(
            padding: EdgeInsets.fromLTRB(20,0,0,10),
            child: Text('추천 글', style: bigHeaderStyle()),
          ),
          searchBar(context),
          SizedBox(height: 10,),
          RankDocList(
            docList: queries.qsShortHot,
            qsType: 'short',
            title: Text('핫한 짧은 글',
              style: TextStyle(fontSize: 22),
            ),
          ),
          RankDocList(
            docList: queries.qsLongHot,
            qsType: 'long',
            title: Text('핫한 긴 글',
              style: TextStyle(fontSize: 22),
            ),
          ),
          RankList(
            qsType: 'short',
            qs: queries.qsShort,
            title: Text('짧은 글 랭킹',
              style: TextStyle(fontSize: 22),
            ),
          ),
          RankList(
            qs: queries.qsLong,
            qsType: 'long',
            title: Text('긴 글 랭킹',
              style: TextStyle(fontSize: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBar (context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                offset: Offset(0,13),
                blurRadius: 50,
                color: Color.fromRGBO(196, 194, 222, 0.16)
            )
          ]
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(
              builder: (context) => SearchPage()));
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.search, color: Colors.black26,),
            )
          ],
        ),
      ),
    );
  }
}
