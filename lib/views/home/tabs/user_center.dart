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
    final profile = context.read<Profile>();

    String? token = profile.user?.userToken;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).focusColor,
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
                            token ?? 'Spark',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text('签名写在这里',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              // color: Theme.of(context).navigationDrawerTheme.backgroundColor,
              // decoration: BoxDecoration(
              //   border: Border(
              //       // bottom: BorderSide(
              //       //   color: Theme.of(context).indicatorColor,
              //       // ),
              //       ),
              //   color: Theme.of(context).navigationDrawerTheme.backgroundColor,
              // ),
              child: Column(
                children: [
                  // ListTile(
                  //   title: const Text('设置'),
                  //   leading: const Icon(
                  //     Icons.settings,
                  //   ),
                  //   trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                  //   onTap: () {
                  //     Navigator.pushNamed(context, MYRouter.settingPagePath);
                  //   },
                  // ),
                  ListTile(
                    title: const Text('系统主题'),
                    leading: const Icon(Icons.border_color),
                    trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    onTap: () {
                      Navigator.pushNamed(context, MYRouter.themePagePath);
                    },
                  ),
                  const ListTile(
                    title: Text('意见反馈'),
                    leading: Icon(Icons.send),
                    trailing: Icon(Icons.keyboard_arrow_right_outlined),
                  ),
                  const ListTile(
                    title: Text('关于'),
                    leading: Icon(Icons.sentiment_satisfied_alt),
                    trailing: Icon(Icons.keyboard_arrow_right_outlined),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              child: ListTile(
                title: const Text('退出登录'),
                leading: const Icon(Icons.exit_to_app),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                onTap: () {
                  profile.clearUser();
                  // Navigator.pushNamed(context, MYRouter.settingPagePath);
                },
              ),
            ),
          )
          // TextButton(
          //   onPressed: () {
          //     print(11);
          //   },
          //   child: Text('退出登录'),
          // )
        ],
      ),
    );
  }
}
