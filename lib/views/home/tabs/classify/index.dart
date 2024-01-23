import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:bracket/model/index/content.dart';
import 'package:bracket/model/index/data.dart';

import '/plugins.dart';

class ClassifyTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClassifyTabState();
  }
}

class _ClassifyTabState extends State<ClassifyTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollViewController;
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

    if (res != null) {
      Recommend jsonData = Recommend.fromJson(res);
      setState(() {
        _loading = false;
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

  @override
  void initState() {
    _fetchData();
    _tabController = TabController(length: 6, vsync: this);
    _scrollViewController = ScrollController();
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
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            const SliverAppBar(
              title: Text('分类'),
              centerTitle: true,
              floating: true,
              pinned: true,
            ),
          ];
        },
        body: RefreshIndicator(
          child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                children: [
                  Column(
                    children: [
                      ...?_data?.category?.children!.map(
                        (e) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                e.name ?? '',
                                // style: Theme.of(context).textTheme.titleLarge,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.fontSize,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SingleChildScrollView(
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      alignment: WrapAlignment.start,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      children: e.children!
                                          .map(
                                            (item) => ChoiceChip(
                                              label: Text(item.name ?? ''),
                                              selected: false,
                                              onSelected: (newValue) {
                                                Navigator.of(context).pushNamed(
                                                    MYRouter.filterPagePath,
                                                    arguments: {
                                                      "pid": e.id,
                                                      "category": item.id
                                                    });
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          onRefresh: () async {
            await _fetchData();
          },
        ),
      ),
    );
  }
}
