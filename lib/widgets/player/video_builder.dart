import 'package:bracket/plugins.dart';

class VideoBuilder extends StatefulWidget {
  const VideoBuilder({super.key, required this.controllerProvider});

  final Widget controllerProvider;

  @override
  State<VideoBuilder> createState() => _VideoBuilderState();
}

class _VideoBuilderState extends State<VideoBuilder> {
  @override
  void initState() {
    print('initState');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    super.initState();
  }

  @override
  dispose() {
    print('dispose');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Theme(
              data: Theme.of(context).copyWith(
                platform: TargetPlatform.android,
              ),
              child: widget.controllerProvider,
            ),
          ),
          Positioned(
            left: 0,
            top: 20,
            child: SafeArea(
              child: BackButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
