import 'package:bracket/plugins.dart';

class MySearchBar extends SearchDelegate<String> {
  // 点击清楚的方法
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        // 点击把文本空的内容清空
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  // 点击箭头返回
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        // 使用动画效果返回
        icon: AnimatedIcons.menu_arrow, progress: transitionAnimation,
      ),
      // 点击的时候关闭页面（上下文）
      onPressed: () {
        close(context, '1');
      },
    );
  }

  // 点击搜索出现结果
  @override
  Widget buildResults(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Card(
        color: Colors.pink,
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  // 搜索下拉框提示的方法
  @override
  Widget buildSuggestions(BuildContext context) {
    // 定义变量 并进行判断
    final suggestionList = [];
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: RichText(
            text: TextSpan(
              // 获取搜索框内输入的字符串，设置它的颜色并让让加粗
              text: suggestionList[index].substring(0, query.length),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  //获取剩下的字符串，并让它变成灰色
                  text: suggestionList[index].substring(
                    query.length,
                  ),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
