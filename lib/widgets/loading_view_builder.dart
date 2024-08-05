import '/plugins.dart';

class LoadingViewBuilder extends StatelessWidget {
  final Function(BuildContext) builder;
  final bool loading;

  const LoadingViewBuilder(
      {Key? key, required this.loading, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Loading();
    }
    return builder(context);
  }
}
