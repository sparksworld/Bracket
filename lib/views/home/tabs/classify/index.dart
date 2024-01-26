import 'package:bracket/model/index/data.dart';

import '/plugins.dart';

class ClassifyTab extends StatefulWidget {
  const ClassifyTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ClassifyTabState();
  }
}

class _ClassifyTabState extends State<ClassifyTab>
    with AutomaticKeepAliveClientMixin {
  // late TabController _tabController;
  late ScrollController _scrollViewController;
  Data? _data;
  bool _loading = false;
  // bool _error = false;

  // List<Content> get _content {
  //   return _data?.content ?? [];
  // }

  Future _fetchData() async {
    setState(() {
      _loading = true;
      // _error = false;
    });
    var res = await Api.index();

    if (res != null && res != '') {
      Recommend jsonData = Recommend.fromJson(res);
      setState(() {
        _loading = false;
        _data = jsonData.data;
      });
    } else {
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _loading = false;
      });
      await _fetchData();
    }
    // return true;
  }

  @override
  void initState() {
    _fetchData();
    // _tabController = TabController(length: 6, vsync: this);
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
    // _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              // foregroundColor: Colors.red,
              pinned: true,
              floating: true,
              expandedHeight: 100.0,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: const Text(
                    '影片分类',
                  ),
                  background: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            // const SliverAppBar(
            //   title: Text('分类'),
            //   centerTitle: true,
            //   floating: true,
            //   pinned: true,
            // ),
          ];
        },
        body: LoadingView(
          loading: _loading,
          builder: (_) => MediaQuery.removePadding(
            removeTop: true,
            context: context,
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
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  MYRouter.filterPagePath,
                                  arguments: {
                                    "pid": e.id,
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
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
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SingleChildScrollView(
                                    child: Wrap(
                                      spacing: 8,
                                      // runSpacing: 2,
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
                                                  },
                                                );
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
