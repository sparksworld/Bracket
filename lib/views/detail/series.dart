import '/model/film_play_info/data.dart';
import '/model/film_play_info/detail.dart';
import '/model/film_play_info/list.dart';
// import "/model/film_play_info/play_list.dart" show PlayItem;
import '/plugins.dart';

class Series extends StatefulWidget {
  final Data? data;

  // final Function(int, int) callback;
  // final int initOriginIndex;
  // final int initTeleplayIndex;
  const Series({
    Key? key,
    required this.data,

    // required this.callback,
    // required this.initOriginIndex,
    // required this.initTeleplayIndex,
  }) : super(key: key);

  @override
  State<Series> createState() => _SeriesState();
}

class _SeriesState extends State<Series> {
  _SeriesState();

  // Detail? get detail {
  //   Data? info = context.watch<VideoInfoStore>().info;
  //   return info?.detail;
  // }

  // List<ListData>? get playList {
  //   return detail?.list;
  // }

  // ListData? playListItem(i) {
  //   return playList?[i];
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Detail? detail = widget.data?.detail;
    List<ListData?>? list = detail?.list;
    int? originIndex = context.watch<PlayVideoIdsStore>().originIndex;
    int? teleplayIndex = context.watch<PlayVideoIdsStore>().teleplayIndex;
    // PlayItem? playItem = list?[originIndex]?.linkList?[teleplayIndex];

    return LoadingViewBuilder(
      loading: list == null,
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
                  detail?.name ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  (detail?.descriptor?.subTitle == "" ||
                          detail?.descriptor?.subTitle == null)
                      ? '暂无数据'
                      : (detail?.descriptor?.subTitle ?? '暂无数据'),
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
              if (list != null)
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 8,
                    children: list.mapIndexed((i, e) {
                      return ChoiceChip(
                          label: Text(e?.name ?? '未知源'),
                          selected: originIndex == i,
                          onSelected: (_) {
                            context
                                .read<PlayVideoIdsStore>()
                                .setVideoInfoOriginIndex(i);

                            // setState(() {
                            //   originIndex = i;
                            //   teleplayIndex = 0;
                            // });
                            // widget.callback(originIndex, teleplayIndex);
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
                        list?[originIndex] != null
                            ? Wrap(
                                spacing: 6,
                                children: list?[originIndex]
                                        ?.linkList!
                                        .mapIndexed((i, e) => ChoiceChip(
                                              label: Text(e.episode ?? ''),
                                              selected: i == teleplayIndex,
                                              onSelected: (value) {
                                                context
                                                    .read<PlayVideoIdsStore>()
                                                    .setVideoInfoTeleplayIndex(
                                                        i);
                                              },
                                            ))
                                        .toList() ??
                                    [],
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
