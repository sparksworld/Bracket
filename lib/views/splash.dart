import '/plugins.dart';

class SplashPage extends StatefulWidget {
  final String? title;
  const SplashPage({super.key, this.title});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;
  // void test(BuildContext context) {
  //   context.read<Setting>().setTheme(ITheme.green.value);
  //   context.read<Setting>().setUser(User.fromJson({
  //         "user_id": 1121,
  //         "user_token": 'ce===dwadawdawdawdaw',
  //         "user_name": Random().nextInt(10).toString(),
  //         "user_avator": 'dawdaw',
  //         "user_phone": 12212,
  //       }));
  // }

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      navigationPage();
      // context.read<Profile>().setUser({
      //   "user_id": 1121,
      //   "user_token": 'ce===dwadawdawdawdaw',
      //   "user_name": Random().nextInt(10).toString(),
      //   "user_avator": 'dawdaw',
      //   "user_phone": 12212,
      // });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void navigationPage() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(MYRouter.homePagePath, (route) => false);
    // Navigator.of(context).pushAndRemoveUntil(
    //   PageRouteBuilder(
    //     transitionDuration: const Duration(milliseconds: 200), //动画时间为500毫秒
    //     pageBuilder: (BuildContext context, Animation<double> animation,
    //         Animation secondaryAnimation) {
    //       return FadeTransition(
    //         //使用渐隐渐入过渡,
    //         opacity: animation,
    //         child: MYRouter.routeTables[MYRouter.homePath]!.builder, //路由B
    //       );
    //     },
    //   ),
    //   (Route<dynamic> route) => false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: 750.px,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              border: Border.all(color: const Color.fromRGBO(133, 0, 0, 1))),
          child: const Column(children: [
            // Text(context.watch<Global>().theme),
            // Text(context.watch<Setting>().user?.userName ?? ''),
            // Consumer<Setting>(builder: (context, value, child) {
            //   return Text("Child C number: ${value.theme}");
            // })
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigationPage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
