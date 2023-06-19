import 'package:animated_check/animated_check.dart';
import 'package:flutter/material.dart';
import 'package:animated_cross/animated_cross.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Loading extends StatefulWidget {
  const Loading({Key? key, required this.uploadStatus}) : super(key: key);

  final ValueNotifier uploadStatus;

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  //VARIABLES

  late AnimationController _animationController;
  late Animation<double> _animation;

  //FUNCTIONS

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCirc));
  }


  //UI

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastLinearToSlowEaseIn,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: ValueListenableBuilder(
                    valueListenable: widget.uploadStatus,
                    builder: (context, value, child) {
                      if (value == 'success') {
                        _animationController.forward();
                        return AnimatedCheck(
                          progress: _animation,
                          size: 110,
                          color: Color(0xff4682b4),
                        );
                      } else if (value == 'failed') {
                        _animationController.forward();
                        return AnimatedCross(
                          progress: _animation,
                          size: 110,
                          color: Colors.redAccent,
                        );
                      } else {
                        return const SpinKitDoubleBounce(
                          color: Color(0xff4682b4),
                          size: 50.0,
                        );
                      }
                    },
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
