import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoPlayPause extends StatefulWidget {
  final VideoPlayerController controller;

  VideoPlayPause(this.controller);

  @override
  State createState() {
    return new _VideoPlayPauseState();
  }
}

class _VideoPlayPauseState extends State<VideoPlayPause> {
  Widget imageFadeAnim =
      new FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
  VoidCallback listener;

  _VideoPlayPauseState() {
    listener = () {
      setState(() {});
    };
  }

  VideoPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
    controller.setVolume(1.0);
    controller.play();
  }

  @override
  void deactivate() {
    controller.setVolume(0.0);
    controller.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    final List<Widget> children = <Widget>[
      new GestureDetector(
        child: new VideoPlayer(controller),
        onTap: () {
          if (!controller.value.initialized) {
            return;
          }
          if (controller.value.isPlaying) {
            imageFadeAnim = Icon(
              Icons.pause,
              size: 60.0,
              color: primaryColor,
            );
            controller.pause();
          } else {
            imageFadeAnim = new FadeAnimation(
                child: Icon(
              Icons.play_arrow,
              size: 60.0,
              color: primaryColor,
            ));
            controller.play();
          }
        },
      ),
      new Align(
        alignment: Alignment.bottomCenter,
        child: controller.value.isPlaying
            ? null
            : new Opacity(
                opacity: 0.8,
                child: new Container(
                    height: 30.0,
                    color: Colors.black45,
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Container(
                            padding: new EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: new Text(
                                "${controller.value.position.toString().split(".")[0]}",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                        Expanded(
                          child: new VideoProgressIndicator(
                            controller,
                            allowScrubbing: true,
                            colors:
                                VideoProgressColors(playedColor: primaryColor),
                          ),
                        ),
                        Container(
                            padding: new EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: new Text(
                                "${controller.value.duration.toString().split(".")[0]}",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    )),
              ),
      ),
//      new Align(
//        alignment: Alignment.topLeft,
//        child: controller.value.isPlaying ? null : IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed: (){ Navigator.pop(context);}),
//      ),
      new Center(
          child: GestureDetector(
        child: imageFadeAnim,
        onTap: () {
          if (!controller.value.initialized) {
            return;
          }
          if (controller.value.isPlaying) {
            imageFadeAnim = Icon(
              Icons.pause,
              size: 60.0,
              color: primaryColor,
            );
            controller.pause();
          } else {
            imageFadeAnim = new FadeAnimation(
                child: Icon(
              Icons.play_arrow,
              size: 60.0,
              color: primaryColor,
            ));
            controller.play();
          }
        },
      )),
      new Center(
          child: controller.value.isBuffering
              ? const CircularProgressIndicator()
              : null),
    ];

    return new Stack(
      fit: StackFit.passthrough,
      children: children,
    );
  }
}

class FadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  FadeAnimation({this.child, this.duration: const Duration(milliseconds: 500)});

  @override
  _FadeAnimationState createState() => new _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        new AnimationController(duration: widget.duration, vsync: this);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return animationController.isAnimating
        ? new Opacity(
            opacity: 1.0 - animationController.value,
            child: widget.child,
          )
        : new Container();
  }
}

typedef Widget VideoWidgetBuilder(
    BuildContext context, VideoPlayerController controller);

abstract class PlayerLifeCycle extends StatefulWidget {
  final VideoWidgetBuilder childBuilder;
  final String dataSource;

  PlayerLifeCycle(this.dataSource, this.childBuilder);
}

abstract class _PlayerLifeCycleState extends State<PlayerLifeCycle> {
  VideoPlayerController controller;

  @override

  /// Subclasses should implement [createVideoPlayerController], which is used
  /// by this method.
  void initState() {
    super.initState();
    controller = createVideoPlayerController();
    controller.addListener(() {
      if (controller.value.hasError) {
        print(controller.value.errorDescription);
      }
    });
    controller.initialize();
    controller.setLooping(true);
    controller.play();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.childBuilder(context, controller);
  }

  VideoPlayerController createVideoPlayerController();
}

/// A widget connecting its life cycle to a [VideoPlayerController] using
/// a data source from the network.
class NetworkPlayerLifeCycle extends PlayerLifeCycle {
  NetworkPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
      : super(dataSource, childBuilder);

  @override
  _NetworkPlayerLifeCycleState createState() =>
      new _NetworkPlayerLifeCycleState();
}

class _NetworkPlayerLifeCycleState extends _PlayerLifeCycleState {
  @override
  VideoPlayerController createVideoPlayerController() {
    return new VideoPlayerController.network(widget.dataSource);
  }
}

/// A widget connecting its life cycle to a [VideoPlayerController] using
/// an asset as data source
class AssetPlayerLifeCycle extends PlayerLifeCycle {
  AssetPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
      : super(dataSource, childBuilder);

  @override
  _AssetPlayerLifeCycleState createState() => new _AssetPlayerLifeCycleState();
}

class _AssetPlayerLifeCycleState extends _PlayerLifeCycleState {
  @override
  VideoPlayerController createVideoPlayerController() {
    return new VideoPlayerController.asset(widget.dataSource);
  }
}

class AspectRatioVideo extends StatefulWidget {
  final VideoPlayerController controller;

  AspectRatioVideo(this.controller);

  @override
  AspectRatioVideoState createState() => new AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    listener = () {
      if (!mounted) {
        return;
      }
      if (initialized != controller.value.initialized) {
        initialized = controller.value.initialized;
        setState(() {});
      }
    };
    controller.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      final Size size = controller.value.size;
      return new Center(
        child: new AspectRatio(
          aspectRatio: size.width / size.height,
          child: new VideoPlayPause(controller),
        ),
      );
    } else {
      return new Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

class NetVideo extends StatelessWidget {
  final String source;

  NetVideo(this.source);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: new NetworkPlayerLifeCycle(
        source,
        (BuildContext context, VideoPlayerController controller) =>
            new AspectRatioVideo(controller),
      ),
    );
  }
}

class AssetVideo extends StatelessWidget {
  final String assets;

  AssetVideo(this.assets);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: new AssetPlayerLifeCycle(
          assets,
          (BuildContext context, VideoPlayerController controller) =>
              new AspectRatioVideo(controller)),
    );
  }
}

class VideoNetFullPage extends StatefulWidget {
  final String source;

  VideoNetFullPage(this.source);

  @override
  _VideoNetFullPageState createState() => _VideoNetFullPageState();
}

class _VideoNetFullPageState extends State<VideoNetFullPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: NetVideo(widget.source));
  }
}
