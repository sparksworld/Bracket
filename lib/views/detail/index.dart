import "package:bracket/model/film_play_info/detail.dart";
// import "package:flutter/material.dart";

import '/plugins.dart';
import "/model/film_play_info/data.dart" show Data;
import "/model/film_play_info/film_play_info.dart" show FilmPlayInfo;
// import "/model/film_play_info/list.dart" show ListData;
// import "/model/film_play_info/play_list.dart" show PlayItem;
import "/views/detail/describe.dart" show Describe;
import "bplayer/player.dart" show Player;

import "series.dart";

class DetailPage extends StatefulWidget {
  final Map? arguments;
  const DetailPage({super.key, this.arguments});

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

  Future _fetchData(id) async {
    var playIdsInfo = context.read<PlayVideoIdsStore>();
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

      var originId = item?['originId'];
      var originIndex =
          _data?.detail?.list?.indexWhere((element) => originId == element.id);

      if (originIndex != null && originIndex >= 0) {
        playIdsInfo.setVideoInfo(
          originIndex,
          teleplayIndex: item?['teleplayIndex'],
          startAt: item?['startAt'],
        );
      } else {
        playIdsInfo.setVideoInfo(0, teleplayIndex: 0, startAt: 0);
      }

      // print(context.read<VideoInfoStore>().info.toString());
      // getHistory(id);
    }
  }

  Map<String, dynamic>? getHistory(id) {
    var data = context.read<HistoryStore>().data;
    var item = data.firstWhereOrNull((element) => element['id'] == id);

    return item;
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
    Detail? detail = _data?.detail;
    // List<ListData?>? list = detail?.list;
    // PlayVideoIdsStore playVideoIdsStore = context.watch<PlayVideoIdsStore>();
    // int? originIndex = playVideoIdsStore.originIndex;
    // int? teleplayIndex = playVideoIdsStore.teleplayIndex;
    // PlayItem? playItem = list?[originIndex]?.linkList?[teleplayIndex];

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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        Size size = MediaQuery.of(context).size;
                        double width = constraints.maxWidth;
                        double height = constraints.maxHeight;
                        double aspectRatio = orientation == Orientation.portrait
                            ? _playerAspectRatio
                            : width / height;
                        double fullScreenAspectRatio = size.width / size.height;

                        return AspectRatio(
                          aspectRatio: aspectRatio,
                          child: Player(
                            aspectRatio: aspectRatio,
                            fullScreenAspectRatio: fullScreenAspectRatio,
                            detail: detail,
                          ),
                        );
                      },
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
                              Series(data: _data),
                              Describe(data: _data),
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
