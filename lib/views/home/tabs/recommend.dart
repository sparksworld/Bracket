import 'package:bracket/store/recommend/content.dart';
import 'package:bracket/store/recommend/data.dart';
import 'package:bracket/store/recommend/movie.dart';
// import 'package:bracket/store/recommend/movie.dart';
import '/plugins.dart';

class RecommendTab extends StatefulWidget {
  const RecommendTab({super.key});

  @override
  State<RecommendTab> createState() => _RecommendState();
}

class _RecommendState extends State<RecommendTab> {
  late PageController _pageController;
  // late Recommend _fetchData;

  List<Content> _listContent = [];
  // late Iterable<List<Movie>?> _movies = [];

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    var res = await Api.index();

    if (res != null) {
      Recommend jsonData = Recommend.fromJson(res);
      Data data = jsonData.data ?? const Data();

      setState(() {
        _listContent = data.content ?? [];
      });
    }
  }

  void timer() {
    Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeIn,
      );
    });
  }

  List<Widget> getMovieGrid(List<Content> list) {
    if (list.isNotEmpty) {
      return list
          .map<Widget>(
            (Content? content) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(content?.nav?.name ?? ''),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(10.0),
                  itemCount: content?.movies?.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: .8,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    // print(content?.movies?.length);
                    var movie = content?.movies?[index];
                    return Image.network(
                      movie?.picture ?? '',
                      fit: BoxFit.cover,
                    );
                  },
                ),
                // ...?content?.movies?.map<Widget>((e) => Text('data')).toList(),
              ],
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
              showSearch(context: context, delegate: SearchBar());
            },
          ), //IconButton
        ],
      ),
      body: Consumer2<Profile, Global>(
        builder: (_, profile, global, child) {
          String? token = profile.user?.userToken;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: getMovieGrid(_listContent),
            ),
          );
        },
      ),
    );
  }
}

class SearchBar extends SearchDelegate<String> {
  // 点击清楚的方法
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        // 点击把文本空的内容清空
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  // 点击箭头返回
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        // 使用动画效果返回
        icon: AnimatedIcons.menu_arrow, progress: transitionAnimation,
      ),
      // 点击的时候关闭页面（上下文）
      onPressed: () {
        close(context, '1');
      },
    );
  }

  // 点击搜索出现结果
  @override
  Widget buildResults(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Card(
        color: Colors.pink,
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  // 搜索下拉框提示的方法
  @override
  Widget buildSuggestions(BuildContext context) {
    // 定义变量 并进行判断
    final suggestionList = [];
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: RichText(
              text: TextSpan(
                // 获取搜索框内输入的字符串，设置它的颜色并让让加粗
                text: suggestionList[index].substring(0, query.length),
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      //获取剩下的字符串，并让它变成灰色
                      text: suggestionList[index].substring(query.length),
                      style: const TextStyle(color: Colors.grey))
                ],
              ),
            ),
          );
        });
  }
}
