import 'package:better_player/better_player.dart';
// import 'package:example/constants.dart';
import 'package:flutter/material.dart';

class AutoFullscreenOrientationPage extends StatefulWidget {
  @override
  _AutoFullscreenOrientationPageState createState() =>
      _AutoFullscreenOrientationPageState();
}

class _AutoFullscreenOrientationPageState
    extends State<AutoFullscreenOrientationPage> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            aspectRatio: 16 / 9,
            fit: BoxFit.contain,
            autoDetectFullscreenDeviceOrientation: true);
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4");
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auto full screen orientation"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Aspect ratio and device orientation on full screen will be "
              "managed by the BetterPlayer. Click on the fullscreen option.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController),
          ),
          ElevatedButton(
            child: Text("Play horizontal video"),
            onPressed: () {
              BetterPlayerDataSource dataSource = BetterPlayerDataSource(
                  BetterPlayerDataSourceType.network,
                  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4");
              _betterPlayerController.setupDataSource(dataSource);
            },
          ),
          ElevatedButton(
            child: Text("Play vertical video"),
            onPressed: () async {
              BetterPlayerDataSource dataSource = BetterPlayerDataSource(
                  BetterPlayerDataSourceType.network,
                  'http://www.exit109.com/~dnn/clips/RW20seconds_1.mp4');
              _betterPlayerController.setupDataSource(dataSource);
            },
          ),
        ],
      ),
    );
  }
}
