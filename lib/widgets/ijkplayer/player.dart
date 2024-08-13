import 'package:bracket/model/film_play_info/detail.dart';
import 'package:bracket/model/film_play_info/list.dart';
import 'package:bracket/model/film_play_info/play_list.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'fijk_panel_3_builder.dart';
import 'fijk_util.dart';

import '/plugins.dart';
// import "package:chewie/chewie.dart";
// import "package:video_player/video_player.dart";
// import 'package:wakelock_plus/wakelock_plus.dart';

class Player extends StatefulWidget {
  const Player({
    super.key,
    required this.title,
    required this.list,
    required this.detail,
    required this.originIndex,
    required this.teleplayIndex,
    required this.startAt,
    required this.callback,
  });
  final Detail? detail;
  final List<Widget>? title;
  final int originIndex;
  final int teleplayIndex;
  final List<ListData?>? list;
  final int? startAt;
  final Function(int, int) callback;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final FijkPlayer player = FijkPlayer();
  // VideoPlayerController? _videoPlayerController;
  // ChewieController? _chewieController;
  final double _aspectRatio = 16 / 9;
  bool _loading = false;
  bool _error = false;
  bool _netWarning = false;
  String _errorMessage = '';

  List<PlayItem>? get _originPlayList {
    var list = widget.list;
    var originIndex = widget.originIndex;
    return list?[originIndex]?.linkList;
  } // list

  PlayItem? get _playItem {
    var teleplayIndex = widget.teleplayIndex;
    return _originPlayList?[teleplayIndex];
  }

  Future<void> _listener() async {}

  @override
  void initState() {
    super.initState();

    _setUrl(_playItem?.link ?? '');
    watchConnectivity(ConnectivityResult.mobile, () {
      setState(() {
        _netWarning = true;
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }

  @override
  void didUpdateWidget(covariant Player oldWidget) {
    var list = oldWidget.list;
    var originIndex = oldWidget.originIndex;
    var teleplayIndex = oldWidget.teleplayIndex;

    var playItem = list?[originIndex]?.linkList?[teleplayIndex];
    if (playItem?.link != _playItem?.link) {
      print(_playItem?.link);
      _setUrl(_playItem?.link ?? '');
    }
    super.didUpdateWidget(oldWidget);
  }

  Future _setUrl(String url) async {
    await player.reset();
    player.setDataSource(
      url,
      autoPlay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          // _chewieController?.play();
                        },
                        child: const Text('播放'),
                      ),
                    ],
                  ),
                )
              : _error
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error,
                          size: 48,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : _loading
                      ? const RiveLoading()
                      : FijkView(
                          color: Colors.black,
                          player: player,
                          panelBuilder: (FijkPlayer player, dynamic data,
                              BuildContext context, Size size, Rect rect) {
                            return FijkPanel3(
                              fill: true,
                              player: player,
                              data: data,
                              texPos: rect,
                              viewSize: size,
                            );
                          },
                        ),
          Positioned(
            child: Row(
              children: widget.title ?? [],
            ),
          )
        ],
      ),
    );
  }
}
