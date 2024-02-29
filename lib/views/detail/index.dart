import "package:bracket/model/film_detail/data.dart";
import "package:bracket/model/film_detail/link_list.dart";
import "package:bracket/model/film_detail/list.dart";
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
    var a = context.read<HistoryStore>();
    var res = await Api.filmDetail(
      queryParameters: {
        'id': id,
      },
    );
    if (res != null && res.runtimeType != String) {
      FilmDetail jsonData = FilmDetail.fromJson(res);
      setState(() {
        _data = jsonData.data;
      });
      a.addHistory({
        'id': _data?.detail?.id,
        "name": _data?.detail?.name,
        "timeStamp": DateTime.now().microsecondsSinceEpoch,
        "picture": _data?.detail?.picture
      });

      // print(_data.detail.name);
    } else {
      await Future.delayed(const Duration(seconds: 2));
      return _fetchData();
    }
  }

  List<OriginList?>? get _originList {
    return _data?.detail?.list ?? [];
  }

  List<LinkList?>? get _playList {
    if (_originList!.isNotEmpty) {
      return _originList?[_originIndex]?.linkList ?? [];
    }
    return [];
  }

  LinkList? get _playItem {
    if (_playList!.isNotEmpty) {
      return _playList?[_teleplayIndex];
    }
    return LinkList(episode: '', link: '');
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
      appBar: AppBar(
        title: Text(_data?.detail?.name ?? ''),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: PlayerVideo(
                key: Key('${_playItem?.link}-$_originIndex-$_teleplayIndex'),
                playItem: _playItem,
                originIndex: _originIndex,
                teleplayIndex: _teleplayIndex,
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
                              child: Text(
                                e.label,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
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
