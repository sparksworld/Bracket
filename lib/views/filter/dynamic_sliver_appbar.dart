import 'package:bracket/plugins.dart';

class DynamicSliverAppBar extends StatefulWidget {
  final PreferredSizeWidget? bottom;
  final Widget child;
  final double maxHeight;

  const DynamicSliverAppBar({
    required this.child,
    required this.maxHeight,
    this.bottom,
    Key? key,
  }) : super(key: key);

  @override
  State<DynamicSliverAppBar> createState() => _DynamicSliverAppBarState();
}

class _DynamicSliverAppBarState extends State<DynamicSliverAppBar> {
  final GlobalKey _childKey = GlobalKey();
  bool isHeightCalculated = false;
  double height = 0;
  double toolbarHeight = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!isHeightCalculated) {
        setState(() {
          height = (_childKey.currentContext?.findRenderObject() as RenderBox)
              .size
              .height;
        });
        isHeightCalculated = true;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      snap: true,
      pinned: true,
      floating: true,
      centerTitle: false,
      stretch: true,
      // primary: false,
      toolbarHeight: toolbarHeight,
      stretchTriggerOffset: height > 0 ? height / 2 : 100,
      expandedHeight: (isHeightCalculated ? height : widget.maxHeight) +
          (widget.bottom?.preferredSize.height ?? 0),
      bottom: widget.bottom,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NotificationListener<SizeChangedLayoutNotification>(
              onNotification: (notification) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {
                    height = (_childKey.currentContext?.findRenderObject()
                            as RenderBox)
                        .size
                        .height;
                  });
                  isHeightCalculated = true;
                });
                return false;
              },
              child: SizeChangedLayoutNotifier(
                child: Container(
                  // padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
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
