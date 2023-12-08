import '/plugins.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _uNameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  // final FocusNode _focusNode = FocusNode();

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
                  TextFormField(
                    autofocus: true,
                    // focusNode: _focusNode,
                    controller: _uNameController,
                    decoration: const InputDecoration(
                      labelText: '用户名',
                      hintText: 'username',
                      icon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
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
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  // 登陆按钮
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: ElevatedButton(
                      // style: ButtonStyle(),
                      onPressed: () async {
                        final uName = _uNameController.text;
                        final pword = _pwdController.text;
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<Profile>().setData({
                            "user_id": 1121,
                            "user_token":
                                base64Encode(utf8.encode('$uName-$pword')),
                            "user_name": Random().nextInt(10).toString(),
                            "user_avator": 'dawdaw',
                            "user_phone": 12212,
                          });
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text(Env.envConfig.appDomain),
                          //   ),
                          // );

                          Navigator.of(context).pushNamedAndRemoveUntil(
                              MYRouter.homePath, (route) => false);
                        }

                        // print(_formKey.currentState?.validate());
                        // print(_uNameController.text);
                        // print(_pwdController.text);
                      },
                      child: const Text('登陆'),
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

// class Login extends StatelessWidget {
//   Login({Key? key}) : super(key: key);

//   // final FocusNode _focusNode = FocusNode();

// }

// text: '登陆',
//                   onTap: () => {
//                     //  登陆接入
//                     if ((_formKey.currentState as FormState).validate())
//                       {
//                         //  验证通过提交数据(登录)
//                         print(_uNameController.text),
//                         print(_pwdController.text)
//                       }
//                   },
