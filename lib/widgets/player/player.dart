import '/model/film_play_info/play_list.dart';
import '/plugins.dart';
import "/chewie/chewie.dart";
import '/widgets/rcplayer/video_player_bottom.dart';
import '/widgets/rcplayer/video_player_gestures.dart';
import '/widgets/rcplayer/video_player_top.dart';
// import 'package:fijkplayer/fijkplayer.dart';

import "package:video_player/video_player.dart";
import 'package:wakelock_plus/wakelock_plus.dart';
import './video_builder.dart';
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
  final double _aspectRatio = 16 / 9;
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
    super.initState();

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
            aspectRatio: aspectRatio ?? _aspectRatio,
            // showOptions: false,
            customControls: const PlayerControl(),
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
          !_loading
              ? Theme(
                  data: Theme.of(context).copyWith(
                    platform: TargetPlatform.android,
                  ),
                  child: Chewie(
                    controller: _chewieController!,
                  ),
                )
              : const RiveLoading(),
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
