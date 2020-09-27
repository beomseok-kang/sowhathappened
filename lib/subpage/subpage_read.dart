import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sowhathappened/UI/infinite_scroll.dart';
import 'package:sowhathappened/loading.dart';
import 'package:sowhathappened/services/queries.dart';
import 'package:sowhathappened/style/style_standard.dart';

class Read extends StatefulWidget {
  final Function() onRefresh;
  Read({@required this.onRefresh});

  @override
  _ReadState createState() => _ReadState();
}

class _ReadState extends State<Read> {
  int _selectedIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    widget.onRefresh();
    super.initState();
  }

  bool _hasData(Queries queries) {
    return queries.qsLongRead != null && queries.qsShortRead != null;
  }

  @override
  Widget build(BuildContext context) {
    final queries = Provider.of<Queries>(context);
    return _hasData(queries)
        ? Scaffold(
            backgroundColor: bgColor(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                  child: Text('글 읽기', style: bigHeaderStyle()),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: FlatButton(
                        child: Text(
                          '짧은 글',
                          style: selectionStyle(_selectedIndex, 0),
                        ),
                        onPressed: () {
                          _pageController.animateToPage(0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.fastOutSlowIn);
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: FlatButton(
                        child: Text(
                          '긴 글',
                          style: selectionStyle(_selectedIndex, 1),
                        ),
                        onPressed: () {
                          _pageController.animateToPage(1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.fastOutSlowIn);
                        },
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    scrollDirection: Axis.horizontal,
                    physics: PageScrollPhysics(),
                    children: <Widget>[
                      SizedBox(
                        child: InfiniteScroller(
                          type: 'short',
                          onRefresh: queries.refreshRead,
                          onLoad: queries.loadRead,
                          docs: queries.qsShortRead,
                        ),
                      ),
                      SizedBox(
                        child: InfiniteScroller(
                          type: 'long',
                          onRefresh: queries.refreshRead,
                          onLoad: queries.loadRead,
                          docs: queries.qsLongRead,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ))
        : Loading();
  }
}
