import '/plugins.dart';
import 'package:fplayer/fplayer.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  final FPlayer player = FPlayer();

  @override
  void initState() {
    super.initState();
    player.setDataSource(
      "https://static.smartisanos.cn/common/video/video-jgpro.mp4",
      autoPlay: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FView(
          player: player,
          panelBuilder: fPanelBuilder(
            title: '视频标题',
            subTitle: '视频副标题',
          ),
        ),
      ),
    );
  }
}
