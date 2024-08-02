import 'package:bracket/model/film_play_info/data.dart';
import 'package:bracket/model/film_play_info/detail.dart';
import 'package:bracket/model/film_play_info/play_list.dart';
import 'package:bracket/plugins.dart';

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
  State<Series> createState() =>
      _SeriesState(initOriginIndex, initTeleplayIndex);
}

class _SeriesState extends State<Series> {
  int _originIndex;
  int _teleplayIndex;

  _SeriesState(this._originIndex, this._teleplayIndex);

  List<List<PlayList>?>? get _playList {
    return widget.data?.detail?.playList ?? [];
  }

  Detail? get _detail {
    return widget.data?.detail;
  }

  List<PlayList?> _playListItem(i) {
    return _playList?[i] ?? [];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              SegmentedButton(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onSelectionChanged: (value) {
                  setState(() {
                    _originIndex = value.first;
                    _teleplayIndex = 0;
                    widget.callback(_originIndex, _teleplayIndex);
                  });
                },
                segments: (_playList ?? [])
                    .mapIndexed(
                      (index, element) => ButtonSegment(
                        value: index,
                        label: Text('源${index + 1}'),
                      ),
                    )
                    .toList(),
                selected: {
                  _originIndex,
                },
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _playListItem(_originIndex).isNotEmpty
                            ? Wrap(
                                spacing: 6,
                                children: _playListItem(_originIndex)
                                    .mapIndexed(
                                      (i, e) => ChoiceChip(
                                        label: Text(e?.episode ?? ''),
                                        selected: i == _teleplayIndex,
                                        onSelected: (value) {
                                          _teleplayIndex = i;
                                          widget.callback(
                                            _originIndex,
                                            _teleplayIndex,
                                          );
                                        },
                                      ),
                                    )
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
