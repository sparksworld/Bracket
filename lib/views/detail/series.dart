import 'package:bracket/model/film_detail/data.dart';
import 'package:bracket/model/film_detail/detail.dart';
import 'package:bracket/model/film_detail/link_list.dart';
import 'package:bracket/model/film_detail/list.dart';
import 'package:bracket/model/film_detail/play_list.dart';
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

  Detail? get _detail {
    return widget.data?.detail;
  }

  List<OriginList>? get _originList {
    return _detail?.list ?? [];
  }

  List<LinkList> get _playList {
    return _originList?[_originIndex].linkList ?? [];
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
                segments: (_originList ?? [])
                    .mapIndexed(
                      (index, element) => ButtonSegment(
                        value: index,
                        label: Text(element.name ?? ''),
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
                        _playList.isNotEmpty
                            ? Wrap(
                                spacing: 6,
                                children: _playList
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
