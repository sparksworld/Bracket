import 'package:bracket/model/film_classify_search/search.dart';
import 'package:bracket/plugins.dart';

class FilterBar extends StatelessWidget {
  final Map<String, dynamic>? activeMap;
  final Search? search;
  final Function onSearch;
  final bool loading;

  const FilterBar({
    Key? key,
    required this.search,
    required this.onSearch,
    required this.activeMap,
    required this.loading,
  }) : super(key: key);

  List<String>? get _sortList {
    return search?.sortList;
  }

  Map<String, dynamic> get _titles {
    Map<String, dynamic> map = {};
    var titles = search?.titles?.toJson();
    _sortList?.forEach(
      (e) {
        map[e] = titles?[e];
      },
    );
    return map;
  }

  Map<String, dynamic> get _tags {
    Map<String, dynamic> map = {};
    var jsonTags = search?.tags?.toJson();
    _sortList?.forEach((e) {
      map[e] = jsonTags?[e];
    });
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ..._tags.keys.map((key) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(_titles[key]),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 10,
                  children: _tags[key]?.map<ChoiceChip>((e) {
                    return ChoiceChip(
                      label: Text(
                        (e?.name ?? ''),
                      ),
                      selected: activeMap?[key]?.value == e?.value,
                      onSelected: !loading
                          ? (newValue) {
                              Map params = {};
                              activeMap?.forEach((k, v) {
                                params[k] = k == key ? e?.value : v?.value;
                              });
                              onSearch(params);
                            }
                          : null,
                    );
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
