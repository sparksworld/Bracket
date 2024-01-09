import '/plugins.dart';

class Setting extends StatefulWidget {
  Setting({
    super.key,
  });

  final List<ListItem> items = List<ListItem>.generate(
    1000,
    (i) => i % 6 == 0
        ? HeadingItem('Heading $i')
        : MessageItem('Sender $i', 'Message body $i'),
  );

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Global global = context.watch<Global>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('系统主题'),
            leading: const Icon(Icons.border_color),
            trailing: const Icon(Icons.keyboard_arrow_right_outlined),
            onTap: () {
              Navigator.pushNamed(context, MYRouter.themePagePath);
            },
          ),
          // SwitchListTile(
          //   secondary: const Icon(Icons.lightbulb_outline),
          //   title: const Text('暗黑模式'),
          //   value: global.theme == ITheme.dark.value,
          //   onChanged: (bool? value) {
          //     if (value == true) {
          //       global.setTheme(ITheme.dark.value);
          //     } else {
          //       global.setTheme(ITheme.light.value);
          //     }
          //   },
          // ),
          const Divider(
            height: 0,
          ),
          const ListTile(
            title: Text('关于'),
            leading: Icon(Icons.sentiment_satisfied_alt),
            trailing: Icon(Icons.keyboard_arrow_right_outlined),
          ),
          const Divider(
            height: 0,
          ),
          const ListTile(
            title: Text('意见反馈'),
            leading: Icon(Icons.send),
            trailing: Icon(Icons.keyboard_arrow_right_outlined),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}
