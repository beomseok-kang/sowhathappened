//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//
//class CommentPage extends StatefulWidget {
//
//  final QuerySnapshot qs;
//  CommentPage(this.qs);
//
//  @override
//  _CommentPageState createState() => _CommentPageState(qs);
//}
//
//class _CommentPageState extends State<CommentPage> {
//
//  TextEditingController textFieldController = TextEditingController();
//
//  String text = '';
//  QuerySnapshot qs;
//  _CommentPageState(this.qs);
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('댓글'),
//        centerTitle: true,
//      ),
//      body: Stack(
//        children: <Widget>[
//          Expanded(
//            child: _buildBody(),
//          ),
//          Positioned(
//            bottom: 0,
//            left: 0,
//            right: 0,
//            child: Container(
//              height: MediaQuery.of(context).size.height*0.08,
//              color: Colors.white,
//              child: Row(
//                children: <Widget>[
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.1,
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(4.0),
//                    child: Container(
//                      width: MediaQuery.of(context).size.width * 0.6,
//                      child: TextField(
//                        controller: textFieldController,
//                        decoration: InputDecoration(
//                            border: InputBorder.none
//                        ),
//                        onChanged: (val) {
//                          setState(() {
//                            text = val;
//                          });
//                        },
//                      ),
//                    ),
//                  ),
//                  SizedBox(width: 4,),
//                  Icon(Icons.tag_faces, color: Colors.grey, size: 30,),
//                  SizedBox(width: 8,),
//                  Expanded(
//                    child: Container(
//                      height: MediaQuery.of(context).size.height*0.08,
//                      child: FlatButton(
//                        child: Icon(Icons.send, size: 25, color: Color.fromRGBO(60, 30, 30, 1),),
//                        onPressed: text == '' ? null : () {
//                          setState(() {
//                            textFieldController.clear();
//                            text = '';
//                          });
//                        },
//                      ),
//                    ),
//                  )
//                ],
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  Widget _buildBody() {
//    if(qs == null) {
//      return Center(
//        child: Text('댓글이 없습니다.'),
//      );
//    }
//
//    return SizedBox(
//      child: ListView.builder(
//
//      ),
//    );
//  }
//
//}
