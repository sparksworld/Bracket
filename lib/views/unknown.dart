import '/plugins.dart';

class Unknown extends StatelessWidget {
  final String? arguments;
  static const String routeName = "unknown";
  const Unknown({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unknown'),
      ),
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(0, 0, 0, 1))),
      )),
    );
  }
}
