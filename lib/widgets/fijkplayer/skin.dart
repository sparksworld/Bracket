import 'package:fijkplayer/fijkplayer.dart';

import '/plugins.dart';
import 'data.dart';
import 'duration2string.dart';
import 'percentage.dart';

FijkPanelWidgetBuilder fijkPanel3Builder({
  Key? key,
  final bool fill = false,
  final int duration = 4000,
  final bool doubleTap = true,
  final bool snapShot = false,
  final VoidCallback? onBack,
  final Widget? fullScreenTitle,
  final Function? onPrev,
  final Function? onNext,
}) {
  return (FijkPlayer player, dynamic data, BuildContext context, Size viewSize,
      Rect texturePos) {
    return _FijkPanel3(
      key: key,
      player: player,
      data: data,
      onBack: onBack,
      viewSize: viewSize,
      texPos: texturePos,
      fill: fill,
      doubleTap: doubleTap,
      snapShot: snapShot,
      hideDuration: duration,
      fullScreenTitle: fullScreenTitle,
      onPrev: onPrev,
      onNext: onNext,
    );
  };
}

class _FijkPanel3 extends StatefulWidget {
  final FijkPlayer player;
  final FijkData data;
  final VoidCallback? onBack;
  final Size viewSize;
  final Rect texPos;
  final bool fill;
  final bool doubleTap;
  final bool snapShot;
  final int hideDuration;

  final Widget? fullScreenTitle;
  final Function? onPrev;
  final Function? onNext;

  const _FijkPanel3({
    super.key,
    required this.player,
    required this.data,
    this.fill = false,
    this.onBack,
    required this.viewSize,
    this.hideDuration = 4000,
    this.doubleTap = false,
    this.snapShot = false,
    this.fullScreenTitle,
    required this.texPos,
    this.onPrev,
    this.onNext,
  }) : assert(hideDuration > 0 && hideDuration < 10000);

  @override
  __FijkPanel3State createState() => __FijkPanel3State();
}

class __FijkPanel3State extends State<_FijkPanel3> {
  FijkPlayer get player => widget.player;

  Timer? _hideTimer;
  bool _hideStuff = true;

  Timer? _statelessTimer;
  bool _prepared = false;
  bool _playing = false;
  bool _dragLeft = false;
  double? _volume;
  double? _brightness;

  double _speed = 1.0;
  double _seekPos = -1.0;
  Duration _duration = const Duration();
  Duration _currentPos = const Duration();
  Duration _bufferPos = const Duration();

  StreamSubscription? _currentPosSubs;
  StreamSubscription? _bufferPosSubs;

  late StreamController<double> _valController;

  final PercentageWidget _percentageWidget = PercentageWidget();

  // snapshot
  ImageProvider? _imageProvider;
  Timer? _snapshotTimer;

  // Is it needed to clear seek data in FijkData (widget.data)
  bool _needClearSeekData = true;

  static const FijkSliderColors sliderColors = FijkSliderColors(
      cursorColor: Color.fromARGB(240, 250, 100, 10),
      playedColor: Color.fromARGB(200, 240, 90, 50),
      baselineColor: Colors.white,
      bufferedColor: Color.fromARGB(180, 200, 200, 200));

  @override
  void initState() {
    super.initState();

    _valController = StreamController.broadcast();
    _prepared = player.state.index >= FijkState.prepared.index;
    _playing = player.state == FijkState.started;
    _duration = player.value.duration;
    _currentPos = player.currentPos;
    _bufferPos = player.bufferPos;

    _currentPosSubs = player.onCurrentPosUpdate.listen((v) {
      if (_hideStuff == false) {
        setState(() {
          _currentPos = v;
        });
      } else {
        _currentPos = v;
      }
      if (_needClearSeekData) {
        widget.data.clearValue(Fijk3Data.fijkViewPanelSeekto);
      }
      _needClearSeekData = false;
    });

    if (widget.data.contains(Fijk3Data.fijkViewPanelSeekto)) {
      var pos = widget.data.getValue(Fijk3Data.fijkViewPanelSeekto) as double;
      _currentPos = Duration(milliseconds: pos.toInt());
    }

    _bufferPosSubs = player.onBufferPosUpdate.listen((v) {
      if (_hideStuff == false) {
        setState(() {
          _bufferPos = v;
        });
      } else {
        _bufferPos = v;
      }
    });

    player.addListener(_playerValueChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _valController.close();
    _hideTimer?.cancel();
    _statelessTimer?.cancel();
    _snapshotTimer?.cancel();
    _currentPosSubs?.cancel();
    _bufferPosSubs?.cancel();
    player.removeListener(_playerValueChanged);
  }

  double dura2double(Duration d) {
    return d.inMilliseconds.toDouble();
  }

  void _playerValueChanged() {
    FijkValue value = player.value;

    if (value.duration != _duration) {
      if (_hideStuff == false) {
        setState(() {
          _duration = value.duration;
        });
      } else {
        _duration = value.duration;
      }
    }
    bool playing = (value.state == FijkState.started);
    bool prepared = value.prepared;
    if (playing != _playing ||
        prepared != _prepared ||
        value.state == FijkState.asyncPreparing) {
      setState(() {
        _playing = playing;
        _prepared = prepared;
      });
    }
  }

  void _restartHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(Duration(milliseconds: widget.hideDuration), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void onTapFun() {
    if (_hideStuff == true) {
      _restartHideTimer();
    }
    setState(() {
      _hideStuff = !_hideStuff;
    });
  }

  void playOrPause() {
    if (player.isPlayable() || player.state == FijkState.asyncPreparing) {
      if (player.state == FijkState.started) {
        player.pause();
      } else {
        player.start();
      }
    } else if (player.state == FijkState.initialized) {
      player.start();
    } else {
      FijkLog.w("Invalid state ${player.state} ,can't perform play or pause");
    }
  }

  void onDoubleTapFun() {
    player.value.fullScreen
        ? player.exitFullScreen()
        : player.enterFullScreen();
  }

  void onVerticalDragStartFun(DragStartDetails d) {
    if (d.localPosition.dx > panelWidth() / 2) {
      // right, volume
      _dragLeft = false;
      FijkVolume.getVol().then((v) {
        if (!widget.data.contains(Fijk3Data.fijkViewPanelVolume)) {
          widget.data.setValue(Fijk3Data.fijkViewPanelVolume, v);
        }
        setState(() {
          _volume = v;
          _valController.add(v);
        });
      });
    } else {
      // left, brightness
      _dragLeft = true;
      FijkPlugin.screenBrightness().then((v) {
        if (!widget.data.contains(Fijk3Data.fijkViewPanelBrightness)) {
          widget.data.setValue(Fijk3Data.fijkViewPanelBrightness, v);
        }
        setState(() {
          _brightness = v;
          _valController.add(v);
        });
      });
    }
    _statelessTimer?.cancel();
    _statelessTimer = Timer(const Duration(milliseconds: 2000), () {
      setState(() {});
    });
  }

  void onVerticalDragUpdateFun(DragUpdateDetails d) {
    double delta = d.primaryDelta! / panelHeight();
    delta = -delta.clamp(-1.0, 1.0);
    if (_dragLeft == false) {
      var volume = _volume;
      if (volume != null) {
        volume += delta;
        volume = volume.clamp(0.0, 1.0);
        _volume = volume;
        FijkVolume.setVol(volume);
        setState(() {
          _valController.add(volume!);
        });
      }
    } else if (_dragLeft == true) {
      var brightness = _brightness;
      if (brightness != null) {
        brightness += delta;
        brightness = brightness.clamp(0.0, 1.0);
        _brightness = brightness;
        FijkPlugin.setScreenBrightness(brightness);
        setState(() {
          _valController.add(brightness!);
        });
      }
    }
  }

  void onVerticalDragEndFun(DragEndDetails e) {
    _volume = null;
    _brightness = null;
  }

  Widget buildPlayButton(BuildContext context, double height) {
    Icon icon = (player.state == FijkState.started)
        ? const Icon(Icons.pause)
        : const Icon(Icons.play_arrow);
    return IconButton(
      iconSize: height * 0.8,
      color: const Color(0xFFFFFFFF),
      icon: icon,
      onPressed: playOrPause,
    );
  }

  Widget buildFullScreenButton(BuildContext context, double height) {
    Icon icon = player.value.fullScreen
        ? const Icon(Icons.fullscreen_exit)
        : const Icon(Icons.fullscreen);

    return GestureDetector(
      onTap: () {
        player.value.fullScreen
            ? player.exitFullScreen()
            : player.enterFullScreen();
      },
      child: Icon(
        icon.icon,
        size: height * 0.8,
        color: const Color(0xFFFFFFFF),
      ),
    );
  }

  Widget buildTimeText(BuildContext context, double height) {
    String text =
        "${duration2String(_currentPos)}" "/${duration2String(_duration)}";
    return Text(text,
        style: const TextStyle(fontSize: 12, color: Color(0xFFFFFFFF)));
  }

  Widget buildSlider(BuildContext context) {
    double duration = dura2double(_duration);

    double currentValue = _seekPos > 0 ? _seekPos : dura2double(_currentPos);
    currentValue = currentValue.clamp(0.0, duration);

    double bufferPos = dura2double(_bufferPos);
    bufferPos = bufferPos.clamp(0.0, duration);

    return Padding(
      padding: const EdgeInsets.only(left: 3),
      child: FijkSlider(
        colors: sliderColors,
        value: currentValue,
        cacheValue: bufferPos,
        min: 0.0,
        max: duration,
        onChanged: (v) {
          _restartHideTimer();
          setState(() {
            _seekPos = v;
          });
        },
        onChangeEnd: (v) {
          setState(() {
            player.seekTo(v.toInt());
            _currentPos = Duration(milliseconds: _seekPos.toInt());
            widget.data.setValue(Fijk3Data.fijkViewPanelSeekto, _seekPos);
            _needClearSeekData = true;
            _seekPos = -1.0;
          });
        },
      ),
    );
  }

  Widget buildBottom(BuildContext context, double height) {
    if (_duration.inMilliseconds > 0) {
      return Row(
        children: <Widget>[
          buildPlayButton(context, height * 0.8),
          Container(
            child: widget.onPrev != null
                ? IconButton(
                    iconSize: height * 0.8,
                    color: Colors.white,
                    icon: const Icon(Icons.skip_previous),
                    onPressed: () {
                      widget.onPrev!();
                    },
                  )
                : null,
          ),
          Expanded(
            child: buildSlider(context),
          ),
          Container(
            child: widget.onNext != null
                ? IconButton(
                    iconSize: height * 0.8,
                    color: Colors.white,
                    icon: const Icon(Icons.skip_next),
                    onPressed: () {
                      widget.onNext!();
                    },
                  )
                : null,
          ),
          buildFullScreenButton(context, height * 0.8),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          buildPlayButton(context, height * 0.8),
          Expanded(child: Container()),
          buildFullScreenButton(context, height * 0.8),
        ],
      );
    }
  }

  void takeSnapshot() {
    player.takeSnapShot().then((v) {
      var provider = MemoryImage(v);
      precacheImage(provider, context).then((_) {
        setState(() {
          _imageProvider = provider;
        });
      });
      FijkLog.d("get snapshot succeed");
    }).catchError((e) {
      FijkLog.d("get snapshot failed");
    });
  }

  Widget buildPanel(BuildContext context) {
    double height = panelHeight();

    bool fullScreen = player.value.fullScreen;
    Widget titleWidget = Container();

    if (fullScreen && widget.fullScreenTitle != null) {
      titleWidget = Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0x88000000), Color(0x00000000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: height > 200 ? 80 : height / 5,
            child: widget.fullScreenTitle!,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        titleWidget,
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent, // 允许点击事件穿透到下层
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x88000000), Color(0x00000000)],
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
            ),
          ),
          child: IntrinsicHeight(
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                    ),
                    child:
                        buildTimeText(context, height > 80 ? 40 : height / 2),
                  ),
                  Expanded(
                    child: buildBottom(context, height > 80 ? 40 : height / 2),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  GestureDetector buildGestureDetector(BuildContext context) {
    return GestureDetector(
      onTap: onTapFun,
      onDoubleTap: widget.doubleTap ? onDoubleTapFun : null,
      onVerticalDragUpdate: onVerticalDragUpdateFun,
      onVerticalDragStart: onVerticalDragStartFun,
      onVerticalDragEnd: onVerticalDragEndFun,
      onHorizontalDragUpdate: (d) {},
      onLongPressStart: (detail) async {
        await player.setSpeed(3.0);
        _percentageWidget.percentageCallback('3.0x');
      },
      onLongPressEnd: (detail) async {
        await player.setSpeed(_speed);
        _percentageWidget.offstageCallback(true);
      },
      child: AbsorbPointer(
        absorbing: _hideStuff,
        child: AnimatedOpacity(
          opacity: _hideStuff ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: buildPanel(context),
        ),
      ),
    );
  }

  Rect panelRect() {
    Rect rect = player.value.fullScreen || (true == widget.fill)
        ? Rect.fromLTWH(0, 0, widget.viewSize.width, widget.viewSize.height)
        : Rect.fromLTRB(
            max(0.0, widget.texPos.left),
            max(0.0, widget.texPos.top),
            min(widget.viewSize.width, widget.texPos.right),
            min(widget.viewSize.height, widget.texPos.bottom));
    return rect;
  }

  double panelHeight() {
    if (player.value.fullScreen || (true == widget.fill)) {
      return widget.viewSize.height;
    } else {
      return min(widget.viewSize.height, widget.texPos.bottom) -
          max(0.0, widget.texPos.top);
    }
  }

  double panelWidth() {
    if (player.value.fullScreen || (true == widget.fill)) {
      return widget.viewSize.width;
    } else {
      return min(widget.viewSize.width, widget.texPos.right) -
          max(0.0, widget.texPos.left);
    }
  }

  Widget buildBack(BuildContext context) {
    return GestureDetector(
      // padding: const EdgeInsets.only(left: 5),
      onTap: widget.onBack,
      // padding: const EdgeInsets.only(left: 5),
      child: const Icon(
        Icons.arrow_back_ios,
        color: Color(0xDDFFFFFF),
      ),
    );
  }

  Widget buildStateless() {
    var volume = _volume;
    var brightness = _brightness;
    if (volume != null || brightness != null) {
      Widget toast = volume == null
          ? defaultFijkBrightnessToast(brightness!, _valController.stream)
          : defaultFijkVolumeToast(volume, _valController.stream);
      return IgnorePointer(
        child: AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 500),
          child: toast,
        ),
      );
    } else if (player.state == FijkState.asyncPreparing) {
      return Container(
        alignment: Alignment.center,
        child: const RiveLoading(),
      );
    } else if (player.state == FijkState.error) {
      return Container(
        alignment: Alignment.center,
        child: const Icon(
          Icons.error,
          size: 30,
          color: Color(0x99FFFFFF),
        ),
      );
    } else if (_imageProvider != null) {
      _snapshotTimer?.cancel();
      _snapshotTimer = Timer(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _imageProvider = null;
          });
        }
      });
      return Center(
        child: IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.yellowAccent, width: 3)),
            child:
                Image(height: 200, fit: BoxFit.contain, image: _imageProvider!),
          ),
        ),
      );
    } else {
      return const RiveLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    Rect rect = panelRect();

    List ws = <Widget>[];

    if (_statelessTimer != null && _statelessTimer!.isActive) {
      ws.add(buildStateless());
    } else if (player.state == FijkState.asyncPreparing) {
      ws.add(buildStateless());
    } else if (player.state == FijkState.error) {
      ws.add(buildStateless());
    } else if (_imageProvider != null) {
      ws.add(buildStateless());
    }
    ws.add(buildGestureDetector(context));
    if (widget.onBack != null) {
      ws.add(buildBack(context));
    }
    ws.add(_percentageWidget);

    return Positioned.fromRect(
      rect: rect,
      child: Stack(children: ws as List<Widget>),
    );
  }
}
