import 'package:brightness_volume/brightness_volume.dart' show BVUtils;

import '/plugins.dart';
import 'package:video_player/video_player.dart';
// ignore: implementation_imports
import 'package:chewie/src/helpers/utils.dart';
// ignore: implementation_imports
import 'package:chewie/src/material/widgets/playback_speed_dialog.dart';
// ignore: implementation_imports
import 'package:chewie/src/center_play_button.dart';
// ignore: implementation_imports
import 'package:chewie/src/material/widgets/options_dialog.dart';
// ignore: implementation_imports
import 'package:chewie/src/models/option_item.dart';
// ignore: implementation_imports
import 'package:chewie/src/material/material_progress_bar.dart';
// ignore: implementation_imports
import 'package:chewie/src/chewie_progress_colors.dart';
// ignore: implementation_imports
import 'package:chewie/src/chewie_player.dart';
// ignore: implementation_imports
import 'package:chewie/src/notifiers/index.dart';
import 'percentage.dart';

class PlayerControl extends StatefulWidget {
  const PlayerControl({
    super.key,
    this.showPlayButton = true,
    this.title,
    this.onNext,
    this.onPrev,
  });

  final bool showPlayButton;
  final List<Widget>? title;
  final Function? onNext;
  final Function? onPrev;

  @override
  State<StatefulWidget> createState() {
    return _PlayerControlState();
  }
}

class _PlayerControlState extends State<PlayerControl>
    with SingleTickerProviderStateMixin {
  final barHeight = 48.0 * 1.5;
  final marginSize = 5.0;
  late PlayerNotifier notifier;
  late VideoPlayerValue _latestValue;
  late PercentageWidget _percentageWidget;
  late VideoPlayerController controller;

  double? _latestVolume;
  Timer? _hideTimer;
  Timer? _initTimer;
  Timer? _showAfterExpandCollapseTimer;
  Timer? _bufferingDisplayTimer;
  double _tempPlaybackSpeed = 1.0;
  // double _nowPlaybackSpeed = 1.0;

  // bool _accelerating = false;
  bool _dragging = false;
  bool _displayTapped = false;
  bool _displayBufferingIndicator = false;
  bool _varTouchInitSuc = false;
  bool _isDargVerLeft = false;
  double _updatePrevDy = 0;
  double _updateDargVarVal = 0;

  ChewieController? _chewieController;
  // We know that _chewieController is set in didChangeDependencies
  ChewieController get chewieController => _chewieController!;

  @override
  void initState() {
    super.initState();
    // _setInit();
    _percentageWidget = PercentageWidget();
    notifier = Provider.of<PlayerNotifier>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    if (_latestValue.hasError) {
      return chewieController.errorBuilder?.call(
            context,
            chewieController.videoPlayerController.value.errorDescription!,
          ) ??
          const Center(
            child: Icon(
              Icons.error,
              color: Colors.white,
              size: 42,
            ),
          );
    }

    return GestureDetector(
      onTap: () => _cancelAndRestartTimer(),
      onDoubleTap: () => {
        if (chewieController.isFullScreen)
          {chewieController.exitFullScreen()}
        else
          {chewieController.enterFullScreen()}
      },
      onLongPressStart: (detail) {
        // _accelerating = true;
        _tempPlaybackSpeed = controller.value.playbackSpeed;
        // _nowPlaybackSpeed = Platform.isIOS ? 2.0 : 3.0;
        // print(controller.value.playbackSpeed);
        controller.setPlaybackSpeed(Platform.isIOS ? 2.0 : 3.0);
        _percentageWidget.percentageCallback(Platform.isIOS ? '2.0x' : '3.0x');
      },
      onLongPressEnd: (detail) {
        // _accelerating = false;
        // _nowPlaybackSpeed = _tempPlaybackSpeed;
        controller.setPlaybackSpeed(_tempPlaybackSpeed);
        _percentageWidget.offstageCallback(true);
        print('onLongPressEnd');
      },
      onVerticalDragStart: (DragStartDetails details) async {
        double clientW = context.size!.width;
        double curTouchPosX = details.globalPosition.dx;

        setState(() {
          // 更新位置
          _updatePrevDy = details.globalPosition.dy;
          // 是否左边
          _isDargVerLeft = (curTouchPosX > (clientW / 2)) ? false : true;
        });

        if (!_isDargVerLeft) {
          await getVolume().then((double v) {
            _varTouchInitSuc = true;
            setState(() {
              _updateDargVarVal = v;
            });
          });
        } else {
          // 亮度
          await getBrightness().then((double v) {
            _varTouchInitSuc = true;
            setState(() {
              _updateDargVarVal = v;
            });
          });
        }
      }, // 根据起始位置。确定是调整亮度还是调整声音
      onVerticalDragUpdate: (DragUpdateDetails details) async {
        if (!_varTouchInitSuc) return;
        double curDragDy = details.globalPosition.dy;
        // 确定当前是前进或者后退
        int cdy = curDragDy.toInt();
        int pdy = _updatePrevDy.toInt();
        bool isBefore = cdy < pdy;
        // + -, 不满足, 上下滑动合法滑动值，> 3
        if (isBefore && pdy - cdy < 3 || !isBefore && cdy - pdy < 3) return;
        // 区间
        double dragRange =
            isBefore ? _updateDargVarVal + 0.03 : _updateDargVarVal - 0.03;
        // 是否溢出
        if (dragRange > 1) {
          dragRange = 1.0;
        }
        if (dragRange < 0) {
          dragRange = 0.0;
        }
        setState(() {
          _updatePrevDy = curDragDy;
          _varTouchInitSuc = true;
          _updateDargVarVal = dragRange;
          // 音量
          if (!_isDargVerLeft) {
            setVolume(dragRange);
            _percentageWidget
                .percentageCallback('音量：${(dragRange * 100).toInt()}%');
          } else {
            setBrightness(dragRange);
            _percentageWidget
                .percentageCallback('亮度：${(dragRange * 100).toInt()}%');
          }
        });
      }, // 一般在更新的时候，同步调整亮度或声音
      onVerticalDragEnd: (_) {
        _percentageWidget.offstageCallback(true);
        setState(() {
          _varTouchInitSuc = false;
        });
      },
      child: AbsorbPointer(
        absorbing: notifier.hideStuff,
        child: Stack(
          children: [
            if (_displayBufferingIndicator)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              _buildHitArea(),
            _buildActionBar(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _buildBottomBar(context),
              ],
            ),
            _percentageWidget,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
    resetCustomBrightness();
  }

  @override
  void didChangeDependencies() {
    final oldController = _chewieController;
    _chewieController = ChewieController.of(context);
    controller = chewieController.videoPlayerController;

    if (oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  static Future<double> getVolume() async {
    return await BVUtils.volume;
  }

  // 设置音量
  static Future<void> setVolume(double volume) async {
    return await BVUtils.setVolume(volume);
  }

  // 获取亮度
  static Future<double> getBrightness() async {
    return await BVUtils.brightness;
  }

  // 设置亮度
  static Future<void> setBrightness(double brightness) async {
    return await BVUtils.setBrightness(brightness);
  }

  static Future<void> resetCustomBrightness() async {
    return await BVUtils.resetCustomBrightness();
  }

  Widget _buildActionBar() {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: AnimatedOpacity(
              opacity: notifier.hideStuff ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 250),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children:
                        chewieController.isFullScreen ? widget.title ?? [] : [],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOptionsButton() {
    final options = <OptionItem>[
      OptionItem(
        onTap: () async {
          Navigator.pop(context);
          _onSpeedButtonTap();
        },
        iconData: Icons.speed,
        title: chewieController.optionsTranslation?.playbackSpeedButtonText ??
            'Playback speed',
      )
    ];

    if (chewieController.additionalOptions != null &&
        chewieController.additionalOptions!(context).isNotEmpty) {
      options.addAll(chewieController.additionalOptions!(context));
    }

    return AnimatedOpacity(
      opacity: notifier.hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 250),
      child: GestureDetector(
        child: Container(
          margin: const EdgeInsets.only(right: 12.0),
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ),
        onTap: () async {
          _hideTimer?.cancel();

          if (chewieController.optionsBuilder != null) {
            await chewieController.optionsBuilder!(context, options);
          } else {
            await showModalBottomSheet<OptionItem>(
              context: context,
              isScrollControlled: true,
              useRootNavigator: chewieController.useRootNavigator,
              builder: (context) => OptionsDialog(
                options: options,
                cancelButtonText:
                    chewieController.optionsTranslation?.cancelButtonText,
              ),
            );
          }

          if (_latestValue.isPlaying) {
            _startHideTimer();
          }
        },
      ),
    );
  }

  AnimatedOpacity _buildBottomBar(
    BuildContext context,
  ) {
    final iconColor = Theme.of(context).textTheme.labelLarge!.color;

    return AnimatedOpacity(
      opacity: notifier.hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: barHeight + (chewieController.isFullScreen ? 10.0 : 0),
        padding: EdgeInsets.only(
          left: 20,
          bottom: !chewieController.isFullScreen ? 10.0 : 0,
        ),
        child: SafeArea(
          top: false,
          bottom: chewieController.isFullScreen,
          minimum: chewieController.controlsSafeAreaMinimum,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (chewieController.isLive)
                      const Expanded(child: Text('LIVE'))
                    else
                      _buildPosition(iconColor),
                    if (chewieController.allowMuting)
                      _buildMuteButton(controller),
                    const Spacer(),
                    if (chewieController.allowFullScreen) _buildExpandButton(),
                    if (chewieController.showOptions) _buildOptionsButton(),
                  ],
                ),
              ),
              if (!chewieController.isLive)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildProgressBar(),
                      ],
                    ),
                  ),
                ),
              // SizedBox(
              //   height: chewieController.isFullScreen ? 15.0 : 0,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _buildMuteButton(
    VideoPlayerController controller,
  ) {
    return GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();

        if (_latestValue.volume == 0) {
          controller.setVolume(_latestVolume ?? 0.5);
        } else {
          _latestVolume = controller.value.volume;
          controller.setVolume(0.0);
        }
      },
      child: AnimatedOpacity(
        opacity: notifier.hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            height: barHeight,
            padding: const EdgeInsets.only(
              left: 6.0,
            ),
            child: Icon(
              _latestValue.volume > 0 ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildExpandButton() {
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: AnimatedOpacity(
        opacity: notifier.hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: barHeight + (chewieController.isFullScreen ? 15.0 : 0),
          // margin: const EdgeInsets.only(right: 12.0),
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Center(
            child: Icon(
              chewieController.isFullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHitArea() {
    final bool isFinished = _latestValue.position >= _latestValue.duration;
    final bool showPlayButton =
        widget.showPlayButton && !_dragging && !notifier.hideStuff;

    return GestureDetector(
      onTap: () {
        if (_latestValue.isPlaying) {
          if (_displayTapped) {
            setState(() {
              notifier.hideStuff = true;
            });
          } else {
            _cancelAndRestartTimer();
          }
        } else {
          _playPause();

          setState(() {
            notifier.hideStuff = true;
          });
        }
      },
      child: ColoredBox(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // showPlayButton && chewieController.isFullScreen
              //     ? IconButton(
              //         onPressed: () {
              //           if (widget.onPrev != null) {
              //             widget.onPrev!();
              //           }
              //         },
              //         icon: const Icon(
              //           Icons.skip_previous,
              //           size: 48,
              //         ),
              //       )
              //     : Container(),
              CenterPlayButton(
                backgroundColor: Colors.black54,
                iconColor: Colors.white,
                isFinished: isFinished,
                isPlaying: controller.value.isPlaying,
                show: showPlayButton,
                onPressed: _playPause,
              ),
              // showPlayButton && showPlayButton && chewieController.isFullScreen
              //     ? IconButton(
              //         onPressed: () {
              //           widget.onNext!();
              //         },
              //         icon: const Icon(
              //           Icons.skip_next,
              //           size: 48,
              //         ),
              //       )
              //     : Container(),
            ],
          )),
    );
  }

  Future<void> _onSpeedButtonTap() async {
    _hideTimer?.cancel();

    final chosenSpeed = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: chewieController.useRootNavigator,
      builder: (context) => PlaybackSpeedDialog(
        speeds: chewieController.playbackSpeeds,
        selected: _latestValue.playbackSpeed,
      ),
    );

    if (chosenSpeed != null) {
      controller.setPlaybackSpeed(chosenSpeed);
    }

    if (_latestValue.isPlaying) {
      _startHideTimer();
    }
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      notifier.hideStuff = false;
      _displayTapped = true;
    });
  }

  Future<void> _initialize() async {
    controller.addListener(_updateState);

    _updateState();

    if (controller.value.isPlaying || chewieController.autoPlay) {
      _startHideTimer();
    }

    if (chewieController.showControlsOnInitialize) {
      _initTimer = Timer(const Duration(milliseconds: 200), () {
        setState(() {
          notifier.hideStuff = false;
        });
      });
    }
  }

  void _onExpandCollapse() {
    setState(() {
      notifier.hideStuff = true;

      chewieController.toggleFullScreen();
      _showAfterExpandCollapseTimer =
          Timer(const Duration(milliseconds: 300), () {
        setState(() {
          _cancelAndRestartTimer();
        });
      });
    });
  }

  void _playPause() {
    final isFinished = _latestValue.position >= _latestValue.duration;

    setState(() {
      if (controller.value.isPlaying) {
        notifier.hideStuff = false;
        _hideTimer?.cancel();
        controller.pause();
      } else {
        _cancelAndRestartTimer();

        if (!controller.value.isInitialized) {
          controller.initialize().then((_) {
            controller.play();
          });
        } else {
          if (isFinished) {
            controller.seekTo(Duration.zero);
          }
          controller.play();
        }
      }
    });
  }

  void _startHideTimer() {
    final hideControlsTimer = chewieController.hideControlsTimer.isNegative
        ? ChewieController.defaultHideControlsTimer
        : chewieController.hideControlsTimer;
    _hideTimer = Timer(hideControlsTimer, () {
      setState(() {
        notifier.hideStuff = true;
      });
    });
  }

  void _bufferingTimerTimeout() {
    _displayBufferingIndicator = true;
    if (mounted) {
      setState(() {});
    }
  }

  void _updateState() {
    if (!mounted) return;

    // display the progress bar indicator only after the buffering delay if it has been set

    if (chewieController.progressIndicatorDelay != null) {
      if (controller.value.isBuffering) {
        _bufferingDisplayTimer ??= Timer(
          chewieController.progressIndicatorDelay!,
          _bufferingTimerTimeout,
        );
      } else {
        _bufferingDisplayTimer?.cancel();
        _bufferingDisplayTimer = null;
        _displayBufferingIndicator = false;
      }
    } else {
      _displayBufferingIndicator = controller.value.isBuffering;
    }

    setState(() {
      _latestValue = controller.value;
      // _subtitlesPosition = controller.value.position;
    });
  }

  Widget _buildPosition(Color? iconColor) {
    final position = _latestValue.position;
    final duration = _latestValue.duration;

    return RichText(
      text: TextSpan(
        text: '${formatDuration(position)} ',
        children: <InlineSpan>[
          TextSpan(
            text: '/ ${formatDuration(duration)}',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white.withOpacity(.75),
              fontWeight: FontWeight.normal,
            ),
          )
        ],
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: MaterialVideoProgressBar(
        controller,
        onDragStart: () {
          setState(() {
            _dragging = true;
          });

          _hideTimer?.cancel();
        },
        onDragUpdate: () {
          _hideTimer?.cancel();
        },
        onDragEnd: () {
          setState(() {
            _dragging = false;
          });

          _startHideTimer();
        },
        colors: chewieController.materialProgressColors ??
            ChewieProgressColors(
              playedColor: Theme.of(context).colorScheme.secondary,
              handleColor: Theme.of(context).colorScheme.secondary,
              bufferedColor:
                  Theme.of(context).colorScheme.background.withOpacity(0.5),
              backgroundColor: Theme.of(context).disabledColor.withOpacity(.5),
            ),
      ),
    );
  }
}
