import 'package:bracket/plugins.dart';

class LoadingView extends StatefulWidget {
  final Widget child;
  final bool loading;

  const LoadingView({Key? key, required this.loading, required this.child})
      : super(key: key);

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  Widget build(BuildContext context) {
    return widget.loading ? _buildLoadingView(context) : widget.child;
  }
}

/// 加载中 View
Widget _buildLoadingView(BuildContext context) {
  return Container(
    color: Colors.red,
    child: Center(
      child: SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
      ),
    ),
  );
}
