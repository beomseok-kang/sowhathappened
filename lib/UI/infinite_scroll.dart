import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sowhathappened/UI/list_tile.dart';
import 'package:sowhathappened/loading.dart';
import 'package:sowhathappened/models/user.dart';
import 'package:sowhathappened/services/queries.dart';

class InfiniteScroller extends StatefulWidget {
  final String type;
  final Function() onRefresh;
  final Function(String type, DocumentSnapshot last) onLoad;
  final List<DocumentSnapshot> docs;

  InfiniteScroller({
    @required this.type,
    @required this.onRefresh,
    @required this.onLoad,
    @required this.docs
  });

  @override
  _InfiniteScrollerState createState() => _InfiniteScrollerState();
}

class _InfiniteScrollerState extends State<InfiniteScroller> {
  
  DocumentSnapshot last;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  void initState() {
    setState(() {
      last = widget.docs[widget.docs.length - 1];
    });
    super.initState();
  }

  void _onScrollLoad() async {
    await widget.onLoad(widget.type, last);
    setState(() {
      if(widget.docs != null) {
        last = widget.docs[widget.docs.length - 1];
      }
    });
    _refreshController.loadComplete();
  }
  void _onRefresh() async {
    await widget.onRefresh();
    setState(() {
      if(widget.docs != null) {
        last = widget.docs[widget.docs.length - 1];
      }
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (widget.docs == null) {
      return Loading();
    } else {
      return SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        controller: _refreshController,
        onLoading: _onScrollLoad,
        onRefresh: _onRefresh,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: widget.docs.length,
          itemBuilder: (BuildContext context, int index) {
            final ds = widget.docs[index];
            final props = ListViewTileProps(
              postIndex: ds.data['포스트인덱스'],
              texts: ds.data['글'],
              text: '',
              type: ds.data['타입'],
              topics: ds.data['주제']
            );
            return ListViewTile(
                context: context,
                index: index,
                uid: user.uid,
                props: props
            );
          }
        ),
      );
    }
  }
}
