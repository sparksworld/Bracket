import 'package:bracket/model/film_play_info/detail.dart';
import 'package:bracket/model/film_play_info/list.dart';
import 'package:bracket/model/film_play_info/play_list.dart';

import '/plugins.dart';
import "package:chewie/chewie.dart";
import "package:video_player/video_player.dart";
import 'package:wakelock_plus/wakelock_plus.dart';
import 'video_builder.dart';
import 'player_control.dart';

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
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  double _aspectRatio = 16 / 9;
  bool _loading = true;
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

  Future<void> _listener() async {
    var detail = widget.detail;
    var teleplayIndex = widget.teleplayIndex;
    var originIndex = widget.originIndex;
    var duration = _videoPlayerController?.value.duration.inSeconds;
    var position = _videoPlayerController?.value.position.inSeconds;

    if (_videoPlayerController!.value.isPlaying) {
      var list = widget.list;
      context.read<HistoryStore>().addHistory({
        'id': detail?.id,
        "name": detail?.name,
        "timeStamp": DateTime.now().microsecondsSinceEpoch,
        "picture": detail?.picture,
        "originId": list?[originIndex]?.id,
        "teleplayIndex": teleplayIndex,
        'startAt': position,
      });

      if (duration == position) {
        if (teleplayIndex < _originPlayList!.length - 1) {
          //  _videoPlayerController
          _videoPlayerController?.removeListener(_listener);
          widget.callback(originIndex, teleplayIndex + 1);
        }
      }

      bool isWakelockUp = await WakelockPlus.enabled;
      if (!isWakelockUp) WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
  }

  @override
  void initState() {
    super.initState();

    _initPlayer();

    watchConnectivity(ConnectivityResult.mobile, () {
      setState(() {
        _netWarning = true;
      });
    });
  }

  Future<void> _initPlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
        _playItem?.link ?? '',
      ),
    )..addListener(_listener);
    _initChewieController();
  }

  void _initChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      allowFullScreen: true,
      autoPlay: true,
      looping: false,
      autoInitialize: true,
      startAt: Duration(seconds: widget.startAt ?? 0),
      showControlsOnInitialize: true,
      // aspectRatio: _aspectRatio,
      // playbackSpeeds: Platform.isIOS
      //     ? [
      //         0.5,
      //         1,
      //         1.5,
      //         2,
      //       ]
      //     : [0.5, 1, 1.5, 2, 2.5, 3],
      customControls: PlayerControl(
        // list: widget.list,
        title: widget.title,
        onPrev: () {
          var originIndex = widget.originIndex;
          var teleplayIndex = widget.teleplayIndex;
          if (teleplayIndex > 0) {
            widget.callback(originIndex, teleplayIndex - 1);
          }
        },
        onNext: _next,
      ),
      errorBuilder: (_, errorMessage) {
        return SnackBar(
          content: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              width: double.maxFinite,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Text(errorMessage),
            ),
          ),
        );
      },
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      // routePageBuilder:
      //     (context, animation, secondaryAnimation, controllerProvider) {
      //   return AnimatedBuilder(
      //     animation: animation,
      //     builder: (context, child) {
      //       return child!;
      //     },
      //     child: VideoBuilder(
      //       controllerProvider: controllerProvider,
      //     ),
      //   );
      // },
    );
  }

  Future<void> _next() async {
    final videoPlayerController = _videoPlayerController;
    if (videoPlayerController == null) return;
    if (videoPlayerController.value.hasError) return;
    if (!videoPlayerController.value.isInitialized) return;

    var teleplayIndex = widget.teleplayIndex;
    var originIndex = widget.originIndex;
    if (teleplayIndex < _originPlayList!.length - 1) {
      widget.callback(originIndex, teleplayIndex + 1);
    }
    videoPlayerController.dispose();
    await _initPlayer();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  // @override
  // void didUpdateWidget(covariant Player oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   var teleplayIndex = oldWidget.teleplayIndex;
  //   var originIndex = oldWidget.originIndex;
  //   if (teleplayIndex < _originPlayList!.length - 1) {
  //     oldWidget.callback(originIndex, teleplayIndex + 1);
  //   }

  //   if (widget.originIndex != originIndex ||
  //       widget.teleplayIndex != teleplayIndex) {
  //     // _videoPlayerController?.dispose();
  //     // _initPlayer();
  //     print(originIndex);
  //     print(teleplayIndex);
  //   }
  // }

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
                          _chewieController?.play();
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
                  : Chewie(
                      controller: _chewieController!,
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
