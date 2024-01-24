import '/plugins.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _uNameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  // final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登陆'),
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
                    controller: _uNameController,
                    decoration: const InputDecoration(
                      labelText: '用户名',
                      hintText: '请输入用户名',
                      icon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入用户名';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _pwdController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: '密码',
                      labelText: '密码',
                      icon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入密码';
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
                        final uName = _uNameController.text;
                        final pword = _pwdController.text;

                        if (_formKey.currentState?.validate() ?? false) {
                          if (uName == 'spark' && pword == "88888888") {
                            context.read<Profile>().setData({
                              "user_id": 1121,
                              "user_token":
                                  base64Encode(utf8.encode('$uName-$pword')),
                              "user_name": Random().nextInt(10).toString(),
                              "user_avator": 'dawdaw',
                              "user_phone": 12212,
                            });

                            Navigator.of(context).pushNamedAndRemoveUntil(
                                MYRouter.homePagePath, (route) => false);
                          } else {
                            const snackBar = SnackBar(
                              content: Text("账号密码错误🙅"),
                            );
                            ScaffoldMessenger.of(context).removeCurrentSnackBar(
                              reason: SnackBarClosedReason.remove,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                        // print(_formKey.currentState?.validate());
                        // print(_uNameController.text);
                        // print(_pwdController.text);
                      },
                      child: Text(
                        '登陆',
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
