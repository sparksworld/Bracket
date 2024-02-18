import 'package:bracket/plugins.dart';

class SearchHeader extends SliverPersistentHeaderDelegate {
  final double minTopBarHeight = 100;
  final double maxTopBarHeight = 200;
  final String title;
  // final IconData icon;
  final Widget search;

  SearchHeader({
    required this.title,
    // required this.icon,
    required this.search,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // var top = MediaQuery.of(context).padding.top;
    var shrinkFactor = min(1, shrinkOffset / (maxExtent - minExtent));

    var bgTopBar = Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        alignment: Alignment.center,
        height: max(maxTopBarHeight * (1 - shrinkFactor), minTopBarHeight),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          // border: Border.all(
          //   color: Theme.of(context).primaryColor.withOpacity(0.5),
          //   width: 4,
          //   strokeAlign: BorderSide.strokeAlignOutside,
          // ),
          // color: Theme.of(context).colorScheme.inversePrimary,
          // gradient: LinearGradient(
          //   colors: [
          //     Theme.of(context).colorScheme.inversePrimary,
          //     Theme.of(context).colorScheme.primaryContainer
          //   ],
          // ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(5, 5),
              blurRadius: 10,
              color: Theme.of(context)
                  .colorScheme
                  .inversePrimary
                  .withOpacity(0.23),
            )
          ],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(36),
          ),
        ),
        // width: 100,
        child: SafeArea(
          bottom: false,
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 28),
              child: Text(
                title,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
    return SizedBox(
      height: max(maxExtent - shrinkOffset, minExtent),
      child: Stack(
        fit: StackFit.loose,
        children: [
          if (shrinkFactor <= 0.5) bgTopBar,
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                alignment: Alignment.center,
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(5, 5),
                        blurRadius: 10,
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.23),
                      )
                    ]),
                child: search,
              ),
            ),
          ),
          if (shrinkFactor > 0.5) bgTopBar,
        ],
      ),
    );
  }

  @override
  double get maxExtent => maxTopBarHeight + 30;

  @override
  double get minExtent => minTopBarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
