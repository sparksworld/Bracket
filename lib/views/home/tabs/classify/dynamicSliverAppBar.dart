import 'package:bracket/plugins.dart';

class DynamicSliverAppBar extends StatefulWidget {
  final Widget child;
  final double maxHeight;

  const DynamicSliverAppBar({
    required this.child,
    required this.maxHeight,
    Key? key,
  }) : super(key: key);

  @override
  State<DynamicSliverAppBar> createState() => _DynamicSliverAppBarState();
}

class _DynamicSliverAppBarState extends State<DynamicSliverAppBar> {
  final GlobalKey _childKey = GlobalKey();
  bool isHeightCalculated = false;
  double? height;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!isHeightCalculated) {
        isHeightCalculated = true;
        setState(() {
          height = (_childKey.currentContext?.findRenderObject() as RenderBox)
              .size
              .height;
        });
      }
    });

    return SliverAppBar(
      pinned: false,
      snap: true,
      floating: true,
      toolbarHeight: 0,
      expandedHeight: isHeightCalculated ? height : widget.maxHeight,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NotificationListener<SizeChangedLayoutNotification>(
              onNotification: (notification) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  isHeightCalculated = true;
                  setState(() {
                    height = (_childKey.currentContext?.findRenderObject()
                            as RenderBox)
                        .size
                        .height;
                  });
                });
                return false;
              },
              child: SizeChangedLayoutNotifier(
                child: Container(
                  key: _childKey,
                  child: widget.child,
                ),
              ),
            ),
            const Expanded(
              child: SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }
}
