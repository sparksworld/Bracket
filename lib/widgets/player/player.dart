import '/plugins.dart';
import "package:chewie/chewie.dart";
import "package:video_player/video_player.dart";
import 'package:wakelock_plus/wakelock_plus.dart';
import '/model/film_play_info/play_list.dart';
import 'video_builder.dart';
import 'player_control.dart';

class Player extends StatefulWidget {
  const Player({
    super.key,
    this.title,
    this.playItem,
    this.onNext,
    this.onPrev,
    required this.originIndex,
    required this.teleplayIndex,
  });
  final List<Widget>? title;
  final PlayList? playItem;
  final int originIndex;
  final int teleplayIndex;
  final Function? onNext;
  final Function? onPrev;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  final double _aspectRatio = 16 / 9;
  bool _loading = true;
  bool _netWarning = false;

  Future<void> _listener() async {
    if (_videoPlayerController!.value.isPlaying) {
      bool isWakelockUp = await WakelockPlus.enabled;
      if (!isWakelockUp) WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
  }

  @override
  void initState() {
    super.initState();

    initPlayer();
    watchConnectivity(ConnectivityResult.mobile, () {
      setState(() {
        _netWarning = true;
      });
    });
  }

  void initPlayer() async {
    setState(() {
      _loading = true;
    });

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.playItem?.link ?? ''),
    )
      ..addListener(_listener)
      ..initialize().then(
        (value) {
          setState(() {
            _loading = false;
          });

          var aspectRatio = _videoPlayerController?.value.aspectRatio;
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
            allowFullScreen: true,
            autoPlay: !_netWarning,
            looping: false,
            showControlsOnInitialize: false,
            aspectRatio: aspectRatio ?? _aspectRatio,
            playbackSpeeds: Platform.isIOS
                ? [
                    0.5,
                    1,
                    1.5,
                    2,
                  ]
                : [0.5, 1, 1.5, 2, 2.5, 3],
            // showOptions: false,
            customControls: PlayerControl(title: widget.title),
            errorBuilder: (context, errorMessage) {
              return Center(
                child: Text('Error: $errorMessage'),
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
            routePageBuilder:
                (context, animation, secondaryAnimation, controllerProvider) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return VideoBuilder(
                    controllerProvider: controllerProvider,
                  );
                },
              );
            },
          );
        },
      );
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
              : _loading
                  ? const RiveLoading()
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
