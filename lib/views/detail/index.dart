import '/plugins.dart';
import "/model/film_play_info/data.dart" show Data;
import "/model/film_play_info/film_play_info.dart" show FilmPlayInfo;
import "/model/film_play_info/list.dart" show ListData;
import "/model/film_play_info/play_list.dart" show PlayItem;
import "/views/detail/describe.dart" show Describe;
import "/widgets/player/player.dart" show Player;

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
  final double _playerAspectRatio = 16 / 9;
  final List<MyTab> _tabs = [
    MyTab(icon: const Icon(Icons.abc_outlined), label: '详情', key: UniqueKey()),
    MyTab(icon: const Icon(Icons.abc_outlined), label: '简介', key: UniqueKey()),
  ];

  Data? _data;
  int _originIndex = 0;
  int _teleplayIndex = 0;
  int _startAt = 0;

  Future _fetchData(id) async {
    // int id = widget.arguments?['id'];

    var res = await Api.filmDetail(
      context: context,
      queryParameters: {
        'id': id,
      },
    );
    if (res != null && res.runtimeType != String) {
      FilmPlayInfo jsonData = FilmPlayInfo.fromJson(res);

      setState(() {
        _data = jsonData.data;
      });

      var item = getHistory(id);
      if (item != null) {
        setState(() {
          var originId = item['originId'];
          var originIndex = _data?.detail?.list
              ?.indexWhere((element) => originId == element.id);

          if (originIndex != null && originIndex >= 0) {
            setState(() {
              _originIndex = originIndex;
              _teleplayIndex = item['teleplayIndex'];
              _startAt = item['startAt'];
            });
          }
        });
      }
    } else {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        return _fetchData(id);
      }
    }
  }

  Map<String, dynamic>? getHistory(id) {
    var data = context.read<HistoryStore>().data;
    var item = data.firstWhereOrNull((element) => element['id'] == id);
    return item;
  }

  List<ListData?>? get _list {
    return _data?.detail?.list;
  }

  PlayItem? get _playItem {
    return _list?[_originIndex]?.linkList?[_teleplayIndex];
  }

  @override
  void initState() {
    int id = widget.arguments?['id'];
    super.initState();

    _fetchData(id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Flex(
              direction: orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: orientation == Orientation.portrait ? 0 : 1,
                  child: Container(
                      color: Colors.black,
                      child: AspectRatio(
                        aspectRatio: _playerAspectRatio,
                        child: _playItem?.link != null
                            ? Player(
                                // key: Key(
                                //     '${_playItem?.link}-$_originIndex-$_teleplayIndex'),
                                list: _list,
                                detail: _data?.detail,
                                originIndex: _originIndex,
                                teleplayIndex: _teleplayIndex,
                                startAt: _startAt,
                                // aspectRatio: _playerAspectRatio,
                                callback: (originIndex, teleplayIndex) {
                                  setState(() {
                                    _originIndex = originIndex;
                                    _teleplayIndex = teleplayIndex;
                                    _startAt = 0;
                                  });
                                },
                                title: [
                                  BackButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Text(
                                    _data?.detail?.name ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              )
                            : null,
                      )),
                ),
                if (orientation == Orientation.portrait)
                  Container()
                else
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: 0.5,
                      color: Theme.of(context).dividerColor,
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
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                    _startAt = 0;
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
            );
          },
        ),
      ),
    );
  }
}
