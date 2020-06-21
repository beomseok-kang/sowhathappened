import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:sowhathappened/loading.dart';
import 'package:sowhathappened/services/auth.dart';
import 'package:sowhathappened/style/style_standard.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();


  String email = '';
  String password = '';
  String _checkPassword = '';
  String error = '';
  String nickname = '';
  bool loading = false;
  bool _showPassword = false;
  bool _showDoubleCheckPassword = false;
  bool _registerComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      backgroundColor: bgColor(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: loading ? Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(100),),
          Center(
              child: Loading())
        ],
      ) : _registerComplete ? _registerCompletePage() : _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 80,),
            Text('회원가입', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,)),
            Padding(padding: EdgeInsets.all(12),),

            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 10, bottom: 10),),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: '닉네임',
                          contentPadding: const EdgeInsets.all(10.0)
                      ),
                      validator: (val) => val.length < 3 || val.length > 8 ? '닉네임을 정확히 입력해 주세요.' : null,
                      onChanged: (val) {
                        setState(() => nickname = val);
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(2),),
                  Container(
                      child: Text('3-8자의 한글, 영문, 숫자, 특수문자만 입력 가능합니다.', style: TextStyle(fontSize: 10, color: Colors.grey),)
                  ),
                  Padding(padding: EdgeInsets.all(4),),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: '이메일 주소',
                          contentPadding: const EdgeInsets.all(10.0)
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => EmailValidator.validate(val) ? null : '이메일 주소를 정확히 입력해 주세요..',
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: TextFormField(
                        decoration: InputDecoration(
                            hintText: '비밀번호',
                            contentPadding: const EdgeInsets.all(10.0),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            icon: Icon(Icons.remove_red_eye),
                            color: _showPassword == true? Colors.black : Colors.grey,
                            iconSize: 25.0,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: _showPassword == true? false : true,
                        validator: (val) => val.length < 8 || val.length >16 ? '비밀번호를 제대로 입력해 주세요.' : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        }
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(2),),
                  Text('8-16자의 영문, 숫자, 특수문자만 입력 가능합니다.', style: TextStyle(fontSize: 10, color: Colors.grey),),
                  Padding(padding: EdgeInsets.all(4),),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: TextFormField(
                        decoration: InputDecoration(
                            hintText: '비밀번호 재입력',
                            contentPadding: const EdgeInsets.all(10.0),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showDoubleCheckPassword = !_showDoubleCheckPassword;
                              });
                            },
                            icon: Icon(Icons.remove_red_eye),
                            color: _showDoubleCheckPassword == true? Colors.black : Colors.grey,
                            iconSize: 25.0,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: _showDoubleCheckPassword ? false : true,
                        validator: (val) => val == password ? null : '비밀번호가 맞지 않습니다.',
                        onChanged: (val) {
                          setState(() => _checkPassword = val);
                        }
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10),),
                  InkWell(
                    onTap: nickname == '' || email == '' || password == '' || _checkPassword == '' ? null : () async {
                      if(_formKey.currentState.validate()) {
                        setState(() => loading = true);
                        dynamic result = await _auth
                            .registerWithEmailAndPassword(email, password, nickname);

                        if(result == null){
                          setState(() {
                            loading = false;
                            error = '오류가 일어났습니다. 다시 시도해 주세요.';
                          });
                        } else if(result == 'complete') {
                          setState(() {
                            _registerComplete = true;
                            loading = false;
                          });
                        } else {}
                      }},
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        color: colorOnSelection(),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0,13),
                            blurRadius: 31,
                            color: shadowColor()
                          )
                        ],
                        borderRadius: BorderRadius.circular(12)
                      ),

                      child: Center(child: Text('바로 시작', style: TextStyle(fontSize:16, fontWeight: FontWeight.bold, color: Colors.white),)),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4),),
                  SizedBox(
                    height: 20,
                    child: Text(error, style: TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                  Padding(padding: EdgeInsets.all(12),),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(20),),
          ],
        ),
      ),
    );
    

  }

  Widget _registerCompletePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.check_circle, size: 100, color: Colors.blue,),
          SizedBox(height: 20,),
          Text('회원가입이 완료되었습니다.'),
          SizedBox(height: 20,),
          RaisedButton(
            child: Text('로그인 화면으로'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

