import '/plugins.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _source = TextEditingController();
  // final TextEditingController _pwdController = TextEditingController();
  // final FocusNode _focusNode = FocusNode();

  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }

  static bool isURL(String s) => hasMatch(s,
      r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9-.]+.[a-zA-Z]{2,6}(:[0-9]{1,5})*(/($|[a-zA-Z0-9.,;?'\+&amp;%$#=~_-]+))*$");

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
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
                    height: 24,
                  ),
                  TextFormField(
                    autofocus: true,
                    // focusNode: _focusNode,
                    controller: _source,
                    decoration: const InputDecoration(
                      labelText: '影视源',
                      hintText: '请输入影视源',
                      icon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入影视源';
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
                          final videoStore = context.read<VideoSourceStore>();

                          if (isURL(source)) {
                            videoStore.setStore(VideoSource(
                              source: [source],
                              actived: source,
                            ));
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                MYRouter.homePagePath, (route) => false);
                          } else {
                            const snackBar = SnackBar(
                              content: Text("格式错误🙅"),
                            );
                            ScaffoldMessenger.of(context).removeCurrentSnackBar(
                              reason: SnackBarClosedReason.remove,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      },
                      child: Text(
                        '立刻观影',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.surface),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
