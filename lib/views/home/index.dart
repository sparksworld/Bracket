import 'package:bracket/widgets/index.dart';
import 'package:flutter/services.dart';

import '/plugins.dart';
import './tabs/recommend.dart' show RecommendTab;
import './tabs/user_center.dart' show UserCenterTab;
import './tabs/classify.dart' show ClassifyTab;

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
        const RecommendTab(),
        const ClassifyTab(),
        const UserCenterTab(),
      ];
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final User? profile = context.watch<Profile>().user;
    // print(PreferenceUtils.getMap('user'));
    // print(profile?.userId);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool willpop) {
        if (willpop) return;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(
              title: '提示',
              content: '是否退出应用？',
              onConfirm: () async {
                SystemNavigator.pop();
              },
            );
          },
        );
      },
      child: Scaffold(
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
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).disabledColor,
                      ),
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: _bottomAppBarIndex == index
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).disabledColor,
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
