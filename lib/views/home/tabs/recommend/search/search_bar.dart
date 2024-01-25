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
    return GestureDetector(
      onTap: () {
        showSearch(
          context: context,
          delegate: SearchPage(context),
        );
      },
      child: Container(
        // height: 50,
        decoration: const BoxDecoration(
          // color: Colors.red,
          // border: Border.all(
          //   color: Theme.of(context).colorScheme.primary,
          // ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '搜索视频',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
