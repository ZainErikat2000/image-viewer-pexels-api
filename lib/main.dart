import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:josequal/ViewModel/ImagesView/ImagesStates.dart';
import 'package:josequal/custom_widgets/category_button.dart';
import 'package:josequal/custom_widgets/search_field.dart';
import 'package:josequal/pages/photo_page.dart';
import 'package:josequal/services/database/DatabaseHelper.dart';

import 'ViewModel/ImagesView/ImagesCubit.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<ImagesCubit>(
        create: (context) => ImagesCubit()..getCuratedImages(),
        child: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();

  void _asyncMethod() async {
    await DatabaseHelper.db();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x0f0f0f0f),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              child: BlocConsumer<ImagesCubit, Map<String, dynamic>>(
                  listener: (context, map) {
                if (map['state'] is ImagesErrorState) {
                  showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      backgroundColor: Colors.deepOrange,
                      title: Text('Sorry, an Issue Occurred'),
                      content: Text('Try Again Later'),
                    ),
                  );
                }
              }, builder: (context, map) {
                if (map['state'] is ImagesLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (map['data'].length == 0) {
                  return const Center(
                    child: Text(
                      'No Images Here. Sorry!',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:
                            MediaQuery.of(context).size.width / 2,
                        mainAxisExtent: 300,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10),
                    children: List.generate(
                      map['data'].length,
                      (index) => InkWell(
                        onTap: () async {
                          bool fav = await DatabaseHelper.findFav(
                              map['data'][index].id);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoPage(
                                imageModel: map['data'][index],
                                fav: fav,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            image: NetworkImage(map['data'][index].small),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            Positioned(
              top: 0,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(1), Colors.transparent],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CategoryButton(
                      onPressed: () async {
                        context.read<ImagesCubit>().getCuratedImages();
                      },
                      text: 'Browse',
                      height: 30,
                      padding: 10,
                      borderRadius: 20,
                      shadowBlurRadius: 2,
                    ),
                    CategoryButton(
                      onPressed: () {
                        context.read<ImagesCubit>().getFavourites();
                      },
                      text: 'Favourites',
                      height: 30,
                      padding: 10,
                      borderRadius: 20,
                      shadowBlurRadius: 2,
                    ),
                  ]
                      .map((widget) => Padding(
                            padding: EdgeInsets.all(10),
                            child: widget,
                          ))
                      .toList(),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(1)],
                  ),
                ),
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                boxShadow: const [BoxShadow(blurRadius: 2)],
                                borderRadius: BorderRadius.circular(32)),
                            width: MediaQuery.of(context).size.width * .5,
                            child: SearchField(
                              controller: searchController,
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            if (searchController.text.isEmpty) {
                              return;
                            }

                            context.read<ImagesCubit>().getSearchImages(
                                searchTerm: searchController.text);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32)),
                            width: 60,
                            height: 60,
                            child: const Center(
                              child: Icon(Icons.search, size: 32),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
