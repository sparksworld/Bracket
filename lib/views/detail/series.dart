import '/model/film_play_info/data.dart';
import '/model/film_play_info/detail.dart';
import '/model/film_play_info/list.dart';
import '/plugins.dart';

class Series extends StatefulWidget {
  final Data? data;

  const Series({
    super.key,
    required this.data,
  });

  @override
  State<Series> createState() => _SeriesState();
}

class _SeriesState extends State<Series> {
  _SeriesState();

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: list?[originIndex] != null
                          ? Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: linkList
                                  .mapIndexed((i, e) => FilterChip(
                                        shape: const RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        label: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 3),
                                          child: Text(
                                            '${linkList[i].episode}',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        onSelected: (bool value) {
                                          info.setVideoInfo(
                                            info.originIndex,
                                            teleplayIndex: i,
                                            startAt: 0,
                                          );
                                        },
                                        showCheckmark: false,
                                        selected: i == teleplayIndex,
                                      ))
                                  .toList(),
                            )
                          : const Center(
                              child: Text('暂无数据'),
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
