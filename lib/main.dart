import 'package:flutter/material.dart';
import 'package:josequal/custom_widgets/category_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(.7), Colors.transparent],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CategoryButton(
                    onPressed: () {
                      print('All');
                    },
                    text: 'All',
                    height: 30,
                    padding: 10,
                    borderRadius: 20,
                    shadowBlurRadius: 2,
                  ),
                  CategoryButton(
                    onPressed: () {
                      print('Phone');
                    },
                    text: 'Phone',
                    height: 30,
                    padding: 10,
                    borderRadius: 20,
                    shadowBlurRadius: 2,
                  ),
                  CategoryButton(
                    onPressed: () {
                      print('Phone');
                    },
                    text: 'Desktop',
                    height: 30,
                    padding: 10,
                    borderRadius: 20,
                    shadowBlurRadius: 2,
                  )
                ]
                    .map((widget) => Padding(
                          padding: EdgeInsets.all(10),
                          child: widget,
                        ))
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
