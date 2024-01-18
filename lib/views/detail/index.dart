import 'package:bracket/plugins.dart';
import "package:chewie/chewie.dart";
import "package:video_player/video_player.dart";

class DetailPage extends StatefulWidget {
  final Map? arguments;
  const DetailPage({Key? key, this.arguments}) : super(key: key);

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
    print(widget.arguments);
    _fetchData(widget.arguments?['id']);
    _initChewieController();
  }

  Future _fetchData(id) async {
    var res = await Api.filmDetail(queryParameters: {
      'id': id,
    });

    if (res != null) {
      // Detail jsonData = Detail.fromJson(res);
    }
  }

  Future _initChewieController() async {
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 1.6,
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
      body: SafeArea(
        child: Container(
          // alignment: Alignment.topLeft,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: AspectRatio(
            aspectRatio: 1.6,
            child: init
                ? Chewie(
                    controller: chewieController,
                  )
                : const Text('data'),
          ),
        ),
      ),
    );
  }
}
