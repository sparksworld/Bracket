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
    super.key,
    required this.data,

    // required this.callback,
    // required this.initOriginIndex,
    // required this.initTeleplayIndex,
  });

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
    var info = context.watch<PlayVideoIdsStore>();
    Detail? detail = widget.data?.detail;
    List<ListData?>? list = detail?.list;
    int? originIndex = info.originIndex;
    int? teleplayIndex = info.teleplayIndex;
    var linkList = list?[originIndex]?.linkList ?? [];
    // PlayItem? playItem = list?[originIndex]?.linkList?[teleplayIndex];

    return LoadingViewBuilder(
      loading: list == null,
      builder: (_) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
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
              // const SizedBox(
              //   height: 12,
              // ),
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
                                .setVideoInfo(i, teleplayIndex: 0, startAt: 0);
                          });
                    }).toList(),
                  ),
                ),
              const SizedBox(
                height: 12,
              ),
              Column(
                children: [
                  Card(
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
                                  runSpacing: 6,
                                  children: linkList
                                      .mapIndexed((i, e) => FilterChip(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            shape: const RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                            label: SizedBox(
                                              width: double.infinity,
                                              height: 36,
                                              child: Center(
                                                child: Text(
                                                  linkList[i].episode ?? '无',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            onSelected: (bool value) {
                                              info.setVideoInfo(
                                                info.originIndex,
                                                teleplayIndex: i,
                                                startAt: 0,
                                              );
                                            },
                                            selected: i == teleplayIndex,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
