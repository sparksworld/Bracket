import 'package:bracket/model/index/data.dart';
import 'package:bracket/model/index/content.dart';

import '/plugins.dart';
// import './search.dart';
import './movies.dart';
import './swiper.dart';
import './search.dart';

class RecommendTab extends StatefulWidget {
  const RecommendTab({super.key});

  @override
  State<RecommendTab> createState() => _RecommendTabState();
}

class _RecommendTabState extends State<RecommendTab> {
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();
  Data? _data;
  bool _loading = false;

  List<Content> get _content {
    return _data?.content ?? [];
  }

  Future<bool> _fetchData() async {
    setState(() {
      _loading = true;
    });
    var res = await Api.index();

    if (res != null) {
      Recommend jsonData = Recommend.fromJson(res);
      setState(() {
        _loading = false;
        _data = jsonData.data;
        _refreshKey = GlobalKey();
      });
    }

    return true;
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
    return const Center(
      child: Text('暂无数据'),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //关键代码，直接触发下拉刷新
      _refreshKey.currentState?.show();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MySearchBar(),
      ),
      body: Consumer2<Profile, Global>(
        builder: (_, profile, global, child) {
          // String? token = profile.user?.userToken;

          return RefreshIndicator(
            key: _refreshKey,
            onRefresh: _fetchData,
            child: LoadingView(
              loading: _loading,
              builder: (_) => SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 12,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: const MySwiper(),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    getHomeGrid(_content)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
