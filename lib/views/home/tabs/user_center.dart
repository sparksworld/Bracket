import '/plugins.dart';

class UserCenter extends StatefulWidget {
  const UserCenter({super.key});

  @override
  State<StatefulWidget> createState() => _UserCenterState();
}

class _UserCenterState extends State<UserCenter> {
  void onChangeEvent() {
    // eventBus.fire(SwitchTab(0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '个人中心',
            // style: TextStyle(color: Theme.of(context).tabBarTheme.labelStyle.color),
          ),
          // iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
          // brightness: Brightness.dark,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/setting');
              },
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).primaryIconTheme.color,
              ),
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    // 顶部栏
                    new Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 220.0,
                          color: Colors.white,
                        ),
                        ClipPath(
                          clipper: new TopBarClipper(
                              MediaQuery.of(context).size.width, 200.0),
                          child: new SizedBox(
                            width: double.infinity,
                            height: 200.0,
                            child: new Container(
                              width: double.infinity,
                              height: 240.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        // 名字
                        Container(
                          margin: new EdgeInsets.only(top: 40.0),
                          child: new Center(
                            child: new Text(
                              'Spark',
                              style: new TextStyle(
                                  fontSize: 30.0, color: Colors.white),
                            ),
                          ),
                        ),
                        // 图标
                      ],
                    ),
                    // 内容
                  ]),
                ),
              ],
            ),
          ],
        ));
  }
}

// 顶部栏裁剪
class TopBarClipper extends CustomClipper<Path> {
  // 宽高
  double width;
  double height;

  TopBarClipper(this.width, this.height);

  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(width, 0.0);
    path.lineTo(width, height / 2);
    path.lineTo(0.0, height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
