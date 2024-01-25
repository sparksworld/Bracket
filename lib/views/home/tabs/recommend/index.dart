// import 'package:bracket/model/index/child.dart';
import 'package:bracket/model/index/data.dart';
import 'package:bracket/model/index/content.dart';
import 'package:bracket/views/home/tabs/recommend/search/search_bar.dart';
import 'package:bracket/views/home/tabs/recommend/test.dart';
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
  Data? _data;
  bool _loading = false;
  bool _error = false;

  List<Content> get _content {
    return _data?.content ?? [];
  }

  // List<Child>? get _tags {
  //   List<Child>? children = _data?.category?.children;
  //   return children;
  // }

  Future _fetchData() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    var res = await Api.index();
    // var a = json.decode(res);
    // print(res['data']['category']);

    if (res != null) {
      Recommend jsonData = Recommend.fromJson(res);
      setState(() {
        _loading = false;
        // _refreshKey = GlobalKey();
        _data = jsonData.data;
      });
    } else {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _error = true;
        _loading = false;
        // _refreshKey = GlobalKey();
      });
      await _fetchData();
    }
  }

  Widget getHomeGrid(List<Content> list) {
    if (list.isNotEmpty) {
      return Column(
        children: list
            .map(
              (Content content) => MovieGrid(
                content: content,
              ),
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
      body: NestedScrollView(
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
          child: SingleChildScrollView(
            child: Consumer2<Profile, Global>(
              builder: (_, profile, global, child) {
                // String? token = profile.user?.userToken;
                if (_error) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '网络出错了～，请刷新重试',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () {
                              _fetchData();
                            },
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              child: Text('刷新'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                // if (_loading) {
                //   return Center(
                //     child: CircularProgressIndicator(
                //       strokeWidth: 2,
                //       valueColor: AlwaysStoppedAnimation<Color>(
                //         Theme.of(context).colorScheme.primary,
                //       ),
                //     ),
                //   );
                // }

                return getHomeGrid(_content);
              },
            ),
          ),
          onRefresh: () async {
            return await _fetchData();
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
