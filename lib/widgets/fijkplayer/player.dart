import 'package:fijkplayer/fijkplayer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '/model/film_play_info/list.dart';
import '/model/film_play_info/detail.dart';
import '/plugins.dart';
import 'skin.dart';

class Player extends StatefulWidget {
  const Player({
    super.key,
    this.detail,
    this.title,
    required this.originIndex,
    required this.teleplayIndex,
    this.list,
    this.startAt,
    required this.callback,
    // required this.aspectRatio,
  });

  final Detail? detail;
  final List<Widget>? title;
  final int originIndex;
  final int teleplayIndex;
  final List<ListData?>? list;
  final int? startAt;
  final Function(int, int) callback;

  @override
  State createState() => _PlayerState();
}

class _PlayerState extends State<Player> with WidgetsBindingObserver {
  final FijkPlayer player = FijkPlayer();
  final throttle = Throttle(milliseconds: 1000);
  final double _aspectRatio = 16 / 9;

  bool _loading = true;
  bool _error = false;
  bool _changing = false;
  bool _netWarning = false;

  String _errorMessage = '';

  get link {
    var list = widget.list;
    var originIndex = widget.originIndex;
    var teleplayIndex = widget.teleplayIndex;
    var originPlayList = list?[originIndex]?.linkList;
    var playItem = originPlayList?[teleplayIndex];
    return playItem?.link;
  }

  @override
  void initState() {
    super.initState();

    changeSource(link);

    // player.addListener(_fijkValueListener);

    // player.onBufferPosUpdate.listen(_currentPosUpdate);
    WidgetsBinding.instance.addObserver(this);
  }

  void changeSource(String? link) async {
    if (link == null) return;
    setState(() {
      _loading = true;
      _error = false;
    });
    await player.reset();
    watchConnectivity(ConnectivityResult.mobile, (bool bool) {
      setState(() {
        _netWarning = bool;
      });
      player.onCurrentPosUpdate.listen(_currentPosUpdate);
      player
          .setDataSource(
        link,
        autoPlay: !bool,
        showCover: true,
      )
          .then(
        (value) {
          _changing = false;
          setState(() {
            _loading = false;
            _error = false;
          });
        },
      ).catchError((err) {
        setState(() {
          _loading = false;
          _error = true;
          _errorMessage = err.message;
        });
      });
    });
  }

  void _currentPosUpdate(Duration event) async {
    if (event.toString() == player.value.duration.toString() &&
        event.inSeconds > 0) {
      var originIndex = widget.originIndex;
      var teleplayIndex = widget.teleplayIndex;
      var linkList = widget.list?[originIndex]?.linkList!;

      if (linkList != null &&
          teleplayIndex < linkList.length - 1 &&
          !_changing) {
        widget.callback(originIndex, teleplayIndex + 1);
        _changing = true;
      }
    }
    throttle.run(() {
      if (mounted) {
        var list = widget.list;
        var detail = widget.detail;
        var teleplayIndex = widget.teleplayIndex;
        var originIndex = widget.originIndex;

        context.read<HistoryStore>().addHistory({
          'id': detail?.id,
          "name": detail?.name,
          "timeStamp": DateTime.now().microsecondsSinceEpoch,
          "picture": detail?.picture,
          "originId": list?[originIndex]?.id,
          "teleplayIndex": teleplayIndex,
          'startAt': event.inMilliseconds,
        });
      }
    });

    bool isWakelockUp = await WakelockPlus.enabled;
    if (!isWakelockUp) WakelockPlus.enable();
  }

  // void _fijkValueListener() {
  //   FijkValue value = player.value;

  //   if (value.prepared) {
  //     player.seekTo(widget.startAt ?? 0);
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    WakelockPlus.disable();
    // player.removeListener(_fijkValueListener);
    player.release();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // 应用进入后台
      await player.pause();
    } else if (state == AppLifecycleState.resumed) {
      // 应用从后台恢复
      await player.start();
    }
  }

  @override
  void didUpdateWidget(covariant Player oldWidget) {
    super.didUpdateWidget(oldWidget);

    var list = oldWidget.list;
    var originIndex = oldWidget.originIndex;
    var teleplayIndex = oldWidget.teleplayIndex;
    var originPlayList = list?[originIndex]?.linkList;
    var playItem = originPlayList?[teleplayIndex];

    if (playItem?.link != link) {
      changeSource(link ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    var originIndex = widget.originIndex;
    var teleplayIndex = widget.teleplayIndex;
    var linkList = widget.list?[originIndex]?.linkList!;
    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: Stack(
        children: [
          _netWarning
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('未检测到wifi,是否继续播放?'),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _netWarning = false;
                          });
                          player.start();
                        },
                        child: const Text('播放'),
                      ),
                    ],
                  ),
                )
              : _loading
                  ? const RiveLoading()
                  : FijkView(
                      color: Colors.black,
                      player: player,
                      cover: NetworkImage(
                        widget.detail?.picture ?? '',
                      ),
                      panelBuilder: fijkPanel3Builder(
                        fullScreenTitle: Row(
                          children: widget.title ?? [],
                        ),
                        fill: true,
                        onPrev: teleplayIndex > 0
                            ? () {
                                widget.callback(originIndex, teleplayIndex - 1);
                              }
                            : null,
                        onNext: linkList != null &&
                                teleplayIndex < linkList.length - 1
                            ? () {
                                widget.callback(originIndex, teleplayIndex + 1);
                              }
                            : null,
                      ),
                    ),
          Positioned(
            child: Row(
              children: widget.title ?? [],
            ),
          ),
        ],
      ),
    );
  }
}
