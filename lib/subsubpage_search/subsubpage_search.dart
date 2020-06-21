import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sowhathappened/models/user.dart';
import 'package:sowhathappened/style/style_standard.dart';
import 'package:sowhathappened/subsubpage_read/subsubpage_readpost.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String text = '';
  final _formKey = GlobalKey<FormState>();
  final textFieldController = TextEditingController();
  String type = 'short';
  DocumentSnapshot ds;

  List<bool> _isSelected = [true, false];
  bool _isShort = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor(),
      appBar: AppBar(
        backgroundColor: appBarColor(),
        title: Text('검색', style: titleStyle(),),
        centerTitle: true,
        elevation: 0,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context) {

    final user = Provider.of<User>(context);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Text('글 인덱스를 통해 검색이 가능합니다.\n복사한 글 인덱스를 붙여넣기 해 주세요.', textAlign: TextAlign.center,),
            SizedBox(height: 50,),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      validator: (val) => text.length < 1 ? '검색할 내용을 입력해 주세요.' : null,
                      controller: textFieldController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2)
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.cancel, color: Colors.grey,),
                          onPressed: () {
                            setState(() {
                              text = '';
                              textFieldController.clear();
                            });
                          },
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          text = val;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.grey,),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        await setState(() {
                          if(_isShort) {
                            type = 'short';
                          } else {type = 'long';}
                        });
                        Navigator.push(context, CupertinoPageRoute(
                          builder: (context) => ReadPost(text, type, user != null ? user.uid : 'Null')
                        ));
                      }
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 50,),
            ToggleButtons(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 50,
                  child: Center(child: Text('짧은 글')),
                ),
                Container(
                  width: 100,
                  height: 50,
                  child: Center(child: Text('긴 글')),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  if(index == 0) {
                    _isSelected[1] = false;
                    _isSelected[0] = true;
                    _isShort = true;
                  } else {
                    _isSelected[0] = false;
                    _isSelected[1] = true;
                    _isShort = false;
                  }
                });
              },
              isSelected: _isSelected,
              selectedColor: Colors.blue,
            ),


          ],
        ),
      )
    );
  }
}
