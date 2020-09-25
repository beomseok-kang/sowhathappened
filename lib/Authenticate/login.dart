import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sowhathappened/Authenticate/register.dart';
import 'package:sowhathappened/UI/standard_button.dart';
import 'package:sowhathappened/loading.dart';
import 'package:sowhathappened/services/auth.dart';
import 'package:sowhathappened/style/style_standard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

//
//  final GoogleSignIn _googleSignIn = GoogleSignIn();
//  final FirebaseAuth _auth = FirebaseAuth.instance;

  String email = '';
  String password = '';
  String error = '';
  bool _showPassword = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: bgColor(),
      body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                  child: Text('로그인', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                ),
                loading ? Loading() : _loginBody(),

              ],
            )
        ),
    );
  }

  Widget _loginBody() {
    return Column(
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 10, bottom: 10),),
              Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: '이메일 주소',
                      contentPadding: const EdgeInsets.all(10.0)
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => EmailValidator.validate(val) ? null : '이메일 주소를 정확히 입력해 주세요.',
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
              ),
              Padding(padding: EdgeInsets.all(4),),
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
                        color: _showPassword? colorOnSelection() : colorNotSelected(),
                        iconSize: 25.0,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: _showPassword? false : true,
                    validator: (val) => val.length < 8 || val.length >16 ? '비밀번호를 제대로 입력해 주세요.' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    }
                ),
              ),
              Padding(padding: EdgeInsets.all(12),),
              SizedBox(
                height: 20,
                child: Text(error, style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
              StandardButton(
                title: '로그인',
                buttonColor: colorOnSelection(),
                textColor: Colors.white,
                onTap: () async {
                  if(_formKey.currentState.validate()) {
                    setState(() => loading = true);
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if(result == null){
                      setState(() {
                        error = '회원이 아니거나 잘못 입력하셨습니다.';
                        loading = false;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  }}),
              SizedBox(height: 20,),
              StandardButton(
                title: '회원가입',
                buttonColor: Colors.white,
                textColor: colorOnSelection(),
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => Register()));
                }),
            ],
          ),
        ),
      ],
    );
  }

}

