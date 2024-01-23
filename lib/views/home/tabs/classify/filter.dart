import 'package:bracket/model/film_classify_search/data.dart';
import 'package:bracket/model/film_classify_search/search.dart';
import 'package:bracket/plugins.dart';

class Filter extends StatelessWidget {
  final Data? data;
  const Filter({Key? key, this.data}) : super(key: key);

  Search? get _search {
    return data?.search;
  }

  List<String>? get sortList {
    return _search?.sortList;
  }

  Map<String, dynamic> get titles {
    Map<String, dynamic> map = {};
    var titles = _search?.titles?.toJson();
    sortList?.forEach(
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
    sortList?.forEach((e) {
      map[e] = jsonTags?[e];
    });
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ..._tags.keys.map((e) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(titles[e]),
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
  }
}
