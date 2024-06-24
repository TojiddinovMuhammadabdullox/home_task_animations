import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: const SwitchButtonDemo(),
        );
      },
    );
  }
}

ValueNotifier<bool> themeNotifier = ValueNotifier(false);

class SwitchButtonDemo extends StatefulWidget {
  const SwitchButtonDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SwitchButtonDemoState createState() => _SwitchButtonDemoState();
}

class _SwitchButtonDemoState extends State<SwitchButtonDemo> {
  bool isSwitched = false;
  int currentPage = 0;
  late PageController pageController;
  late Timer timer;

  List<Widget> carouselItems = [
    Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              image: AssetImage("assets/images/bg1.png"))),
    ),
    Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              image: AssetImage("assets/images/bg2.png"))),
    ),
    Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              image: AssetImage("assets/images/bg3.png"))),
    ),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentPage);
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    pageController.dispose();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (currentPage < carouselItems.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Switch and Carousel"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isSwitched = !isSwitched;
                themeNotifier.value = isSwitched;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 100.0,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.transparent,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/images/cloud.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    left: isSwitched ? 50.0 : 0.0,
                    right: isSwitched ? 0.0 : 50.0,
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Center(
                        child: Image.asset(
                          isSwitched
                              ? "assets/images/reverse_plane.png"
                              : "assets/images/airplane.png",
                          color: isSwitched ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: carouselItems.length,
              controller: pageController,
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: carouselItems[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
