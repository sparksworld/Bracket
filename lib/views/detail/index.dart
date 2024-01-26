import "package:bracket/model/film_detail/data.dart";
import "package:bracket/model/film_detail/film_detail.dart";
import "package:bracket/model/film_detail/play_list.dart";
import "package:bracket/views/detail/describe.dart";
import 'package:bracket/plugins.dart';
import "package:bracket/views/detail/player.dart";

import "series.dart";

class DetailPage extends StatefulWidget {
  final Map? arguments;
  const DetailPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class MyTab {
  final Widget icon;
  final String label;
  final Key key;

  MyTab({required this.icon, required this.label, required this.key});
}

class _DetailPageState extends State<DetailPage> {
  final List<MyTab> _tabs = [
    MyTab(icon: const Icon(Icons.abc_outlined), label: '详情', key: UniqueKey()),
    MyTab(icon: const Icon(Icons.abc_outlined), label: '简介', key: UniqueKey()),
  ];

  Data? _data;
  int _originIndex = 0;
  int _teleplayIndex = 0;

  Future _fetchData() async {
    int id = widget.arguments?['id'];
    setState(() {});
    var res = await Api.filmDetail(
      queryParameters: {
        'id': id,
      },
    );
    if (res != null && res != '') {
      FilmDetail jsonData = FilmDetail.fromJson(res);
      setState(() {
        _data = jsonData.data;
      });
    } else {
      await Future.delayed(const Duration(seconds: 2));
      // setState(() {});
      _fetchData();
    }
  }

  List<List<PlayList>?>? get _playList {
    return _data?.detail?.playList;
  }

  PlayList? get _playItem {
    return _playList?[_originIndex]?[_teleplayIndex];
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: Player(
                key: Key('${_playItem?.link}-$_originIndex'),
                data: _playItem,
              ),
            ),
            Expanded(
              flex: 1,
              child: DefaultTabController(
                length: _tabs.length,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      tabs: _tabs
                          .map<Tab>(
                            (MyTab e) => Tab(
                              key: e.key,
                              child: Text(e.label),
                            ),
                          )
                          .toList(),
                    ),
                    Expanded(
                      flex: 1,
                      child: TabBarView(
                        children: [
                          Series(
                            initOriginIndex: _originIndex,
                            initTeleplayIndex: _teleplayIndex,
                            data: _data,
                            callback: (originIndex, teleplayIndex) {
                              setState(() {
                                _originIndex = originIndex;
                                _teleplayIndex = teleplayIndex;
                              });
                            },
                          ),
                          Describe(data: _data)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
