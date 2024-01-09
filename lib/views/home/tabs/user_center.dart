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
    Global global = context.watch<Global>();
    // final profile = context.watch<Profile>();
    return Stack(
      // fit: StackFit.expand,
      children: [
        Positioned(
          width: 50,
          height: 50,
          top: 100,
          right: 50,
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
            icon: const Icon(
              Icons.settings,
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Expanded(
              flex: 0,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  color: Color(0xff000000),
                ),
                width: double.infinity,
                // height: 200,
                // color: Theme.of(context).cardColor,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(50, 50, 50, 30),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              width: 60,
                              height: 60,
                              child: const Center(
                                child: Icon(
                                  Icons.sentiment_satisfied_alt,
                                  size: 60,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          const IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Spark',
                                  style: TextStyle(color: Colors.red),
                                ),
                                Text('签名写在这里'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor),
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: const Text('设置'),
                      leading: const Icon(
                        Icons.settings,
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                      onTap: () {
                        Navigator.pushNamed(context, '/setting');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
