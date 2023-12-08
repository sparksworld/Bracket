import '../plugins.dart';

class About extends StatelessWidget {
  final String? arguments;
  static const String routeName = "about";
  const About({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('about'),
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
