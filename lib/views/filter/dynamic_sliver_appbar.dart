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
      // snap: true,
      pinned: true,
      // stretchTriggerOffset: (isHeightCalculated ? height : widget.maxHeight),
      floating: true,
      centerTitle: false,
      // primary: false,
      toolbarHeight: toolbarHeight,
      expandedHeight: (isHeightCalculated ? height : widget.maxHeight) +
          widget.bottom!.preferredSize.height,
      bottom: widget.bottom,
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
