class User {
  final String uid;
  User({this.uid});
}

class UserData {
  final String uid;
  final String nickname;
  final List<dynamic> written; //포스트인덱스인덱스를 저장
  final List<dynamic> firstLine;
  final List<dynamic> topics;

  UserData({this.uid,this.nickname,this.written, this.firstLine, this.topics});
}
