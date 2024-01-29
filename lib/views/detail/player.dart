import 'package:bracket/model/film_detail/play_list.dart';
import 'package:bracket/plugins.dart';
import "package:chewie/chewie.dart";
// import "package:video_player/video_player.dart";
import 'package:video_viewer/video_viewer.dart';
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
            autoPlay: true,
            looping: true,
            aspectRatio: aspectRatio,
            deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
            subtitle: Subtitles([]),
            // additionalOptions: (context) {
            //   return <OptionItem>[
            //     OptionItem(
            //       onTap: () => debugPrint('My option works!'),
            //       iconData: Icons.chat,
            //       title: 'My localized title',
            //     ),
            //     OptionItem(
            //       onTap: () => debugPrint('Another option working!'),
            //       iconData: Icons.chat,
            //       title: 'Another localized title',
            //     ),
            //   ];
            // },
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
