import 'package:flutter/material.dart';
import 'package:sowhathappened/style/style_standard.dart';

class Read extends StatefulWidget {
  @override
  _ReadState createState() => _ReadState();
}

class _ReadState extends State<Read> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor(),
      body: _buildBody(),
    );
  }
  
  Widget _buildBody() {
    return Center(
      child: Text('준비중'),
    );
  }
}
