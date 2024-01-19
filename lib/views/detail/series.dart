import 'package:bracket/model/film_detail/data.dart';
import 'package:bracket/model/film_detail/detail.dart';
import 'package:bracket/model/film_detail/play_list.dart';
import 'package:bracket/plugins.dart';

class Series extends StatefulWidget {
  final Data? data;
  const Series({Key? key, required this.data}) : super(key: key);

  @override
  State<Series> createState() => _SeriesState();
}

class _SeriesState extends State<Series> {
  int _originIndex = 0;
  int _teleplayIndex = 0;

  List<List<PlayList>?> get _playlist {
    return widget.data?.detail?.playList ?? [];
  }

  Detail? get _detail {
    return widget.data?.detail;
  }

  List<PlayList?> _playlistItem(i) {
    return _playlist[i] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data == null) {
      return Center(
        child: SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                _detail?.name ?? '',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
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
                });
              },
              segments: _playlist
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
                      _playlistItem(_originIndex).isNotEmpty
                          ? Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: _playlistItem(_originIndex)
                                  .mapIndexed(
                                    (i, e) => OutlinedButton(
                                      style: ButtonStyle(
                                        side: MaterialStateProperty.all(
                                          BorderSide(
                                            color: i == _teleplayIndex
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Theme.of(context)
                                                    .disabledColor,
                                            width: 2,
                                          ),
                                        ),
                                        foregroundColor: i == _teleplayIndex
                                            ? MaterialStateProperty.all<Color>(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              )
                                            : MaterialStateProperty.all<Color>(
                                                Theme.of(context).disabledColor,
                                              ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _teleplayIndex = i;
                                        });
                                      },
                                      child: Text(e?.episode ?? ''),
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
    );
  }
}
