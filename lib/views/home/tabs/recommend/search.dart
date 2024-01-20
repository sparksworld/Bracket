import 'package:bracket/model/search_film/list.dart';
import 'package:bracket/model/search_film/search_film.dart';
import 'package:bracket/plugins.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({Key? key}) : super(key: key);

  @override
  State<MySearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<MySearchBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSearch(
          context: context,
          delegate: Search(),
        );
      },
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Container(
                  // height: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '搜索视频',
                          style: TextStyle(
                            color: Theme.of(context).disabledColor,
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.fontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                  size: Theme.of(context).textTheme.headlineMedium?.fontSize,
                ),
                // tooltip: 'Comment Icon',
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: Search(),
                  );
                },
              ), //Ic
            )
          ],
        ),
      ),
    );
  }
}

class Search extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => '请输入视频名';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        // 点击把文本空的内容清空
        onPressed: () => query = "",
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
        close(context, query);
      },
    );
  }

  // 点击搜索出现结果
  @override
  Widget buildResults(BuildContext context) {
    return MyList(query: query.trim());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Global global = context.watch<Global>();
    final suggestionList = global.searchRecord;

    if (suggestionList.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 12,
          runSpacing: 6,
          children: suggestionList
              .map(
                (e) => OutlinedButton(
                  onPressed: () {
                    query = e;
                    showResults(context);
                  },
                  child: Text(e),
                ),
              )
              .toList(),
        ),
      );
    }
    return const Center(
      child: Text(
        '没有记录',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}

class MyList extends StatefulWidget {
  final String query;
  const MyList({Key? key, required this.query}) : super(key: key);

  @override
  State<MyList> createState() => _SearchState();
}

class _SearchState extends State<MyList> {
  bool _loading = false;
  final ScrollController _scrollController = ScrollController();
  List<VideoList> _list = [];
  int _current = 1;
  int _total = 0;

  Future<void> _fetchData() async {
    Global global = context.read<Global>();
    if (_loading) return;
    setState(() {
      _loading = true;
    });
    var res = await Api.searchFilm(
        queryParameters: {'keyword': widget.query, 'current': _current});

    global.setSearchRecord(widget.query);
    if (res != null) {
      SearchFilm jsonData = SearchFilm.fromJson(res);
      setState(() {
        _loading = false;
        _current = jsonData.data?.page?.current ?? 1;
        _total = jsonData.data?.page?.total ?? 0;
        if (_current == 1) {
          _list = jsonData.data?.list ?? [];
        } else {
          _list.addAll(jsonData.data?.list ?? []);
        }
        if (_list.length < _total) _current = _current + 1;
      });
    } else {
      _loading = false;
    }
  }

  @override
  void initState() {
    // page = 1;
    _fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //滚动到最后请求更多
        _fetchData();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(6),
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (index < _list.length) {
          var item = _list[index];
          return searchItemView(item);
        }

        return _loadMoreWidget(_list);
      },
      itemCount: _list.length + 1,
    );
  }

  Widget _loadMoreWidget(list) {
    return Align(
      heightFactor: 2,
      alignment: Alignment.center,
      child: _loading
          ? const CircularProgressIndicator()
          : list.length == _total
              ? const Text('暂无更多数据')
              : const Text('上拉加载'),
    );
  }

  Widget searchItemView(item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            MYRouter.detailPagePath,
            arguments: {
              'id': item.id,
            },
          );
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 100,
                  height: 150,
                  child: Image(
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext _, Widget widget,
                        ImageChunkEvent? event) {
                      if (event == null) {
                        return widget;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: event.expectedTotalBytes != null
                              ? event.cumulativeBytesLoaded /
                                  event.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    width: double.infinity,
                    height: double.infinity,
                    image: NetworkImage(
                      item.picture ?? '',
                    ),
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Image.asset(
                        'assets/images/placeholder.png',
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name ?? '',
                        softWrap: true,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        item.blurb ?? '',
                        softWrap: true,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
