import 'package:bracket/model/film_detail/play_list.dart';
import 'package:bracket/plugins.dart';
import 'package:bracket/chewie/chewie.dart';
// import 'package:fijkplayer/fijkplayer.dart';

import "package:video_player/video_player.dart";
import 'package:wakelock_plus/wakelock_plus.dart';

class PlayerVideo extends StatefulWidget {
  const PlayerVideo({
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
  State<PlayerVideo> createState() => _PlayerState();
}

class _PlayerState extends State<PlayerVideo> {
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
    // player.setDataSource(widget.playItem?.link ?? '', autoPlay: true);
    setState(() {
      _loading = true;
    });

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse('https://www.w3schools.com/html/mov_bbb.mp4'),
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
                    return Scaffold(
                      appBar: AppBar(
                        title: Text('12121'),
                      ),
                      body: controllerProvider,
                    );
                  });
            },
            deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
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
                : Chewie(
                    key: widget.key,
                    controller: _chewieController!,
                  ),
          ),
        ],
      ),
    );
  }
}
