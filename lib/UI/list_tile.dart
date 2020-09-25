import 'package:flutter/material.dart';
import 'package:sowhathappened/style/style_standard.dart';
import 'package:sowhathappened/subsubpage_read/subsubpage_readpost.dart';

class ListViewTileProps {
  final String postIndex;
  final String type;
  final List<dynamic> topics;
  final List<dynamic> texts;
  final dynamic text;

  ListViewTileProps({
    @required this.postIndex,
    @required this.type,
    @required this.topics,
    @required this.texts,
    @required this.text
  });
}

class ListViewTile extends StatelessWidget {

  final BuildContext context;
  final int index;
  final String uid;
  final ListViewTileProps props;
  

  ListViewTile({@required this.context,@required this.index,@required this.uid,@required this.props});


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
              props.postIndex,
              props.type,
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
                  Text(
                    props.texts.length > 0 ? props.texts[0] : props.text,
                    overflow: TextOverflow.ellipsis, maxLines: 1,
                  ),
                  Text('주제: '+ cutBracket(props.topics.toString()),
                    overflow: TextOverflow.ellipsis, maxLines: 1,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: wStandard * 0.1,
              child: Center(
                  child: Text(
                       props.texts.length > 0
                       ? '${props.texts.length}/10'
                       : props.type,
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
