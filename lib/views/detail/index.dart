import '/plugins.dart';
import "/model/film_play_info/data.dart" show Data;
import "/model/film_play_info/film_play_info.dart" show FilmPlayInfo;
import "/model/film_play_info/list.dart" show ListData;
import "/model/film_play_info/play_list.dart" show PlayList;
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
  final List<MyTab> _tabs = [
    MyTab(icon: const Icon(Icons.abc_outlined), label: '详情', key: UniqueKey()),
    MyTab(icon: const Icon(Icons.abc_outlined), label: '简介', key: UniqueKey()),
  ];

  Data? _data;
  int _originIndex = 0;
  int _teleplayIndex = 0;

  Future _fetchData() async {
    int id = widget.arguments?['id'];
    var historyContext = context.read<HistoryStore>();
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

      historyContext.addHistory({
        'id': _data?.detail?.id,
        "name": _data?.detail?.name,
        "timeStamp": DateTime.now().microsecondsSinceEpoch,
        "picture": _data?.detail?.picture
      });

      // print(_data.detail.name);
    } else {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        return _fetchData();
      }
    }
  }

  List<ListData?>? get _playList {
    return _data?.detail?.list;
  }

  PlayList? get _playItem {
    return _playList?[_originIndex]?.linkList?[_teleplayIndex];
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
      backgroundColor: Theme.of(context).primaryColorDark,
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
                    child: Player(
                      key: Key(
                          '${_playItem?.link}-$_originIndex-$_teleplayIndex'),
                      playItem: _playItem,
                      originIndex: _originIndex,
                      teleplayIndex: _teleplayIndex,
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
                    ),
                  ),
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
