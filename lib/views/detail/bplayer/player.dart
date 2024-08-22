import 'package:better_player/better_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
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
  // final _throttler = Throttler(milliseconds: 1000);

  @override
  void initState() {
    _playVideoIdsStore = context.read<PlayVideoIdsStore>();
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      fit: BoxFit.contain,
      allowedScreenSleep: true,
      aspectRatio: widget.aspectRatio,
      fullScreenAspectRatio: widget.fullScreenAspectRatio,
      autoDetectFullscreenDeviceOrientation: false,
      autoDetectFullscreenAspectRatio: false,
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
      startAt: Duration(seconds: _playVideoIdsStore?.startAt ?? 0),
      autoPlay: true,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        playerTheme: BetterPlayerTheme.custom,
        customControlsBuilder: (BetterPlayerController controller, visibility) {
          var list = widget.detail?.list;
          var originIndex = _playVideoIdsStore?.originIndex ?? 0;
          var teleplayIndex = _playVideoIdsStore?.teleplayIndex ?? 0;
          var linkList = list?[originIndex].linkList;

          bool hasNext = teleplayIndex < linkList!.length - 1;
          bool hasPrev = teleplayIndex > 0;

          return BetterPlayerMaterialControls(
            title: Text(
              '${widget.detail?.name ?? ''}-${linkList[teleplayIndex].episode ?? ''}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onControlsVisibilityChanged: visibility,
            onPrev: hasPrev ? _prev : null,
            onNext: hasNext ? _next : null,
            controlsConfiguration: const BetterPlayerControlsConfiguration(
              // loadingWidget: RiveLoading(),
              showControlsOnInitialize: true,
            ),
          );
        },
      ),
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      getCurrentUrl() ?? '',
    );
    _betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: dataSource,
    );

    // _betterPlayerController
    //     ?.seekTo(Duration(seconds: _playVideoIdsStore?.startAt ?? 0));

    _betterPlayerController?.addEventsListener(_betterPlayerControllerListener);
    _playVideoIdsStore?.addListener(_changeDataSource);

    super.initState();
  }

  String? getCurrentUrl() {
    var list = widget.detail?.list;
    _playVideoIdsStore = context.read<PlayVideoIdsStore>();
    _originIndex = _playVideoIdsStore!.originIndex;
    _teleplayIndex = _playVideoIdsStore!.teleplayIndex;

    String? url = list?[_originIndex!].linkList?[_teleplayIndex!].link;

    return url;
  }

  void _changeDataSource() {
    var url = getCurrentUrl();

    if (url != null) {
      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        url,
      );

      _betterPlayerController?.setupDataSource(dataSource).then((value) {
        var playVideoIdsStore = context.read<PlayVideoIdsStore>();
        _betterPlayerController
            ?.seekTo(Duration(seconds: playVideoIdsStore.startAt));
      });
    }
  }

  void _betterPlayerControllerListener(BetterPlayerEvent e) async {
    var isPlaying = _betterPlayerController?.isPlaying() == true;

    if (isPlaying) {
      _setHistroy();
      bool isEnabled = await WakelockPlus.enabled;
      if (!isEnabled) WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
  }

  void _prev() {
    _playVideoIdsStore = context.read<PlayVideoIdsStore>();
    var originIndex = _playVideoIdsStore?.originIndex;
    var teleplayIndex = _playVideoIdsStore?.teleplayIndex;

    var prevIndex = teleplayIndex! - 1;
    _playVideoIdsStore?.setVideoInfo(
      originIndex,
      teleplayIndex: prevIndex,
      startAt: 0,
    );
  }

  void _next() {
    _playVideoIdsStore = context.read<PlayVideoIdsStore>();
    var originIndex = _playVideoIdsStore?.originIndex;
    var teleplayIndex = _playVideoIdsStore?.teleplayIndex;
    var nextIndex = teleplayIndex! + 1;

    _playVideoIdsStore?.setVideoInfo(
      originIndex,
      teleplayIndex: nextIndex,
      startAt: 0,
    );
  }

  void _setHistroy() {
    _playVideoIdsStore = context.read<PlayVideoIdsStore>();
    var videoPlayerController = _betterPlayerController?.videoPlayerController;
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

  @override
  void didChangeDependencies() {
    _playVideoIdsStore = context.read<PlayVideoIdsStore>();
    super.didChangeDependencies();
    // context.dependOnInheritedWidgetOfExactType();
  }

  @override
  void dispose() {
    _betterPlayerController
        ?.removeEventsListener(_betterPlayerControllerListener);
    _playVideoIdsStore?.removeListener(_changeDataSource);
    _betterPlayerController?.dispose();
    // _throttler.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Player oldWidget) {
    super.didUpdateWidget(oldWidget);

    // if (oldWidget.detail != widget.detail) {
    //   _changeDataSource();
    // }

    if (oldWidget.aspectRatio != widget.aspectRatio) {
      _betterPlayerController?.setOverriddenAspectRatio(widget.aspectRatio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(controller: _betterPlayerController!);
  }
}
