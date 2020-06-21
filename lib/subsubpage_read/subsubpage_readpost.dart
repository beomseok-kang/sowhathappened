import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sowhathappened/alert_login.dart';
import 'package:sowhathappened/loading.dart';
import 'package:sowhathappened/models/user.dart';
import 'package:sowhathappened/services/database.dart';
import 'package:sowhathappened/style/style_standard.dart';

class ReadPost extends StatefulWidget {

  final String postIndex;
  final String type;
  final String uid;
  ReadPost(this.postIndex, this.type, this.uid);

  @override
  _ReadPostState createState() => _ReadPostState();
}

class _ReadPostState extends State<ReadPost> {

  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();


  DocumentSnapshot ds;
//  QuerySnapshot qsComments;
  bool _wrongInput = false;
  bool showTextFormField = false;
  String text = '';
  bool _uploading = false;
  final myController = TextEditingController();
  bool _likeIt = false;
  int likes;
  int numOfComments = 0;
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {

//    Firestore.instance.collection(type).document(postIndex).collection('댓글').getDocuments().then((snapshot) {
//      setState(() {
//        qsComments = snapshot;
//      });
//    });

     Firestore.instance.collection(widget.type).document(widget.postIndex).get().then((DocumentSnapshot snapshot) {
        setState(() {
          ds = snapshot;
          text = '';
          if (ds.data != null) {
            likes = ds.data['좋아요를 누른 사람'].toList().length;
          } else {_wrongInput = true;}
          myController.text = '';
          showTextFormField = false;
        });
      }).catchError((e) {
        print(e);
        setState(() {
          _wrongInput = true;
        });
     });


    if (widget.uid != 'Null') {
      Firestore.instance.collection('feeling').document(widget.uid).get().then((DocumentSnapshot snapshot) {
        setState(() {
          if (snapshot.data['포스트인덱스'].contains(widget.postIndex)) {
            _likeIt = true;
          } else {_likeIt = false;}
        });
      });
    }

    super.initState();
  }


  @override

  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if (ds!=null && ds.data != null) {

      return Scaffold(
        backgroundColor: bgColor(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: appBarColor(),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (text == '') {
                Navigator.pop(context);
              } else {
                showDeletionAlert(context);
              }
            },
          ),
          title: Text('글 읽기',style: titleStyle(),),
          actions: <Widget>[
            text != '' ? FlatButton(
              child: Text('작성 완료',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              color: Colors.transparent,
              onPressed: () async {

                if (_formKey.currentState.validate()) {
                  setState(() {
                    _uploading = true;
                  });

                  String postIndexIndex = '${widget.postIndex}_${ds.data['글'].length}';

                  await _databaseService.updatePost(widget.postIndex, widget.type, postIndexIndex, text, user.uid).catchError((e) {
                    setState(() {
                      _uploading = false;
                      print(e.toString());
                    });
                  });

                  await _databaseService.userPostReferencing(user.uid, widget.postIndex, List<String>.from(ds.data['주제']), text, widget.type);

                  if(ds.data['글'].length == 9) {
                    await _databaseService.finishRelay(widget.type, widget.postIndex);
                  }

                  setState(() {
                    _uploading = false;
                  });

                  initState();
                }
              },
            ) : Container(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: appBarColor(),
          elevation: 0,
          child: Row(
            children: <Widget>[
//              GestureDetector(
//                onTap: () {
//                  Navigator.push(context, MaterialPageRoute(
//                    builder: (context) => CommentPage(qsComments)
//                  ));
//                },
//                child: Row(
//                  children: <Widget>[
//                    SizedBox(width: 20,),
//                    Text('댓글'),
//                    SizedBox(width: 5,),
//                    Text('($numOfComments)',
//                      style: TextStyle(
//                        fontWeight: FontWeight.bold
//                      ),
//                    ),
//                  ],
//                ),
//              ),
              Spacer(),
              Text(likes.toString()),
              IconButton(
                icon: Icon(_likeIt ? Icons.favorite : Icons.favorite_border, color: colorForLike(),),
                onPressed: user == null ? () {
                  showLoginAlertDialog(context);
                } : _likeIt ? () async {
                  setState(() {
                    _likeIt = false;
                    likes--;
                  });
                  await _databaseService.notLikeTheFeeling(user.uid, ds.data['글'][0].toString(), ds.data['주제'], widget.type, widget.postIndex);
                  await _databaseService.notLikeThePost(widget.postIndex, widget.type, user.uid);
                } : () async {
                  setState(() {
                    _likeIt = true;
                    likes++;
                  });
                  await _databaseService.likeThePost(widget.postIndex, widget.type, user.uid);
                  await _databaseService.updateFeeling(user.uid, List<String>.from(ds.data['주제']), ds.data['글'][0].toString(), widget.type, widget.postIndex);

                },
              ),
              Text('좋아요'),
              SizedBox(width: 20,)
            ],
          )
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 20,),
                    Column(
                      children: <Widget>[
                        Text(ds.data['타입'] == 'short' ? '짧은 글' : ds.data['타입'] == 'long' ? '긴 글' : '기타',
                          style: headingStyle(),),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: <Widget>[
                        Text('주제', style: headingStyle(),),
                        Text(cutBracket(List<String>.from(ds.data['주제']).toString())),
                      ],
                    ),
                    Spacer(),
                    Text('${ds.data['글'].length}/10', style: headingStyle(),),
                    SizedBox(width: 20,),
                  ],
                ),
                SizedBox(height: 20,),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: PageScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: ds.data['글'].length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < ds.data['글'].length) {

                        return Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 30,
                                  child: Row(
                                    children: <Widget>[
                                      index == 0 ?
                                      FlatButton(
                                        color: Colors.transparent,
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.content_copy, color: Colors.grey,),
                                            SizedBox(width: 4,),
                                            Text('글 인덱스 복사')
                                          ],
                                        ),
                                        onPressed: () {
                                          Clipboard.setData(new ClipboardData(text: widget.postIndex));
                                        },
                                      ) : Container(),
                                      Spacer(),
                                      user == null ?
                                      Container() :
                                      cutBracket(ds.data['포스트인덱스인덱스'][index].values.toString()) == user.uid && ds.data['릴레이종료'] == false?
                                      SizedBox(
                                        width: 110,
                                        child: FlatButton(
                                          color: Colors.transparent,
                                          child: Row(
                                            children: <Widget>[
                                              Icon(Icons.delete, color: Colors.grey,),
                                              SizedBox(width: 4,),
                                              Text('글 삭제'),
                                            ],
                                          ),
                                          onPressed: () {
                                            showPostDeleteAlert(index, cutBracket(ds.data['포스트인덱스인덱스'][index].keys.toString()),
                                                ds.data['글'][index], ds.data['주제'], cutBracket(ds.data['포스트인덱스인덱스'][index].values.toString()), context);
                                          },
                                        ),
                                      ) : Container(),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(ds.data['글'][index])
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Center(child: Text('${index+1}',
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                                        )
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      } else if (ds.data['글'].length < 10){
                        return SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('릴레이를 이어 주세요!'),
                                    SizedBox(width: 20,),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.grey,
                                      ),
                                      child: IconButton(
                                        color: Colors.white,
                                        icon: showTextFormField ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
                                        onPressed: user == null ? () {
                                          showLoginAlertDialog(context);
                                        } : () {
                                          setState(() {
                                            showTextFormField = !showTextFormField;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20,),
                                AnimatedContainer(
                                  color: showTextFormField ? Colors.transparent : Colors.red,
                                  height: showTextFormField ? 500 : 0,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                  child: _uploading ? Loading () : Form(
                                    key: _formKey,
                                    child: SingleChildScrollView(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            hintText: '글을 입력해 주세요.',
                                            contentPadding: const EdgeInsets.all(10.0)
                                        ),
                                        controller: myController,
                                        keyboardType: TextInputType.multiline,
                                        minLines: widget.type == 'short' ? null : 15,
                                        maxLines: widget.type == 'short' ? 15 : 25,
                                        maxLength: widget.type == 'short' ? 100 : 500,
                                        validator: (val) => text.length < 1 ? '내용을 입력해주세요.' : null,
                                        onChanged: (val) {
                                          setState(() => text = val);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Text('이번 릴레이는 마감되었습니다.\n다른 릴레이를 찾아보세요!')
                            ],
                          ),
                        );
                      }
                    }
                  ),


                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          _pageController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
                        },
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          _pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else if (_wrongInput == false){
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Loading()
          ],
        ),
      );
    } else {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('인덱스가 잘못되었습니다.\n제대로 입력했는지 확인해 주세요.', textAlign: TextAlign.center,),
              FlatButton(
                color: Colors.grey,
                child: Text('뒤로'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        )
      );
    }
  }

  showPostDeleteAlert (int index, String postIndexIndex, String writing, List<dynamic> topics, String writer,BuildContext context) {

    bool _loading = false;

    AlertDialog alert = AlertDialog(
      title: _loading ? null : Text('글 삭제'),
      content: _loading ? SpinKitCircle(color: Colors.grey,) : index == 0 ? Text('삭제하면 모든 글이 사라집니다.\n계속하시겠습니까?') : Text('삭제하면 되돌릴 수 없습니다.\n계속하시겠습니까?',),
      actions: _loading ? null : <Widget>[
        FlatButton(
          child: Text('아니오',style: TextStyle(color: Colors.black),),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('예',style: TextStyle(color: Colors.blue),),
          onPressed: () async {
            setState(() {
              _loading = true;
            });
            if(index == 0) {
              _databaseService.deleteWholePost(widget.postIndex, widget.type);
            }

            _databaseService.deletePost(widget.postIndex, widget.type, postIndexIndex, writing, writer);
            _databaseService.deleteUserPostReferencing(writer, widget.postIndex, topics, writing, widget.type);
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
}
