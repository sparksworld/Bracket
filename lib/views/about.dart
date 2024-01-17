import '../plugins.dart';

class AboutPage extends StatelessWidget {
  final String? arguments;
  const AboutPage({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于'),
      ),
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(0, 0, 0, 1),
          ),
        ),
      )),
    );
  }
}
