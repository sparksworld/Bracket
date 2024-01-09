import '/plugins.dart';

class Recommend extends StatefulWidget {
  const Recommend({super.key});

  @override
  State createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {
  List tabbars = [
    {'title': '推荐', 'typeKey': 0},
    {'title': '资讯', 'typeKey': 1},
    {'title': '搞笑', 'typeKey': 2},
    {'title': '段子', 'typeKey': 3},
    {'title': '科技', 'typeKey': 4},
    {'title': '汽车', 'typeKey': 5},
    {'title': '医疗', 'typeKey': 6},
    {'title': '便民', 'typeKey': 7},
    {'title': '三农', 'typeKey': 8},
  ];

  final List _shuffling = [
    "一少女惨遭八名壮汉轮流让座",
    "一少女惨遭八名壮汉轮流让座",
    "一少女惨遭八名壮汉轮流让座",
    "一少女惨遭八名壮汉轮流让座",
    "一少女惨遭八名壮汉轮流让座"
  ];
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();

    // timer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void timer() {
    Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeIn,
      );
    });
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

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // ElevatedButton(
              //   // style: TextStyle(color: Color.red),
              //   onPressed: () {
              //     if (global.theme == ITheme.dark.value) {
              //       global.setTheme(ITheme.light.value);
              //     } else {
              //       global.setTheme(ITheme.dark.value);
              //     }
              //   },
              //   child: const Text('ElevatedButton'),
              // ),
              FloatingActionButton(
                onPressed: () {
                  print('dawdawdwa');
                },
                child: const Text('FloatingActionButton'),
              ),
              MaterialButton(
                onPressed: () {
                  print('dawdawdwa');
                },
                child: const Text('MaterialButton'),
              ),
              TextButton(
                onPressed: () {
                  print(232323232);
                },
                child: const Text('TextButton'),
              ),
              // ButtonBar(
              //   overflowButtonSpacing: 12,
              //   children: [
              //     OutlinedButton(
              //       onPressed: () {
              //         Navigator.pushNamed(context, MYRouter.settingPath);
              //       },
              //       style: OutlinedButton.styleFrom(
              //           minimumSize: const Size(200, 50)),
              //       child: const Text('设置'),
              //     ),
              //     OutlinedButton(
              //       onPressed: () {
              //         // profile.clearUser();
              //       },
              //       style: OutlinedButton.styleFrom(
              //           minimumSize: const Size(200, 50)),
              //       child: const Text('测试'),
              //     ),
              //   ],
              // ),
              SizedBox(
                width: 100.px,
                child: Text(token ?? ''),
              )
            ],
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
