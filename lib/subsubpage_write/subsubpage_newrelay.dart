import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sowhathappened/alert_login.dart';
import 'package:sowhathappened/models/topic.dart';
import 'package:sowhathappened/models/user.dart';
import 'package:sowhathappened/services/database.dart';
import 'package:sowhathappened/style/style_standard.dart';
import 'dart:math';

import 'package:sowhathappened/subsubpage_read/subsubpage_readpost.dart';

class NewRelay extends StatefulWidget {
  final String type;

  NewRelay({@required this.type});

  @override
  _NewRelayState createState() =>
      _NewRelayState(type == 'short' ? true : false);
}

class _NewRelayState extends State<NewRelay> {
  bool isShort;

  _NewRelayState(this.isShort);

  final random = Random();
  int rand1, rand2, rand3, rand4, rand5, rand6;
  List<String> sixTopics = [
    topics[0],
    topics[50],
    topics[100],
    topics[150],
    topics[200],
    topics[250]
  ];
  List<String> topicsSelected = [];
  List<bool> _onSelected = [false, false, false, false, false, false];
  String error = '';
  bool _uploading = false;
  String type;
  bool _isShort;
  final textEditingController = TextEditingController();

  void randomNumbers() {
    setState(() {
      rand1 = random.nextInt(49);
      rand2 = 50 + random.nextInt(49);
      rand3 = 100 + random.nextInt(49);
      rand4 = 150 + random.nextInt(49);
      rand5 = 200 + random.nextInt(49);
      rand6 = 250 + random.nextInt(49);
      sixTopics = [
        topics[rand1],
        topics[rand2],
        topics[rand3],
        topics[rand4],
        topics[rand5],
        topics[rand6]
      ];
    });
  }

  final _formKey = GlobalKey<FormState>();
  String text = '';

  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (isShort) {
      setState(() {
        _isShort = true;
        type = '짧은 글';
      });
    } else {
      setState(() {
        _isShort = false;
        type = '긴 글';
      });
    }

    return Scaffold(
      backgroundColor: bgColor(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarColor(),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (text != '') {
              showDeletionAlert(context);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          '새 ' + type + ' 릴레이',
          style: titleStyle(),
        ),
      ),
      body: _buildBody(user.uid),
    );
  }

  Widget _buildBody(String uid) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Text('주제', style: headingStyle()),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        randomNumbers();
                        setState(() {
                          _onSelected = [
                            false,
                            false,
                            false,
                            false,
                            false,
                            false
                          ];
                        });
                      },
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colorNotSelected(),
                        ),
                        child: Icon(
                          Icons.refresh,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.maxFinite,
                  height: 80,
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    padding: EdgeInsets.only(bottom: 40, left: 12, right: 12),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_onSelected[index] == false) {
                              _onSelected[index] = true;
                            } else {
                              _onSelected[index] = false;
                            }
                          });
                        },
                        child: AnimatedContainer(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          duration: Duration(milliseconds: 300),
                          curve: Curves.fastOutSlowIn,
                          decoration: BoxDecoration(
                              color: _onSelected[index] == true
                                  ? colorOnSelection()
                                  : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 13),
                                blurRadius: 31,
                                color: shadowColor()
                              )
                            ]
                          ),
                          child: Center(
                            child: Text(
                              sixTopics[index],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _onSelected[index] == true
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      width: 10,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                        focusColor: colorOnSelection(),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: '글을 입력해 주세요.',
                        contentPadding: const EdgeInsets.all(10.0)),
                    keyboardType: TextInputType.multiline,
                    minLines: _isShort ? null : 15,
                    maxLines: _isShort ? 15 : 25,
                    maxLength: _isShort ? 100 : 500,
                    validator: (val) => text.length < 1 ? '내용을 입력해주세요.' : null,
                    onChanged: (val) {
                      setState(() => text = val);
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: InkWell(
                    onTap: () async {
                      //토픽 고른 것들 리스트에 추가
                      setState(() {
                        _uploading = true;

                        for (int i = 0; i < 6; i++) {
                          if (_onSelected[i] == true) {
                            topicsSelected.add(sixTopics[i]);
                          } else {
                            continue;
                          }
                        }
                        if (topicsSelected == []) {
                          topicsSelected = ['없음'];
                        }
                      });

                      if (_formKey.currentState.validate()) {
                        String postIndex = '${DateTime.now()}_${uid}';

                        await _databaseService.uploadPost(
                            uid,
                            postIndex,
                            //포스트인덱스를 추가 - 포스트인덱스 형식: 날짜시간_첫작성자 uid
                            _isShort ? 'short' : 'long',
                            '${DateTime.now()}',
                            '${DateTime.now()}_${uid}_0',
                            //포스트인덱스인덱스를 추가 - 포스트인덱스인덱스 형식: 날짜시간_첫작성자 uid_번호 (0부터시작, 최대9)
                            topicsSelected,
                            // 토픽들을 어레이에 추가
                            [text],
                            //첫 글을 어레이에 추가
                            [uid] //첫 글쓴이를 어레이에 추가 (uid)
                            ).catchError((e) {
                          setState(() {
                            _uploading = false;
                            print(e);
                          });
                        });

                        await _databaseService.userPostReferencing(
                            uid,
                            postIndex,
                            topicsSelected,
                            text,
                            _isShort ? 'short' : 'long');

                        setState(() {
                          _uploading = false;
                        });

                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReadPost(postIndex,
                                    _isShort ? 'short' : 'long', uid)));
                      } else {
                        setState(() {
                          _uploading = false;
                        });
                      }
                    },
                    child: Container(
                      width: double.maxFinite,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: colorOnSelection(),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 13),
                                blurRadius: 31,
                                color: shadowColor()
                            )
                          ]
                      ),
                      child: _uploading
                          ? Center(
                              child: SpinKitCircle(
                              color: Colors.white,
                            ))
                          : Center(
                              child: Text(
                              '작성 완료',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                error == ''
                    ? Container()
                    : Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      ),
                SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
