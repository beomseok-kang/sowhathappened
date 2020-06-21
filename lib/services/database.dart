import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sowhathappened/models/feeling.dart';
import 'package:sowhathappened/models/post.dart';
import 'package:sowhathappened/models/user.dart';

class DatabaseService {
  final String uid;
  final String postIndex;
  DatabaseService({this.uid, this.postIndex});

  final CollectionReference userDataCollection = Firestore.instance.collection('user');
  final CollectionReference feelingDataCollection = Firestore.instance.collection('feeling');

  //updates userdata
  Future createUserData(String nickname,List<String> written) async {
    return await userDataCollection.document(uid).setData({
      '닉네임' : nickname,
      '쓴 글 인덱스' : written,
    });
  }
  Future createFeeling(String uid) async {
    return await feelingDataCollection.document(uid).setData({
      '주제' : [],
      '글' : [],
      '타입' : [],
      '포스트인덱스' : []
    });
  }

  Future updateFeeling(String uid, List<String> topics, String writing, String type, String postIndex) async {
    return await feelingDataCollection.document(uid).updateData({
      '주제' : FieldValue.arrayUnion([{
        postIndex : topics
      }]),
      '글' : FieldValue.arrayUnion([writing]),
      '타입' : FieldValue.arrayUnion([{
        postIndex : type
      }]),
      '포스트인덱스' : FieldValue.arrayUnion([postIndex])
    });
  }

  Future notLikeTheFeeling(String uid, String writing, List<dynamic> topics, String type, String postIndex) async {
    return await feelingDataCollection.document(uid).updateData({
      '글' : FieldValue.arrayRemove([writing]),
      '주제' : FieldValue.arrayRemove([{postIndex : topics}]),
      '타입' : FieldValue.arrayRemove([{postIndex : type}]),
      '포스트인덱스' : FieldValue.arrayRemove([postIndex])
    });
  }

  Future uploadPost(String userUid, String postIndex, String type, String dateTime, String postIndexIndex, List<String> topics, List<String> writings, List<String> writers) async {
    return await Firestore.instance.collection(type).document(postIndex).setData({
      '포스트인덱스' :postIndex,
      '타입' : type,
      '날짜시간' : dateTime,
      '포스트인덱스인덱스' : [{postIndexIndex : userUid}],
      '주제' : topics,
      '글' : writings,
      '릴레이종료' : false,
      '좋아요 수' : 0,
      '글쓴이들(uid)' : writers,
      '좋아요를 누른 사람' : [],
      '댓글' : []
    });
  }
  
  Future likeThePost(String postIndex, String type, String uid) async{
    return await Firestore.instance.collection(type).document(postIndex).updateData(
      {
        '좋아요를 누른 사람' : FieldValue.arrayUnion([uid]),
        '좋아요 수' : FieldValue.increment(1)
      }
    );
  }
  
  Future notLikeThePost(String postIndex, String type, String uid) async {
    return await Firestore.instance.collection(type).document(postIndex).updateData(
      {
        '좋아요를 누른 사람' : FieldValue.arrayRemove([uid]),
        '좋아요 수' : FieldValue.increment(-1)
      }
    );
  }

  Future userPostReferencing(String uid, String postIndex, List<String> topics, String writing, String type) async {
    return await userDataCollection.document(uid).updateData({
      '쓴 글 인덱스' : FieldValue.arrayUnion([{
        postIndex : [
          {'주제' : topics},
          {'글' : writing},
          {'타입' : type}
        ]
      }]),
    });
  }
  Future deleteUserPostReferencing(String uid, String postIndex, List<dynamic> topics, String writing, String type) async {
    return await userDataCollection.document(uid).updateData({
      '쓴 글 인덱스' : FieldValue.arrayRemove([{
        postIndex : [
          {'주제' : topics},
          {'글' : writing},
          {'타입' : type}
        ]
      }])
    });
  }

  Future updatePost(String postIndex, String type, String postIndexIndex, String writing, String writer) async {
    return await Firestore.instance.collection(type).document(postIndex).updateData(
      {
        '포스트인덱스인덱스' : FieldValue.arrayUnion([{postIndexIndex : writer}]),
        '글' : FieldValue.arrayUnion([writing]),
        '글쓴이들(uid)' : FieldValue.arrayUnion([writer]),
//        '글쓴이들(닉네임)' : FieldValue.arrayUnion([nickname])
      }
    );
  }

  Future finishRelay(String type, String postIndex) async {
    return await Firestore.instance.collection(type).document(postIndex).updateData(
      {
        '릴레이종료' : true
      }
    );
  }

  Future commentUpload(String comment, int commentIndex, int commentCommentIndex, String postIndex, String type, String writer) async {
    return await Firestore.instance.collection(type).document(postIndex).collection('댓글').document('${commentIndex}_${commentCommentIndex}').setData(
      {
         '내용' : comment,
         '댓글인덱스' : commentIndex,
         '대댓글인덱스' : commentCommentIndex,
         '좋아요를누른사람' : [],
         '싫어요를누른사람' : [],
         '좋아요수' : 0,
         '싫어요수' : 0,
         '임시작성자' : writer,
      }
    );
  }

  Future commentLikeDislike(String uid, String type, String postIndex, int commentIndex, int commentCommentIndex, {bool like, bool dislike}) async {
    if(like) {
      return await Firestore.instance.collection(type).document(postIndex).collection('댓글').document('${commentIndex}_${commentCommentIndex}').updateData(
        {
          '좋아요수' : FieldValue.increment(1),
          '좋아요를누른사람' : FieldValue.arrayUnion([uid])
        }
      );
    } else if(dislike) {
      return await Firestore.instance.collection(type).document(postIndex).collection('댓글').document('${commentIndex}_${commentCommentIndex}').updateData(
          {
            '싫어요수' : FieldValue.increment(1),
            '싫어요를누른사람' : FieldValue.arrayUnion([uid])
          }
      );
    } else {return null;}
  }

  Future commentUnlikeUndislike(String uid, String type, String postIndex, int commentIndex, int commentCommentIndex, {bool like, bool dislike}) async {
    if(like) {
      return await Firestore.instance.collection(type).document(postIndex).collection('댓글').document('${commentIndex}_${commentCommentIndex}').updateData(
          {
            '좋아요수' : FieldValue.increment(-1),
            '좋아요를누른사람' : FieldValue.arrayRemove([uid])
          }
      );
    } else if(dislike) {
      return await Firestore.instance.collection(type).document(postIndex).collection('댓글').document('${commentIndex}_${commentCommentIndex}').updateData(
          {
            '싫어요수' : FieldValue.increment(-1),
            '싫어요를누른사람' : FieldValue.arrayRemove([uid])
          }
      );
    } else {return null;}
  }

  Future commentDelete(String type, String postIndex, String commentIndexes) async {
    return await Firestore.instance.collection(type).document(postIndex).collection('댓글').document(commentIndexes).delete();
  }

  Future deletePost(String postIndex, String type, String postIndexIndex, String writing, String writer) async {
    return await Firestore.instance.collection(type).document(postIndex).updateData({
      '글' : FieldValue.arrayRemove([writing]),
      '포스트인덱스인덱스' : FieldValue.arrayRemove([{
        postIndexIndex : writer
      }])
    });
  }
  Future deleteWholePost(String postIndex, String type) async {
    return await Firestore.instance.collection(type).document(postIndex).delete();
  }

  UserData userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        nickname: snapshot.data['닉네임'],
        written: snapshot.data['쓴 글 인덱스'], //포스트인덱스인덱스를 저장
    );
  }

  Post postDataFromSnapshot(DocumentSnapshot snapshot) {
    return Post(
      type: snapshot.data['타입'],
      dateTime: snapshot.data['날짜시간'],
      postIndexIndex: snapshot.data['포스트인덱스인덱스'],
      topics: snapshot.data['주제'],
      writings: snapshot.data['글'],
      writers: snapshot.data['글쓴이들(uid)']
    );
  }

  FeelingData feelingDataFromSnapshot(DocumentSnapshot snapshot) {
    return FeelingData(
      topics: snapshot.data['주제'],
      writing: snapshot.data['글'],
      type: snapshot.data['타입'],
      postIndex: snapshot.data['포스트인덱스']
    );
  }

  //from stream

  Stream<UserData> get userData {
    return userDataCollection.document(uid).snapshots().map(
        userDataFromSnapshot);
  }
  Stream<FeelingData> get feelingData{
    return feelingDataCollection.document(uid).snapshots().map(feelingDataFromSnapshot);
  }
}