import 'package:bracket/plugins.dart';
import 'package:card_swiper/card_swiper.dart';

class MySwiper extends StatelessWidget {
  const MySwiper({super.key});

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Image.network(
          "https://via.placeholder.com/350x150",
          fit: BoxFit.cover,
        );
      },
      itemCount: 3,
      viewportFraction: 0.8,
      scale: 0.9,
      pagination: const SwiperPagination(),
      control: const SwiperControl(),
    );
  }
}