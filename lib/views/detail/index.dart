import "package:bracket/model/film_detail/data.dart";
import "package:bracket/model/film_detail/film_detail.dart";
import "package:bracket/views/detail/describe.dart";
import 'package:bracket/plugins.dart';

import "series.dart";
// import "package:chewie/chewie.dart";
// import "package:collection/collection.dart";
// import "package:video_player/video_player.dart";

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
  // final videoPlayerController = VideoPlayerController.networkUrl(
  //   Uri.parse('https://v.cdnlz3.com/20240112/22741_4dec050c/index.m3u8'),
  // );
  // late ChewieController chewieController;
  // bool init = false;

  Data? _data;
  final List<MyTab> _tabs = [
    MyTab(icon: const Icon(Icons.abc_outlined), label: '详情', key: UniqueKey()),
    MyTab(icon: const Icon(Icons.abc_outlined), label: '简介', key: UniqueKey()),
    // MyTab(icon: const Icon(Icons.abc_outlined), label: '3', key: UniqueKey())
  ];

  Future _fetchData() async {
    int id = widget.arguments?['id'];
    var res = await Api.filmDetail(
      queryParameters: {
        'id': id,
      },
    );
    if (res != null) {
      FilmDetail jsonData = FilmDetail.fromJson(res);
      setState(() {
        _data = jsonData.data;
      });
    }
  }

  Future _initChewieController() async {
    // chewieController = ChewieController(
    //   videoPlayerController: videoPlayerController,
    //   aspectRatio: 1.6,
    //   autoPlay: true,
    //   looping: true,
    // );
    // setState(() {
    //   init = true;
    // });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    // _initChewieController();
  }

  @override
  void dispose() {
    // videoPlayerController.dispose();
    // chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: Container(
                // alignment: Alignment.topLeft,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: const AspectRatio(
                  aspectRatio: 1.6,
                  child: Text(''),
                ),
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
                              // icon: e.icon,
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
                            data: _data,
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
