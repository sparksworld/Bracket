import 'package:bracket/store/recommend/content.dart';
import 'package:bracket/store/recommend/data.dart';
import '/plugins.dart';
import './search.dart';
import './movies.dart';
import './swiper.dart';

class RecommendTab extends StatefulWidget {
  const RecommendTab({super.key});

  @override
  State<RecommendTab> createState() => _RecommendTabState();
}

class _RecommendTabState extends State<RecommendTab> {
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();
  final PageController _pageController = PageController();
  List<Content> _listContent = [];

  @override
  void initState() {
    super.initState();
    // _fetchData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //关键代码，直接触发下拉刷新
      _refreshKey.currentState?.show();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> _fetchData() async {
    var res = await Api.index();

    if (res != null) {
      Recommend jsonData = Recommend.fromJson(res);
      Data data = jsonData.data ?? const Data();

      setState(() {
        _refreshKey = GlobalKey();
        _listContent = data.content ?? [];
      });
    }

    return Future.value(true);
  }

  void timer() {
    Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeIn,
      );
    });
  }

  List<Widget> getHomeGrid(List<Content> list) {
    if (list.isNotEmpty) {
      return list
          .map<Widget>(
            (Content content) => MovieGrid(
              content: content,
            ),
          )
          .toList();
    }
    return [
      const Center(
        child: Text('正在加载'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('推荐'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Comment Icon',
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchBar(),
              );
            },
          ), //IconButton
        ],
      ),
      body: Consumer2<Profile, Global>(
        builder: (_, profile, global, child) {
          String? token = profile.user?.userToken;

          return RefreshIndicator(
            key: _refreshKey,
            onRefresh: _fetchData,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: const MySwiper(),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ...getHomeGrid(_listContent)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
