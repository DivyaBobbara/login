import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  static const routeName = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(vsync: this,duration: Duration(seconds: 5));

    _animation = Tween<double>(
      begin: 1,
      end: 0,

    ).animate(_controller);

    // _controller.forward();
    _controller.repeat();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'),

      ),
      body: Center(
        child: Column(
          children: [ AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            // Here we're returning a Container widget that changes its opacity
            return Opacity(
              opacity: _animation.value,
              child: Container(
                height: 200,
                width: 200,
                color: Colors.blue,
              ),
            );
          },
      ),
         ScaleTransition(
              scale: _animation,
              child: const Text('Hello World'),
            ),

            // FadeInImage.memoryNetwork(
            //   placeholder: kTransparentImage,
            //   image:
            //   'https://images.unsplash.com/photo-1624118865283-8e00e1b9d75a',
            //   fit: BoxFit.cover,
            // ),
        ],
        ),
      ),


    );
  }
}
