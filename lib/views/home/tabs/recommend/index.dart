// import '/model/index/child.dart';
import '/model/index/data.dart';
import '/model/index/content.dart';
import '/views/home/tabs/recommend/search/search_bar.dart';
import '/views/home/tabs/recommend/test.dart';
// import 'search/sliver_search_app_bar.dart';

import '/plugins.dart';
// import './search.dart';
import './movies.dart';
// import './swiper.dart';
// import 'search_test.dart';

class RecommendTab extends StatefulWidget {
  const RecommendTab({super.key});

  @override
  State<RecommendTab> createState() => _RecommendTabState();
}

class _RecommendTabState extends State<RecommendTab>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();
  UniqueKey _imgKey = UniqueKey();
  Data? _data;
  bool _error = false;

  List<Content> get _content {
    return _data?.content ?? [];
  }

  Future _fetchData() async {
    setState(() {
      _error = false;
    });
    var res = await Api.index(
      context: context,
    );

    if (res != null && res.runtimeType != String) {
      Recommend jsonData = Recommend.fromJson(res);
      setState(() {
        _imgKey = UniqueKey();
        _data = jsonData.data;
      });
    } else {
      setState(
        () {
          _error = true;
        },
      );
    }
  }

  Widget getHomeGrid(List<Content> list) {
    if (list.isNotEmpty) {
      return Column(
        children: list
            .map(
              (Content content) => MovieGrid(content: content, imgKey: _imgKey),
            )
            .toList(),
      );
    }
    return const Center();
  }

  @override
  void initState() {
    // _fetchData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //关键代码，直接触发下拉刷新
      _refreshKey.currentState?.show();
    });
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverPersistentHeader(
                delegate: SearchHeader(
                  title: '推荐',
                  search: const SearchAppBar(
                    height: 44,
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: RefreshIndicator(
            key: _refreshKey,
            child: Consumer2<UserStore, ThemeStore>(
              builder: (_, profile, global, child) {
                // String? token = profile.user?.userToken;
                if (_error) {
                  return Error(
                    onRefresh: () {
                      _refreshKey.currentState?.show();
                    },
                  );
                }

                return SingleChildScrollView(
                  child: getHomeGrid(_content),
                );
              },
            ),
            onRefresh: () async {
              return await _fetchData();
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
