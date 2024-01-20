import 'package:bracket/plugins.dart';

class LoadingView extends StatelessWidget {
  final Function(BuildContext) builder;
  final bool loading;

  const LoadingView({Key? key, required this.loading, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Center(
          child: SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      );
    }
    return builder(context);
  }
}
