import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Queries with ChangeNotifier{
  QuerySnapshot qsShort;
  QuerySnapshot qsLong;
  List<DocumentSnapshot> qsShortHot;
  List<DocumentSnapshot> qsLongHot;
  List<DocumentSnapshot> qsShortRead = [];
  List<DocumentSnapshot> qsLongRead = [];

  Queries();

  void refreshHome() {
    Firestore.instance
        .collection('short')
        .orderBy("좋아요 수", descending: true)
        .limit(10)
        .getDocuments()
        .then((snapshot) {
          qsShort = snapshot;
    });
    Firestore.instance
        .collection('long')
        .orderBy("좋아요 수", descending: true)
        .limit(10)
        .getDocuments()
        .then((snapshot) {
          qsLong = snapshot;
    });
    Firestore.instance
        .collection('short')
        .where("날짜시간",
        isGreaterThanOrEqualTo:
        DateTime.now().subtract(Duration(days: 7)).toString())/////////////////////////////고쳐야하ㅁ//////////////////////////////
        .orderBy("날짜시간", descending: false)
        .orderBy("좋아요 수", descending: true)
        .getDocuments()
        .then((snapshot) {
          List<DocumentSnapshot> _snapshotList = snapshot.documents;
          for (int i=0; i<_snapshotList.length; i++) {
            _snapshotList.sort((b,a) => a.data['좋아요 수'].compareTo(b.data['좋아요 수']));
          }
          qsShortHot = _snapshotList;
    });
    Firestore.instance
        .collection('long')
        .where("날짜시간",
          isGreaterThanOrEqualTo:
            DateTime.now().subtract(Duration(days: 7)).toString())//////////////////////////고쳐야함///////////////////////////////////////
        .orderBy("날짜시간", descending: false)
        .orderBy("좋아요 수", descending: true)
        .getDocuments()
        .then((snapshot) {
          List<DocumentSnapshot> _snapshotList = snapshot.documents;
          for (int i=0; i<_snapshotList.length; i++) {
            _snapshotList.sort((b,a) => a.data['좋아요 수'].compareTo(b.data['좋아요 수']));
          }
          qsLongHot = _snapshotList;
    });
    notifyListeners();
  }

  Future<void> refreshRead() async {
    await Firestore.instance
        .collection('short')
        .orderBy("날짜시간", descending: true)
        .limit(10)
        .getDocuments()
        .then((snapshots) {
        qsShortRead = snapshots.documents;
    });
    await Firestore.instance
        .collection('long')
        .orderBy("날짜시간", descending: true)
        .limit(10)
        .getDocuments()
        .then((snapshots) {
        qsLongRead = snapshots.documents;
    });
    notifyListeners();
    return;
  }

  Future<void> loadRead(String type, DocumentSnapshot last) async {
    await Firestore.instance
      .collection(type)
      .orderBy('날짜시간',descending: true)
      .startAfterDocument(last)
      .limit(10)
      .getDocuments()
      .then((snapshots) {
        if (type == 'long') {
          qsLongRead = qsLongRead + snapshots.documents;
        } else {
          qsShortRead = qsShortRead + snapshots.documents;
        }
      });
    notifyListeners();
    return;
  }
}