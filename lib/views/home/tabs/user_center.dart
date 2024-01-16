import '/widgets/index.dart';
import '/plugins.dart';

class UserCenterTab extends StatefulWidget {
  const UserCenterTab({super.key});

  @override
  State<StatefulWidget> createState() => _UserCenterState();
}

class _UserCenterState extends State<UserCenterTab> {
  void onChangeEvent() {
    // eventBus.fire(SwitchTab(0));
  }

  @override
  Widget build(BuildContext context) {
    // Global global = context.watch<Global>();
    final Profile profile = context.read<Profile>();
    final String? token = profile.user?.userToken;

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
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 0,
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
                          Expanded(
                            flex: 1,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  child: Text(
                                    "$token",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),
                                Text(
                                  '签名写在这里',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
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
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              child: Column(
                children: [
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return MyDialog(
                        title: '提示',
                        content: '是否确认退出登录？',
                        onConfirm: () async {
                          profile.clearUser();
                        },
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
