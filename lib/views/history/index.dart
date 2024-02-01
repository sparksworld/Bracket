import 'package:bracket/plugins.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var histryStore = context.watch<HistoryStore>();
    var list = histryStore.data;
    return Scaffold(
      appBar: AppBar(
        title: const Text('历史记录'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: list.isNotEmpty
              ? ListView.builder(
                  // itemExtent: 100,
                  itemBuilder: (context, index) {
                    var item = list[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).splashColor,
                          width: 1,
                        ),
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        minVerticalPadding: 12,
                        tileColor: Theme.of(context).colorScheme.surface,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            MYRouter.detailPagePath,
                            arguments: {
                              'id': item["id"],
                            },
                          );
                        },
                        title: Text(
                          item['name'] ?? '',
                        ),
                        subtitle: Text(
                          "观看时间：${DateScope.getDateScope(checkDate: item['timeStamp'])}",
                          style: TextStyle(
                            color: Theme.of(context).disabledColor,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 4,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MyDialog(
                                  title: '提示',
                                  content: '是否删除播放记录',
                                  onConfirm: () async {
                                    histryStore.deleteHistoryForId(item['id']);
                                  },
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.delete),
                        ),
                        leading: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey,
                          ),
                          width: 100,
                          height: double.infinity,
                          child: Image(
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext _, Widget widget,
                                ImageChunkEvent? event) {
                              if (event == null) {
                                return widget;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: event.expectedTotalBytes != null
                                      ? event.cumulativeBytesLoaded /
                                          event.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            image: NetworkImage(
                              item['picture'] ?? '',
                            ),
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return Image.asset(
                                fit: BoxFit.cover,
                                'assets/images/logo.png',
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: list.length,
                )
              : const Center(
                  child: Text('暂无数据'),
                ),
        ),
      ),
    );
  }
}
