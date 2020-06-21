import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sowhathappened/style/style_standard.dart';
import 'package:sowhathappened/subsubpage_read/subsubpage_readpost.dart';

class ListViewTile extends StatelessWidget {

  final BuildContext context;
  final int index;
  final String uid;
  final QuerySnapshot qs;

  ListViewTile({@required this.context,@required this.index,@required this.uid,@required this.qs});


  @override
  Widget build(BuildContext context) {

    double wStandard = MediaQuery.of(context).size.width - 16;

    return Container(
      margin: EdgeInsets.fromLTRB(20, 12, 20, 0),
      width: wStandard,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 13),
            blurRadius: 31,
            color: shadowColor()
          )
        ]
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ReadPost(
              qs.documents[index].data['포스트인덱스'],
              qs.documents[index].data['타입'],
              uid
          )
          )
          );
        },
        child: Row(
          children: <Widget>[
            SizedBox(
              width: wStandard * 0.1,
              child: Center(
                child: Text('${index+1}',
                  style: TextStyle(fontSize: wStandard*0.05, fontWeight: FontWeight.bold),
                ),
              )
            ),
            SizedBox(
              width: wStandard * 0.65,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(qs.documents[index].data['글'][0],
                    overflow: TextOverflow.ellipsis, maxLines: 1,
                  ),
                  Text('주제: '+ cutBracket(qs.documents[index].data['주제'].toString()),
                    overflow: TextOverflow.ellipsis, maxLines: 1,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: wStandard * 0.1,
              child: Center(
                  child: Text(
                      '${qs.documents[index].data['글'].length}/10',
                    style: TextStyle(
                      fontSize: wStandard*0.035
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
