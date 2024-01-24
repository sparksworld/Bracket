import 'package:bracket/model/film_classify_search/data.dart';
import 'package:bracket/model/film_classify_search/film_classify_search.dart';
import 'package:bracket/model/film_classify_search/search.dart';
import 'package:bracket/plugins.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Data? _data;

  Search? get _search {
    return _data?.search;
  }

  List<String>? get _sortList {
    return _search?.sortList;
  }

  Map<String, dynamic> get _titles {
    Map<String, dynamic> map = {};
    var titles = _search?.titles?.toJson();
    _sortList?.forEach(
      (e) {
        map[e] = titles?[e];
        // e: titles?[e],
      },
    );
    return map;
  }

  Map<String, dynamic> get _tags {
    Map<String, dynamic> map = {};
    var jsonTags = _search?.tags?.toJson();
    _sortList?.forEach((e) {
      map[e] = jsonTags?[e];
    });
    return map;
  }

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
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LoadingView(
        loading: true,
        builder: (ctx) {
          return Column(children: [
            ..._tags.keys.map((e) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(_titles[e]),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 10,
                        children: _tags[e]?.map<Chip>((a) {
                          return Chip(label: Text((a?.name ?? '')));
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ]);
        },
      ),
    );
  }
}
