import 'package:bracket/model/index/child.dart';
import 'package:bracket/plugins.dart';
import 'search_page.dart';

class SearchAppBar extends StatefulWidget {
  final List<Child>? tags;
  final double height;
  const SearchAppBar({Key? key, this.tags, required this.height})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  Iterable<Child>? _getFilterTag() {
    return widget.tags
        ?.where((element) => element.name != "" || element.name != null);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 0,
            child: GestureDetector(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: SearchPage(context),
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container(
                  height: 50,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search,
                                // color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '搜索视频',
                                style: TextStyle(
                                  // color: Theme.of(context).colorScheme.primary,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.fontSize,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    children: _getFilterTag()?.isNotEmpty ?? false
                        ? _getFilterTag()!
                            .map<ChoiceChip>(
                              (e) => ChoiceChip(
                                label: Text(e.name ?? ''),
                                selected: false,
                                onSelected: (value) {
                                  Navigator.of(context).pushNamed(
                                      MYRouter.filterPagePath,
                                      arguments: {"pid": e.id});
                                },
                              ),
                            )
                            .toList()
                        : [],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
