import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Carousel extends StatefulWidget {
  final List<String> imageUrls;
  Carousel(this.imageUrls);
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  List<String> urls = [];
  int current = 0;

  void _prevItem() {
    setState(() {
      current = current > 0 ? current - 1 : urls.length - 1;
    });
  }

  void _nextItem() {
    setState(() {
      current = current < urls.length - 1 ? current + 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    urls = widget.imageUrls;
    double pXStart = 0;
    double pxUpdate = 0;

    void _onDragEnd() {
      if (pXStart > pxUpdate) {
        _nextItem();
      } else {
        _prevItem();
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              GestureDetector(
                onHorizontalDragStart: (DragStartDetails details) {
                  pXStart = details.localPosition.dx;
                },
                onHorizontalDragUpdate: (DragUpdateDetails updateDetails) {
                  pxUpdate = updateDetails.localPosition.dx;
                },
                onHorizontalDragEnd: (DragEndDetails endDetails) {
                  _onDragEnd();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                      image: NetworkImage(urls[current]),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  width: 500,
                  height: 300,
                  // child: Text(urls[current]),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 110),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          border: Border.all(color: Colors.white70, width: 1.0),
                          borderRadius: BorderRadius.circular(25)),
                      child: IconButton(
                        color: Colors.white,
                        alignment: Alignment.center,
                        icon: Icon(
                          Icons.navigate_before,
                          size: 22.0,
                        ),
                        onPressed: _prevItem,
                      ),
                    ),
                    Expanded(
                      child: Text(''),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white70, width: 1.0),
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(25)),
                      child: IconButton(
                        color: Colors.white,
                        alignment: Alignment.center,
                        icon: Icon(
                          Icons.navigate_next,
                          size: 22.0,
                        ),
                        onPressed: _nextItem,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: 30,
                padding: EdgeInsets.only(left: 10.2, right: 10.2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    Center(
                      child: DotsForCarousel(
                        currentIndex: current,
                        numberOfDots: urls.length,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DotsForCarousel extends StatelessWidget {
  final numberOfDots;
  final currentIndex;

  DotsForCarousel({this.currentIndex, this.numberOfDots});

  Widget _inactiveDot() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 3, right: 3),
        child: Container(
          height: 7,
          width: 7,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }

  Widget _activeDot() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Container(
          height: 9,
          width: 9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDots() {
    List<Widget> dots = [];
    for (int i = 0; i < numberOfDots; i++) {
      dots.add(i == currentIndex ? _activeDot() : _inactiveDot());
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      children: _buildDots(),
    ));
  }
}
