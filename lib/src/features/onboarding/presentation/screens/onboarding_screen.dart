import 'package:flutter/material.dart';
import 'package:routiner/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

List screens = [
  Container(color: Colors.blue),
  Container(color: Colors.green),
  Container(color: Colors.yellow)
];

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Screens
          PageView.builder(
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            controller: _controller,
            itemCount: 3,
            itemBuilder: (context, index) {
              return screens[index];
            },
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Dot Indicators
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const ExpandingDotsEffect(
                        dotColor: Colors.white,
                        radius: 10,
                        dotWidth: 10,
                        dotHeight: 10.0),
                  ),

                  //Button
                  onLastPage
                      ? ElevatedButton(
                          onPressed: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool('onboardingViewed', true);
                            if (!mounted) return;
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) {
                                return const MyHomePage(title: "Home Page");
                              },
                            ));
                          },
                          child: const Text("DONE"))
                      : ElevatedButton(
                          onPressed: () {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 510),
                                curve: Curves.easeIn);
                          },
                          child: const Text("NEXT"))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
