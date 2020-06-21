import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sowhathappened/Authenticate/login.dart';

showLoginAlertDialog (BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text('로그인 필요'),
    content: Text('로그인이 필요합니다.\n로그인 하시겠습니까?',),
    actions: <Widget>[
      FlatButton(
        child: Text('아니오',style: TextStyle(color: Colors.black),),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      FlatButton(
        child: Text('예',style: TextStyle(color: Colors.blue),),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(context,
              CupertinoPageRoute(
                  builder: (context) => LoginPage()
              )
          );
        },
      )
    ],
    elevation: 4.0,
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

showDeletionAlert (BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text('글 작성 취소'),
    content: Text('지금 나가시면 작성한\n모든 내용이 사라집니다.\n계속하시겠습니까?',),
    actions: <Widget>[
      FlatButton(
        child: Text('아니오',style: TextStyle(color: Colors.black),),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      FlatButton(
        child: Text('예',style: TextStyle(color: Colors.blue),),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      )
    ],
    elevation: 4.0,
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      }
  );
}

