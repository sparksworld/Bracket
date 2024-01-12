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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: const Border(
                bottom: BorderSide(
                  color: Colors.red,
                ),
              ),
              color: Theme.of(context).primaryColor,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 30, 50, 30),
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
                    IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Spark',
                            style: TextStyle(
                                color: Theme.of(context).cardTheme.color),
                          ),
                          Text(
                            '签名写在这里',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).indicatorColor,
                  ),
                ),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('设置'),
                    leading: const Icon(
                      Icons.settings,
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    onTap: () {
                      Navigator.pushNamed(context, MYRouter.settingPagePath);
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: const Text('设置'),
                    leading: const Icon(
                      Icons.settings,
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    onTap: () {
                      Navigator.pushNamed(context, MYRouter.settingPagePath);
                    },
                  ),
                ],
              ),
            ),
          ),

          // ),
          TextButton(
            onPressed: () {
              print(11);
            },
            child: Text('退出登录'),
          )
          // ListTile(
          //   title: const Text('退出登录'),
          //   leading: Center(
          //     child: Checkbox(
          //       value: true,
          //       onChanged: (bool? value) {},
          //     ),
          //   ),
          //   // trailing: const Icon(Icons.keyboard_arrow_right_outlined),
          //   onTap: () {
          //     Navigator.pushNamed(context, MYRouter.settingPagePath);
          //   },
          // ),
        ],
      ),
    );
  }
}
