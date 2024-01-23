import 'package:bracket/model/film_classify_search/film_classify_search.dart';
import 'package:bracket/model/film_classify_search/data.dart';
import 'package:bracket/views/home/tabs/classify/filter.dart';

import '/plugins.dart';
import 'dynamicSliverAppBar.dart';

class ClassifyTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppBarDemoState();
  }
}

class _AppBarDemoState extends State<ClassifyTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollViewController;
  Data? _data;

  Future _fetchData() async {
    var res = await Api.filmClassifySearch(queryParameters: {'Pid': 1});
    if (res != null) {
      FilmClassifySearch jsonData = FilmClassifySearch.fromJson(res);
      setState(() {
        _data = jsonData.data;
      });
    }
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            DynamicSliverAppBar(
              maxHeight: MediaQuery.of(context).size.height / 2,
              child: LoadingView(
                builder: (_) {
                  return Filter(data: _data);
                },
                loading: _data == null,
              ),
            ),
            new SliverFixedExtentList(
              itemExtent: 50.0,
              delegate: new SliverChildBuilderDelegate(
                (context, index) => new ListTile(
                  title: new Text("Item $index"),
                ),
                childCount: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
