import 'package:bracket/model/film_detail/play_list.dart';
import 'package:bracket/plugins.dart';
import "package:chewie/chewie.dart";
// import 'package:fijkplayer/fijkplayer.dart';

import "package:video_player/video_player.dart";
import 'package:wakelock_plus/wakelock_plus.dart';
import './video_builder.dart';

class Player extends StatefulWidget {
  const Player({
    super.key,
    this.playItem,
    this.onNext,
    this.onPrev,
    required this.originIndex,
    required this.teleplayIndex,
  });

  final PlayList? playItem;
  final int originIndex;
  final int teleplayIndex;
  final Function? onNext;
  final Function? onPrev;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  bool _loading = true;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  Future<void> _listener() async {
    bool isWakelockUp = await WakelockPlus.enabled;
    if (_videoPlayerController!.value.isPlaying && !isWakelockUp) {
      WakelockPlus.enable();
    }
  }

  @override
  void initState() {
    setState(() {
      _loading = true;
    });

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.playItem?.link ?? ''),
    )
      ..addListener(_listener)
      ..initialize().then(
        (value) {
          var aspectRatio = _videoPlayerController?.value.aspectRatio;
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
            allowFullScreen: true,
            autoPlay: true,
            looping: true,
            aspectRatio: aspectRatio,
            routePageBuilder:
                (context, animation, secondaryAnimation, controllerProvider) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return VideoBuilder(controllerProvider: controllerProvider);
                },
              );
            },
            // deviceOrientationsAfterFullScreen: [
            //   DeviceOrientation.portraitUp,
            //   DeviceOrientation.portraitDown
            // ],
          );
          setState(() {
            _loading = false;
          });
        },
      );
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    WakelockPlus.disable();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    // player.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1.6,
            child: _loading
                ? const RiveLoading()
                : Theme(
                    data: Theme.of(context).copyWith(
                      platform: TargetPlatform.android,
                    ),
                    child: Chewie(
                      key: widget.key,
                      controller: _chewieController!,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
