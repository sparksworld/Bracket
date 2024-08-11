import '/model/film_play_info/data.dart';
import '/model/film_play_info/detail.dart';
import '/model/film_play_info/list.dart';
import '/plugins.dart';

class Series extends StatefulWidget {
  final Function(int, int) callback;
  final int initOriginIndex;
  final int initTeleplayIndex;
  final Data? data;
  const Series({
    Key? key,
    this.data,
    required this.callback,
    required this.initOriginIndex,
    required this.initTeleplayIndex,
  }) : super(key: key);

  @override
  State<Series> createState() => _SeriesState();
}

class _SeriesState extends State<Series> {
  _SeriesState();

  List<ListData>? get _playList {
    return widget.data?.detail?.list;
  }

  Detail? get _detail {
    return widget.data?.detail;
  }

  ListData? _playListItem(i) {
    return _playList?[i];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int originIndex = widget.initOriginIndex;
    int teleplayIndex = widget.initTeleplayIndex;
    return LoadingViewBuilder(
      loading: widget.data == null,
      builder: (_) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  _detail?.name ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  (_detail?.descriptor?.subTitle == "" ||
                          _detail?.descriptor?.subTitle == null)
                      ? '暂无数据'
                      : (_detail?.descriptor?.subTitle ?? '暂无数据'),
                  style: TextStyle(
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Divider(),
              const SizedBox(
                height: 12,
              ),
              if (_playList != null)
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 8,
                    children: _playList!.mapIndexed((i, e) {
                      return ChoiceChip(
                          label: Text(e.name ?? '未知源'),
                          selected: originIndex == i,
                          onSelected: (_) {
                            setState(() {
                              originIndex = i;
                              teleplayIndex = 0;
                              widget.callback(originIndex, teleplayIndex);
                            });
                          });
                    }).toList(),
                  ),
                ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _playListItem(originIndex) != null
                            ? Wrap(
                                spacing: 6,
                                children: _playListItem(originIndex)!
                                    .linkList!
                                    .mapIndexed((i, e) => ChoiceChip(
                                          label: Text(e.episode ?? ''),
                                          selected: i == teleplayIndex,
                                          onSelected: (value) {
                                            teleplayIndex = i;
                                            widget.callback(
                                              originIndex,
                                              teleplayIndex,
                                            );
                                          },
                                        ))
                                    .toList(),
                              )
                            : const Center(
                                child: Text('暂无数据'),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
