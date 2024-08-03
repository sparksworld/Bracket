import 'package:bracket/model/film_play_info/play_list.dart';
import 'package:bracket/plugins.dart';
import "package:bracket/chewie/chewie.dart";
// import 'package:fijkplayer/fijkplayer.dart';

import "package:video_player/video_player.dart";
import 'package:wakelock_plus/wakelock_plus.dart';
import './video_builder.dart';

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
  final String? title;
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
  bool _loading = true;

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
            title: widget.title,
            videoPlayerController: _videoPlayerController!,
            allowFullScreen: true,
            autoPlay: true,
            looping: false,
            showControlsOnInitialize: false,
            aspectRatio: aspectRatio,
            // showOptions: false,
            errorBuilder: (context, errorMessage) {
              return Center(
                child: Text('Error: $errorMessage'),
              );
            },
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
            deviceOrientationsAfterFullScreen: [
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown
            ],
            deviceOrientationsOnEnterFullScreen: [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight
            ],
          );
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
      DeviceOrientation.portraitDown,
    ]);
    WakelockPlus.disable();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          OrientationBuilder(builder: (context, orientation) {
            var chewie = _chewieController != null
                ? Theme(
                    data: Theme.of(context).copyWith(
                      platform: TargetPlatform.android,
                    ),
                    child: Chewie(
                      controller: _chewieController!,
                    ))
                : const RiveLoading();
            if (orientation == Orientation.portrait) {
              return AspectRatio(
                aspectRatio: 1.6,
                child: chewie,
              );
            }
            return chewie;
          }),
          Positioned(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  child: Text(
                    widget.title ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
