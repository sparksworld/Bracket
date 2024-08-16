import 'package:fijkplayer/fijkplayer.dart';
import '/model/film_play_info/list.dart';
import '/model/film_play_info/detail.dart';
import '/plugins.dart';

class Player extends StatefulWidget {
  const Player({
    super.key,
    this.detail,
    this.title,
    required this.originIndex,
    required this.teleplayIndex,
    this.list,
    this.startAt,
    required this.callback,
    // required this.aspectRatio,
  });

  final Detail? detail;
  final List<Widget>? title;
  final int originIndex;
  final int teleplayIndex;
  final List<ListData?>? list;
  final int? startAt;
  final Function(int, int) callback;

  @override
  State createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final FijkPlayer player = FijkPlayer();
  final double _aspectRatio = 16 / 9;

  bool _loading = true;
  bool _error = false;
  bool _netWarning = false;

  get link {
    var list = widget.list;
    var originIndex = widget.originIndex;
    var teleplayIndex = widget.teleplayIndex;
    var originPlayList = list?[originIndex]?.linkList;
    var playItem = originPlayList?[teleplayIndex];
    return playItem?.link;
  }

  @override
  void initState() {
    super.initState();

    changeSource(link);

    watchConnectivity(ConnectivityResult.mobile, () {
      setState(() {
        _netWarning = true;
      });
    });
  }

  void changeSource(String link) {
    player.reset();
    player
        .setDataSource(
      link,
      autoPlay: true,
    )
        .then(
      (value) {
        setState(() {
          _loading = false;
          _error = false;
        });
      },
    ).catchError((err) {
      setState(() {
        _loading = false;
        _error = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: Stack(
        children: [
          _netWarning
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('未检测到wifi,是否继续播放?'),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _netWarning = false;
                          });
                        },
                        child: const Text('播放'),
                      ),
                    ],
                  ),
                )
              : _loading
                  ? const RiveLoading()
                  : FijkView(player: player),
          Positioned(
            child: Row(
              children: widget.title ?? [],
            ),
          )
        ],
      ),
    );
  }
}
