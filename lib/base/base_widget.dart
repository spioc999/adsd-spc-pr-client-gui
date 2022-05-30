import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [BaseWidget] is a [StatelessWidget] used as base for each screen.
/// It is wrapped by a [WillPopScope] widget, which permits to handle the tap on physical back.
/// Inside of that there is an [AnnotatedRegion] widget, whose task is to define the style for the
/// status bar of the smartphone. Then, as child of the last one, there is a [Scaffold], widget
/// full of API to design the screen with [bottomNavigationBar] or [floatingActionButton] and so on.
/// To avoid components invisible due to notch, [SafeArea] widget adds if booleans values [safeAreaBottom] and
/// [safeAreaTop] an internal padding.

class BaseWidget extends StatelessWidget {

  final Widget child;
  final bool safeAreaBottom;
  final bool safeAreaTop;
  final bool isLoading;
  final bool resizeToAvoidBottomInset;
  final BottomAppBar? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final WillPopCallback? onWillPop;
  final SystemUiOverlayStyle? overlayStyle;
  final Color backgroundColorBody;

  const BaseWidget({
    Key? key,
    required this.child,
    this.safeAreaBottom = false,
    this.safeAreaTop = false,
    this.isLoading = false,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.onWillPop,
    this.overlayStyle,
    this.resizeToAvoidBottomInset = false,
    this.backgroundColorBody = Colors.white
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: onWillPop != null && onWillPop is WillPopCallback ? () => onWillPop!() : () => Future.value(true),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle ?? SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          body: Stack(
            children: [
              Center(
                child: SafeArea(
                  top: safeAreaTop,
                  bottom: safeAreaBottom,
                  child: Container(
                    color: backgroundColorBody,
                    width: double.infinity,
                    height: double.infinity,
                    child: child,
                  ),
                ),
              ),
              Visibility(
                visible: isLoading,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                      )
                    ),
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
            )
            ],
          ),
        ),
      ),
    );
  }
}
