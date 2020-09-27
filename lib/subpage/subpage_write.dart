import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sowhathappened/alert_login.dart';
import 'package:sowhathappened/models/user.dart';
import 'package:sowhathappened/style/style_standard.dart';
import 'package:sowhathappened/subsubpage_write/subsubpage_relays.dart';

class Write extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final user = Provider.of<User>(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
              child: Text('글 쓰기', style: bigHeaderStyle()),
            ),
            SizedBox(
              height: 20,
            ),
            buttonToRelay(user, 'short', context),
            SizedBox(
              height: 15,
            ),
            buttonToRelay(user, 'long', context),
            SizedBox(
              height: 15,
            ),
            buttonToRelay(user, 'me', context),
          ],
        ),
      ),
    );
  }

  Widget buttonToRelay(User user, String type, context) {
    return InkWell(
      onTap: () {
        if (user == null) {
          showLoginAlertDialog(context);
        } else if (type != 'me') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RelayJoin(
                      type: type,
                    )),
          );
        } else {}
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        height: 150,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: colorOnSelection(),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: shadowColor(),
              offset: Offset(0, 13),
              blurRadius: 31,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              type == 'short'
                  ? '짧은 글 릴레이'
                  : type == 'long' ? '긴 글 릴레이' : '혼자 쓰는 글',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              type == 'short'
                  ? '100자 이내의 짧은 글 릴레이'
                  : type == 'long' ? '500자 이내의 긴 글 릴레이' : '내가 혼자 완성하는 글',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
