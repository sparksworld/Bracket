import 'package:better_player/better_player.dart';
import '/model/film_play_info/detail.dart';

import '/plugins.dart';
import 'skin.dart';

class Player extends StatefulWidget {
  final double aspectRatio;
  final double fullScreenAspectRatio;
  final Detail? detail;
  const Player(
      {super.key,
      required this.aspectRatio,
      this.detail,
      required this.fullScreenAspectRatio});

  @override
  State createState() => _PlayerState();
}

class _PlayerState extends State<Player> with TickerProviderStateMixin {
  int? _originIndex;
  int? _teleplayIndex;
  // bool _ischanging = false;
  BetterPlayerController? _betterPlayerController;
  PlayVideoIdsStore? _playVideoIdsStore;

  @override
  void initState() {
    _playVideoIdsStore = context.read<PlayVideoIdsStore>();
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      fit: BoxFit.contain,
      allowedScreenSleep: false,
      aspectRatio: widget.aspectRatio,
      fullScreenAspectRatio: widget.fullScreenAspectRatio,
      autoDetectFullscreenDeviceOrientation: true,
      autoDetectFullscreenAspectRatio: true,
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
        customControlsBuilder: (BetterPlayerController controller, visibility) {
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
            onControlsVisibilityChanged: visibility,
            onPrev: _prev,
            onNext: _next,
            controlsConfiguration: const BetterPlayerControlsConfiguration(
              loadingWidget: RiveLoading(),
              showControlsOnInitialize: true,
            ),
          );
        },
      ),
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);

    _playVideoIdsStore?.addListener(_changeDataSource);

    super.initState();
  }

  void _changeDataSource() {
    var list = widget.detail?.list;
    _playVideoIdsStore = context.read<PlayVideoIdsStore>();
    _originIndex = _playVideoIdsStore!.originIndex;
    _teleplayIndex = _playVideoIdsStore!.teleplayIndex;

    // if (_originIndex != _playVideoIdsStore?.originIndex ||
    //     _teleplayIndex != _playVideoIdsStore?.teleplayIndex) {
    String? url = list?[_originIndex!].linkList?[_teleplayIndex!].link;

    // print(url);
    if (url != null) {
      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        url,
      );
      _betterPlayerController?.setupDataSource(dataSource).then((value) {
        _betterPlayerController
            ?.addEventsListener(_betterPlayerControllerListener);
        _betterPlayerController
            ?.seekTo(Duration(seconds: _playVideoIdsStore?.startAt ?? 0));
        // _ischanging = false;
      });
    }
    // }
  }

  void _betterPlayerControllerListener(BetterPlayerEvent e) {
    var initialized = _betterPlayerController?.isVideoInitialized();
    if (initialized == null) return;
    if (initialized) {
      var bool = _betterPlayerController?.isPlaying();
      if (bool ?? false) {
        _playVideoIdsStore = context.read<PlayVideoIdsStore>();
        var videoPlayerController =
            _betterPlayerController?.videoPlayerController;
        var detail = widget.detail;
        var list = detail?.list;
        var teleplayIndex = _playVideoIdsStore?.teleplayIndex ?? 0;
        var originIndex = _playVideoIdsStore?.originIndex ?? 0;

        var position = videoPlayerController?.value.position.inSeconds;

        context.read<HistoryStore>().addHistory({
          'id': detail?.id,
          "name": detail?.name,
          "timeStamp": DateTime.now().microsecondsSinceEpoch,
          "picture": detail?.picture,
          "originId": list?[originIndex].id,
          "teleplayIndex": teleplayIndex,
          'startAt': position,
        });
      }
    }
  }

  void _prev() {
    _playVideoIdsStore = context.read<PlayVideoIdsStore>();
    var list = widget.detail?.list;
    var originIndex = _playVideoIdsStore?.originIndex;
    var teleplayIndex = _playVideoIdsStore?.teleplayIndex;
    var linkList = list?[originIndex!].linkList;
    var prevIndex = teleplayIndex! - 1;

    if (linkList != null) {
      if (prevIndex >= 0) {
        _playVideoIdsStore?.setVideoInfo(
          originIndex,
          teleplayIndex: prevIndex,
          startAt: 0,
        );
      }
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
        _playVideoIdsStore?.setVideoInfo(
          originIndex,
          teleplayIndex: nextIndex,
          startAt: 0,
        );
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
        ?.removeEventsListener(_betterPlayerControllerListener);
    _playVideoIdsStore?.removeListener(_changeDataSource);
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Player oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.detail != widget.detail) {
      _changeDataSource();
    }

    if (oldWidget.aspectRatio != widget.aspectRatio) {
      _betterPlayerController?.setOverriddenAspectRatio(widget.aspectRatio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BetterPlayer(controller: _betterPlayerController!),
        BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
