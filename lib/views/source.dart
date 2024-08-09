import '/plugins.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _source = TextEditingController(
    text: 'https://',
  );
  // final TextEditingController _pwdController = TextEditingController();

  static bool isURL(String s) =>
      RegExp(r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+").hasMatch(s);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bracket'),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: IntrinsicHeight(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Image(
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                      const SizedBox(
                        height: 88,
                      ),
                      TextFormField(
                        autofocus: true,
                        focusNode: FocusNode(),
                        controller: _source,
                        decoration: const InputDecoration(
                          labelText: '影视源',
                          hintText: '请输入影视源',
                          icon: Icon(Icons.link),
                        ),
                        validator: (value) {
                          if (!isURL(value ?? '')) {
                            return '格式错误🙅';
                          }
                          return null;
                        },
                      ),
                      // 登陆按钮
                      Container(
                        width: 300,
                        height: 55,
                        margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          onPressed: () async {
                            final source = _source.text;

                            if (_formKey.currentState?.validate() ?? false) {
                              final videoStore =
                                  context.read<VideoSourceStore>();

                              videoStore.setStore(VideoSource(
                                source: [source],
                                actived: source,
                              ));
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  MYRouter.homePagePath, (route) => false);

                              videoStore.setStore(VideoSource(
                                source: [source],
                                actived: source,
                              ));
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  MYRouter.homePagePath, (route) => false);
                            }
                          },
                          child: Text(
                            '立刻观影',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
