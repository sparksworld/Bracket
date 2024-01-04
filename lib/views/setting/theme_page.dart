import '/plugins.dart';

class ThemePage extends StatefulWidget {
  ThemePage({
    super.key,
  });

  final List<ListItem> items = List<ListItem>.generate(
    1000,
    (i) => i % 6 == 0
        ? HeadingItem('Heading $i')
        : MessageItem('Sender $i', 'Message body $i'),
  );

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Global global = context.watch<Global>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('系统主题'),
      ),
      body: ListView(
        children: <Widget>[
          RadioListTile<String>(
            title: Text('aaaa'),
            // 必须要的属性
            value: '1',
            //是否选中发生变化时的回调， 回调的 bool 值 就是是否选中 , true 是 选中
            groupValue: 'groupValue',
            onChanged: (value) {},
            // 选中时 填充的颜色
            activeColor: Colors.red,
            // 标题， 具有代表性的就是 Text ，
            //        selected 如果是 true ：
            //         如果 不设置 text 的 color 的话， text的颜色 跟随 activeColor
            // 副标题（在 title 下面）， 具有代表性的就是 Text ， 如果 不设置 text 的 color 的话， text的颜色 跟随 activeColor
            subtitle: Text("副标题"),
            // 是否是三行文本
            //        如果是 true ： 副标题 不能为 null
            //        如果是 false：
            //                      如果没有副标题 ，就只有一行， 如果有副标题 ，就只有两行
            isThreeLine: false,
            // 是否密集垂直
            dense: false,
            // 左边的一个控件
//              secondary: Text("secondary"),
            // text 和 icon 的 color 是否 是 activeColor 的颜色
            selected: true,
            controlAffinity: ListTileControlAffinity.leading,
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
          Divider(
            height: 0,
          ),
          ListTile(
            title: Text('暗黑模式'),
            leading: Icon(Icons.sentiment_satisfied_alt),
            trailing: Icon(Icons.keyboard_arrow_right_outlined),
          ),
          Divider(
            height: 0,
          ),
          ListTile(
            title: Text('日光模式'),
            leading: Icon(Icons.send),
            trailing: Icon(Icons.keyboard_arrow_right_outlined),
          ),
          SizedBox(
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
