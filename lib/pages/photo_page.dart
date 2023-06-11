import 'package:flutter/material.dart';
import 'package:josequal/models/image_model.dart';
import 'package:josequal/services/database/DatabaseHelper.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({required this.imageModel, required this.fav, Key? key})
      : super(key: key);
  final ImageModel imageModel;
  final bool fav;

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final double infoBorderRadius = 32;
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    bool isFav = widget.fav;

    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    Future<void> addToFav() async {
      try {
        await DatabaseHelper.createImage(widget.imageModel);
      } catch (e) {
        print(e.toString());
      }
    }

    Future<void> removeFromFav() async {
      try {
        await DatabaseHelper.deleteItem(widget.imageModel.id);
      } catch (e) {
        print(e.toString());
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                  height: fullHeight,
                  width: fullWidth,
                  child: Image.network(
                    widget.imageModel.src,
                    fit: BoxFit.fitHeight,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress != null) {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      } else {
                        return child;
                      }
                    },
                  )),
            ),
            AnimatedPositioned(
              bottom: isTapped ? 0 : -100,
              duration: const Duration(milliseconds: 250),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                height: 150,
                width: fullWidth,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: () {
                              setState(() {
                                isTapped = !isTapped;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: isFav ? Colors.red : Colors.white,
                              size: 32,
                            ),
                            onPressed: () async {
                              if(isFav){
                                await removeFromFav();
                              }else{
                                await addToFav();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Text('Photographer: ${widget.imageModel.owner}',
                        style: TextStyle(color: Colors.white)),
                    Text('Image ID: ${widget.imageModel.id}',
                        style: TextStyle(color: Colors.white))
                  ]
                      .map(
                        (widget) => SizedBox(
                          height: 50,
                          child: widget,
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
