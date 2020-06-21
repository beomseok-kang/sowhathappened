//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//
//class RelayBoard extends StatefulWidget {
//
//  String type;
//  RelayBoard({@required this.type})
//
//  @override
//  _RelayBoardState createState() => _RelayBoardState();
//}
//
//class _RelayBoardState extends State<RelayBoard> {
//
//  QuerySnapshot qs;
//
//  @override
//  void initState() async{
//    await Firestore.instance.collection(widget.type).orderBy("날짜시간", descending: true).limit(10).getDocuments().then((snapshot) {
//      setState(() {
//        qs=snapshot;
//      });
//    });
//    super.initState();
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('긴 글'),
//        centerTitle: true,
//        backgroundColor: Colors.white,
//      ),
//      body: _buildBody(),
//    );
//  }
//
//  Widget _buildBody() {
//    return
//  }
//}
