import '/plugins.dart';

class PercentageWidget extends StatefulWidget {
  PercentageWidget({Key? key}) : super(key: key);
  late Function(String) percentageCallback; // 百分比
  late Function(bool) offstageCallback;
  @override
  _PercentageWidgetState createState() => _PercentageWidgetState();
}

class _PercentageWidgetState extends State<PercentageWidget> {
  String _percentage = ""; // 具体的百分比信息
  bool _offstage = true;
  @override
  void initState() {
    super.initState();
    widget.percentageCallback = (percentage) {
      _percentage = percentage;
      _offstage = false;
      if (!mounted) return;
      setState(() {});
    };
    widget.offstageCallback = (offstage) {
      _offstage = offstage;
      if (!mounted) return;
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Offstage(
        offstage: _offstage,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: Text(
            _percentage,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
