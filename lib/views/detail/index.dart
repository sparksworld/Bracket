import 'package:bracket/plugins.dart';
import "package:chewie/chewie.dart";
import "package:video_player/video_player.dart";

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final videoPlayerController = VideoPlayerController.networkUrl(
    Uri.parse('https://v.cdnlz3.com/20240112/22741_4dec050c/index.m3u8'),
  );
  late ChewieController chewieController;
  bool init = false;

  @override
  void initState() {
    super.initState();
    a();
  }

  Future a() async {
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
    );
    setState(() {
      init = true;
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample App"),
      ),
      body: Container(
        child: init ? Chewie(controller: chewieController) : Text('data'),
      ),
    );
  }
}
