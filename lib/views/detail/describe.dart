import 'package:bracket/model/film_detail/data.dart';
import 'package:bracket/model/film_detail/detail.dart';
import 'package:bracket/plugins.dart';

class Describe extends StatefulWidget {
  final Data? data;
  const Describe({Key? key, this.data}) : super(key: key);

  @override
  State<Describe> createState() => _DescribeState();
}

class _DescribeState extends State<Describe> {
  Detail? get _detail {
    return widget.data?.detail;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              (_detail?.descriptor?.blurb ?? '').trim(),
            ),
          ],
        ),
      ),
    );
  }
}
