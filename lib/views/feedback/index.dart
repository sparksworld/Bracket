import '/plugins.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _inputController = TextEditingController();
  String text = "";

  @override
  void initState() {
    _inputController.addListener(() {
      setState(() {
        text = _inputController.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('意见反馈')),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          // color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _inputController,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                width: 300,
                height: 60,
                child: ElevatedButton(
                  onPressed: (text != '')
                      ? () {
                          const snackBar = SnackBar(
                            content: Text("提交成功"),
                          );
                          ScaffoldMessenger.of(context).removeCurrentSnackBar(
                            reason: SnackBarClosedReason.remove,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      : null,
                  child: const Text('提交'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
