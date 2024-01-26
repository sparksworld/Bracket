import 'package:bracket/model/film_detail/play_list.dart';
import 'package:bracket/plugins.dart';
import "package:chewie/chewie.dart";
import "package:video_player/video_player.dart";
import 'package:wakelock_plus/wakelock_plus.dart';

class Player extends StatefulWidget {
  final PlayList? data;
  const Player({Key? key, this.data}) : super(key: key);

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
      Uri.parse(widget.data?.link ?? ''),
    )
      ..addListener(_listener)
      ..initialize().then(
        (value) {
          var aspectRatio = _videoPlayerController?.value.aspectRatio;
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
            autoPlay: true,
            looping: true,
            aspectRatio: aspectRatio,
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
  void dispose() {
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values); //恢复
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
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
          AspectRatio(
            aspectRatio: 1.6,
            child: LoadingView(
              loading: _loading,
              builder: (ctx) {
                return Chewie(
                  key: widget.key,
                  controller: _chewieController!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
