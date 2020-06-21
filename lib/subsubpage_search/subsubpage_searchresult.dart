//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:sowhathappened/style/style_standard.dart';
//
//class SearchResult extends StatelessWidget {
//
//  final QuerySnapshot snapshot;
//  SearchResult({this.snapshot});
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('검색 결과', style: titleStyle(),),
//        centerTitle: true,
//      ),
//      body: _buildBody(),
//    );
//  }
//
//  Widget _buildBody() {
//    return Center(
//      child: Text(snapshot.documents[1].toString()),
//    );
//  }
//}
