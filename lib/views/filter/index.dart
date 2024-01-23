// import 'package:bracket/model/film_classify_search/params.dart';

// import 'package:flutter/cupertino.dart';

import '/plugins.dart';
import 'package:bracket/model/film_classify_search/film_classify_search.dart';
import 'package:bracket/model/film_classify_search/search.dart';
import 'package:bracket/model/film_classify_search/data.dart';

import 'dynamic_sliver_appbar.dart';
import 'filter_bar.dart';

class FilterPage extends StatefulWidget {
  final Map? arguments;

  const FilterPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FilterPageState();
  }
}

class _FilterPageState extends State<FilterPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  Data? _data;
  bool _loading = false;

  List<dynamic> _list = [];
  int _current = 1;
  int _total = 0;
  Map? _request = {};
  // Search? _search;
  // Params? _params;

  Search? get _search {
    return _data?.search;
  }

  List<String>? get _sortList {
    return _search?.sortList;
  }

  Map<String, dynamic> get _params {
    var params = _data?.params?.toJson();
    Map<String, dynamic> map = {};
    _sortList?.forEach(
      (e) {
        map[e] = params?[e];
      },
    );
    return map;
  }

  Map<String, dynamic>? get _tags {
    Map<String, dynamic> map = {};
    var jsonTags = _search?.tags?.toJson();
    _sortList?.forEach((e) {
      var value = _params[e];
      map[e] = jsonTags?[e].firstWhere((e) => e?.value == value);
    });
    return map;
  }

  Future _fetchData() async {
    int pid = widget.arguments?['pid'];

    if (_loading) return;
    setState(() {
      _loading = true;
    });

    var res = await Api.filmClassifySearch(queryParameters: {
      'Pid': pid,
      'current': _current,
      ...?_request,
    });
    if (res != null) {
      FilmClassifySearch jsonData = FilmClassifySearch.fromJson(res);
      setState(() {
        _loading = false;
        _data = jsonData.data;

        _current = jsonData.page?.current ?? 1;
        _total = jsonData.page?.total ?? 0;

        if (_current == 1) {
          _list = _data?.list ?? [];
          if (_scrollController.hasClients) _scrollController.jumpTo(0);
        } else {
          _list.addAll(_data?.list ?? []);
        }

        print(_list.length);
        if (_list.length < _total) _current = _current + 1;
      });
    }
  }

  @override
  void initState() {
    _fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels + 30 >=
          _scrollController.position.maxScrollExtent) {
        _fetchData();
      }
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              DynamicSliverAppBar(
                maxHeight: MediaQuery.of(context).size.height / 2,
                bottom: AppBar(
                  title: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 10,
                      children: [
                        ..._tags!.keys.map(
                          (e) => ChoiceChip(
                            label: Text(_tags?[e].name ?? "全部"),
                            selected: false,
                            onSelected: (_) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                child: FilterBar(
                  activeMap: _tags,
                  search: _search,
                  onSearch: (Map? params) {
                    setState(() {
                      _current = 1;
                      _request = params;
                    });
                    _fetchData();
                  },
                ),
              ),
              // CupertinoSliverRefreshControl(
              //   onRefresh: () async {
              //     setState(() {
              //       _current = 1;
              //     });
              //     await _fetchData();
              //   },
              // ),
              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      var movie = _list[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            MYRouter.detailPagePath,
                            arguments: {
                              'id': movie?.id,
                            },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getMovieGridContent(context, movie),
                            getMovieGridFooter(context, movie)
                          ],
                        ),
                      );
                    },
                    childCount: _list.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: .65,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _loadMoreWidget();
                  },
                  childCount: 1,
                ),
              )
            ],
          ),
          onRefresh: () async {
            setState(() {
              _current = 1;
            });
            await _fetchData();
          },
        ),
      ),
    );
  }

  Widget _loadMoreWidget() {
    return Align(
      heightFactor: 2,
      alignment: Alignment.center,
      child: _loading
          ? SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          : _list.length == _total
              ? const Text('暂无更多数据')
              : const Text('上拉加载'),
    );
  }
}

Widget getMovieGridHeader(BuildContext context, content) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          content?.nav?.name ?? '',
          // style: Theme.of(context).textTheme.titleLarge,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(MYRouter.filterPagePath,
                arguments: {'pid': content?.nav?.id});
          },
          child: Row(
            children: [
              Text(
                '查看更多',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: Theme.of(context).textTheme.bodyMedium?.fontSize,
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget getMovieGridContent(BuildContext context, movie) => Expanded(
      flex: 1,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey,
            ),
            child: Image(
              fit: BoxFit.cover,
              loadingBuilder:
                  (BuildContext _, Widget widget, ImageChunkEvent? event) {
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
                movie?.picture ?? '',
              ),
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset(
                  'assets/images/placeholder.png',
                );
              },
            ),
          ),
          Positioned(
            top: 6,
            left: 6,
            right: 6,
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withAlpha(200),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      movie?.year ?? '',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize:
                            Theme.of(context).textTheme.bodySmall?.fontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withAlpha(200),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      movie?.cName ?? '',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize:
                            Theme.of(context).textTheme.bodySmall?.fontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withAlpha(200),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      movie?.remarks ?? '',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize:
                            Theme.of(context).textTheme.bodySmall?.fontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

Widget getMovieGridFooter(BuildContext context, movie) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie?.name ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            (movie?.subTitle?.trim().isEmpty ?? true)
                ? '暂无'
                : movie?.subTitle?.trim() ?? '暂无',
            style: TextStyle(
              color: Theme.of(context).disabledColor,
              fontSize: 10,
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 2,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
