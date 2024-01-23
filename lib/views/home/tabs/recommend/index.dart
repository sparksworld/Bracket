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
  bool _error = false;

  List<Content> get _content {
    return _data?.content ?? [];
  }

  Future<bool> _fetchData() async {
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
        _refreshKey = GlobalKey();
        _data = jsonData.data;
      });
    } else {
      setState(() {
        _error = true;
        _loading = false;
        _data = null;
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
    _fetchData();
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          // leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
          title: const MySearchBar(),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),

      // extendBodyBehindAppBar: true, // <--- こ
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(50),
      //   child: AppBar(
      //     // toolbarHeight: 100,
      //     flexibleSpace: Image.network(
      //       // <-- ここで指定します。
      //       'https://images.unsplash.com/photo-1513407030348-c983a97b98d8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1352&q=80',
      //       fit: BoxFit.cover,
      //     ),
      //     title: const MySearchBar(),
      //   ),
      // ),
      body: Consumer2<Profile, Global>(
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
