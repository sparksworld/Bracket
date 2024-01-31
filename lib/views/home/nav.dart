import 'package:bracket/plugins.dart';
import 'package:rive/rive.dart';

const Color bottonNavBgColor = Color(0xFF17203A);

List<RiveModel> bottomNavItems = [
  RiveModel(
      src: "assets/rive/animated_icons.riv",
      artboard: "HOME",
      stateMachineName: "HOME_interactivity"),
  RiveModel(
      src: "assets/rive/animated_icons.riv",
      artboard: "LIKE/STAR",
      stateMachineName: "STAR_Interactivity"),
  RiveModel(
      src: "assets/rive/animated_icons.riv",
      artboard: "USER",
      stateMachineName: "USER_Interactivity"),
];

class BottonNavWithAnimatedIcons extends StatefulWidget {
  final int index;
  final Function(int) onChange;
  const BottonNavWithAnimatedIcons(
      {super.key, required this.index, required this.onChange});

  @override
  State<BottonNavWithAnimatedIcons> createState() =>
      _BottonNavWithAnimatedIconsState();
}

class _BottonNavWithAnimatedIconsState
    extends State<BottonNavWithAnimatedIcons> {
  List<SMIBool> riveIconInputs = [];
  List<StateMachineController?> controllers = [];
  // int selctedNavIndex = widget.index;

  void animateTheIcon(int index) {
    riveIconInputs[index].change(true);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        riveIconInputs[index].change(false);
      },
    );
  }

  void riveOnInIt(Artboard artboard, {required String stateMachineName}) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, stateMachineName);

    artboard.addController(controller!);
    controllers.add(controller);

    riveIconInputs.add(controller.findInput<bool>('active') as SMIBool);
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BottonNavWithAnimatedIcons oldWidget) {
    if (oldWidget.index != widget.index) {
      animateTheIcon(widget.index);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: BottomNavigationBarTheme.of(context).backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: bottonNavBgColor.withOpacity(0.3),
              offset: const Offset(0, 20),
              blurRadius: 20,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              bottomNavItems.length,
              (index) {
                final riveIcon = bottomNavItems[index];
                return Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      // animateTheIcon(index);
                      widget.onChange(index);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: Opacity(
                            opacity: widget.index == index ? 1 : 0.5,
                            child: RiveAnimation.asset(
                              riveIcon.src,
                              artboard: riveIcon.artboard,
                              onInit: (artboard) {
                                riveOnInIt(artboard,
                                    stateMachineName:
                                        riveIcon.stateMachineName);
                              },
                            ),
                          ),
                        ),
                        AnimatedBar(isActive: widget.index == index),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: BoxDecoration(
        color: BottomNavigationBarTheme.of(context).selectedItemColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}
