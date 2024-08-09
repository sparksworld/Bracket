import "/plugins.dart";
import '/model/index/content.dart';
import '/model/index/movie.dart';

class MovieGrid extends StatelessWidget {
  final Content? content;
  final UniqueKey imgKey;
  const MovieGrid({super.key, required this.content, required this.imgKey});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      // color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getMovieGridHeader(context, content),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Wrap(
                spacing: 12,
                children: (content?.movies ?? []).map(
                  (e) {
                    return SizedBox(
                      width: 120,
                      height: 240,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            MYRouter.detailPagePath,
                            arguments: {
                              'id': e.id,
                            },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getMovieGridContent(context, e, imgKey),
                            getMovieGridFooter(context, e)
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),

            // GridView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   padding: const EdgeInsets.all(10.0),
            //   itemCount: content?.movies?.length,
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 4,
            //     mainAxisSpacing: 12.0,
            //     crossAxisSpacing: 12.0,
            //     childAspectRatio: .65,
            //   ),
            //   itemBuilder: (BuildContext context, int index) {
            //     // print(content?.movies?.length);
            //     var movie = content?.movies?[index];
            //     return GestureDetector(
            //       onTap: () {
            //         Navigator.pushNamed(
            //           context,
            //           MYRouter.detailPagePath,
            //           arguments: {
            //             'id': movie?.id,
            //           },
            //         );
            //       },
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           getMovieGridContent(context, movie),
            //           getMovieGridFooter(context, movie)
            //         ],
            //       ),
            //     );
            //   },
            // ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

Widget getMovieGridHeader(BuildContext context, Content? content) {
  return Container(
    padding: const EdgeInsets.all(12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          content?.nav?.name ?? '',
          // style: Theme.of(context).textTheme.titleLarge,
          style: TextStyle(
            // color: Theme.of(context).primaryColorLight,
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(MYRouter.filterPagePath,
                arguments: {'pid': content?.nav?.id});
          },
          child: Row(
            children: [
              Text(
                '查看更多',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: Theme.of(context).textTheme.bodyMedium?.fontSize,
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget getMovieGridContent(BuildContext context, Movie? movie, key) => Expanded(
      flex: 1,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey,
            ),
            child: Image(
              fit: BoxFit.cover,
              loadingBuilder:
                  (BuildContext _, Widget widget, ImageChunkEvent? event) {
                if (event == null) {
                  return widget;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: event.expectedTotalBytes != null
                        ? event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              width: double.infinity,
              height: double.infinity,
              image: NetworkImage(
                '${movie?.picture}?$key',
              ),
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset(
                  fit: BoxFit.cover,
                  'assets/images/logo.png',
                );
              },
            ),
          ),
          Positioned(
            top: 4,
            left: 4,
            right: 4,
            bottom: 0,
            child: IntrinsicHeight(
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(200),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        movie?.year ?? '',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(200),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        movie?.cName ?? '',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(200),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        movie?.remarks ?? '',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

Widget getMovieGridFooter(BuildContext context, Movie? movie) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie?.name ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            (movie?.subTitle?.trim().isEmpty ?? true)
                ? '暂无'
                : movie?.subTitle?.trim() ?? '暂无',
            style: TextStyle(
              color: Theme.of(context).disabledColor,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 1,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
