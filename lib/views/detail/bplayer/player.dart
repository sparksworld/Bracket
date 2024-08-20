import 'package:better_player/better_player.dart';
import '/model/film_play_info/detail.dart';

import '/plugins.dart';
import 'skin.dart';

class Player extends StatefulWidget {
  final double aspectRatio;
  final Detail? detail;
  const Player({super.key, required this.aspectRatio, this.detail});

  @override
  State createState() => _PlayerState();
}

class _PlayerState extends State<Player> with TickerProviderStateMixin {
  int _originIndex = -1;
  int _teleplayIndex = -1;
  late BetterPlayerController _betterPlayerController;
  PlayVideoIdsStore? _playVideoIdsStore;
  // GlobalKey _betterPlayerKey = GlobalKey();

  @override
  void initState() {
    _playVideoIdsStore = context.read<PlayVideoIdsStore>();
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      fit: BoxFit.contain,
      aspectRatio: widget.aspectRatio,
      autoDetectFullscreenDeviceOrientation: true,
      deviceOrientationsOnFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      autoPlay: true,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        playerTheme: BetterPlayerTheme.custom,
        customControlsBuilder: (BetterPlayerController controller, a) {
          return BetterPlayerMaterialControls(
            title: Text(
              widget.detail?.name ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onControlsVisibilityChanged: a,
            controlsConfiguration: BetterPlayerControlsConfiguration(
              loadingWidget: const RiveLoading(),
              overflowMenuCustomItems: [
                BetterPlayerOverflowMenuItem(Icons.abc, '下一首', _next),
              ],
              showControlsOnInitialize: true,
            ),
          );
        },
      ),
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.addEventsListener(_betterPlayerControllerListener);
    _playVideoIdsStore?.addListener(_changeDataSource);
    _changeDataSource();

    super.initState();
  }

  void _changeDataSource() {
    var list = widget.detail?.list;
    _playVideoIdsStore = context.read<PlayVideoIdsStore>();
    if (_originIndex != _playVideoIdsStore?.originIndex ||
        _teleplayIndex != _playVideoIdsStore?.teleplayIndex) {
      _originIndex = _playVideoIdsStore!.originIndex;
      _teleplayIndex = _playVideoIdsStore!.teleplayIndex;

      var url = list?[_originIndex].linkList?[_teleplayIndex].link;

      if (url != null) {
        BetterPlayerDataSource dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          url,
        );
        _betterPlayerController.setupDataSource(dataSource);
      }
    }
  }

  void _betterPlayerControllerListener(BetterPlayerEvent e) {
    var videoPlayerController = _betterPlayerController.videoPlayerController;
    var durationSeconds = videoPlayerController?.value.duration?.inSeconds;

    var cposSeconds = videoPlayerController?.value.position.inSeconds;

    if (durationSeconds != null && durationSeconds > 0) {
      if (cposSeconds == durationSeconds) _next();
    }
  }

  void _next() {
    _playVideoIdsStore = context.read<PlayVideoIdsStore>();
    var list = widget.detail?.list;
    var originIndex = _playVideoIdsStore?.originIndex;
    var teleplayIndex = _playVideoIdsStore?.teleplayIndex;
    var linkList = list?[originIndex!].linkList;
    var nextIndex = teleplayIndex! + 1;
    if (linkList != null) {
      if (nextIndex < linkList.length) {
        _playVideoIdsStore?.setVideoInfoTeleplayIndex(nextIndex);
      }
    }
  }

  @override
  void didChangeDependencies() {
    _playVideoIdsStore = context.read<PlayVideoIdsStore>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _betterPlayerController
        .removeEventsListener(_betterPlayerControllerListener);
    _playVideoIdsStore?.removeListener(_changeDataSource);
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Player oldWidget) {
    if (oldWidget.aspectRatio != widget.aspectRatio) {
      _betterPlayerController.setOverriddenAspectRatio(widget.aspectRatio);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: BetterPlayer(
        controller: _betterPlayerController,
      ),
    );
  }
}
