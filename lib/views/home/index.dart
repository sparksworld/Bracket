import '/plugins.dart';
import './tabs/recommend.dart' show Recommend;
import './tabs/user_center.dart' show UserCenter;
import './tabs/classify.dart' show Classify;

class Home extends StatefulWidget {
  final String? arguments;
  const Home({super.key, this.arguments});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _bottomAppBarIndex = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    if (mounted) {
      _bottomAppBarIndex = 0;
      _pages = [
        const Recommend(),
        const Classify(),
        const UserCenter(),
      ];
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final User? profile = context.watch<Profile>().user;
    // print(PreferenceUtils.getMap('user'));
    // print(profile?.userId);

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          color: Colors.transparent,
          // padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              bottomIcon(text: '推荐', icon: Icons.home, index: 0),
              bottomIcon(text: '分类', icon: Icons.movie_filter, index: 1),
              bottomIcon(text: '我的', icon: Icons.person, index: 2),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          return OrientationBuilder(
            builder: (context, orientation) {
              return IndexedStack(
                index: _bottomAppBarIndex,
                children: _pages,
              );
            },
          );
        },
      ),
    );
  }

  Widget bottomIcon(
      {required IconData icon, required int index, required String text}) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (TapDownDetails details) {
          setState(() {
            _bottomAppBarIndex = index;
          });
        },
        child: SizedBox(
          height: 54.0,
          width: double.infinity,
          child: text.isNotEmpty
              ? Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: _bottomAppBarIndex == index
                            ? Colors.red
                            : Colors.grey,
                      ),
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: _bottomAppBarIndex == index
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  color: Colors.transparent,
                ),
        ),
      ),
    );
  }
}
