import 'dart:async';
import 'package:flutter/material.dart';

const String TAG = 'BannerWidget';

class BannerComponent extends StatefulWidget{

  final List<Widget> children;
  final int initIndex;
  final Duration intervalDuration;
  final Duration animationDuration;
  final bool cycleRolling;
  final bool autoRolling;
  final Curve curve;
  final ValueChanged onPageChanged;

  BannerComponent({
    Key key,
    @required this.children,
    this.initIndex = 0,
    this.intervalDuration = const Duration(seconds: 5),
    this.animationDuration = const Duration(milliseconds: 500),
    this.cycleRolling = true,
    this.autoRolling = true,
    this.curve = Curves.easeInOut,
    this.onPageChanged,
  }):
        assert(children?.isNotEmpty ?? true),
        assert(null != intervalDuration),
        assert(null != animationDuration),
        assert(null != cycleRolling),
        super(key: key);

  @override
  _BannerComponentState createState() => new _BannerComponentState();
}

class _BannerComponentState extends State<BannerComponent> {

  List<Widget> _originBanners = [];
  List<Widget> _banners = [];
  Duration _duration;
  PageController _pageController;
  int _currentIndex = 0;
  int _seriesUserScrollRecordCount = 0;
  Timer _timer;
  bool _canceledByManual = false;

  @override
  void initState() {
    super.initState();
    this._originBanners = widget.children;
    this._banners = this._banners..addAll(this._originBanners);
    if(widget.cycleRolling) {
      Widget first = this._originBanners[0];
      Widget last = this._originBanners[this._originBanners.length - 1];
      this._banners.insert(0, last);
      this._banners.add(first);
      this._currentIndex = widget.initIndex + 1;
    }else {
      this._currentIndex = widget.initIndex;
    }
    this._duration = widget.intervalDuration;
    this._pageController = PageController(initialPage: this._currentIndex);
    this._nextBannerTask();
  }

  void _nextBannerTask() {
    if(!mounted) {
      return;
    }
    if(!widget.autoRolling) {
      return;
    }
    this._cancel(manual: false);
    if(_seriesUserScrollRecordCount != 0) {
      return ;
    }
    _timer = new Timer(_duration, () {
      this._doChangeIndex();
    });
  }

  void _cancel({bool manual = false}) {
    _timer?.cancel();
    if(manual) {
      this._canceledByManual = true;
    }
  }

  void _doChangeIndex({bool increment = true}) {
    if(!mounted) {
      return;
    }
    this._canceledByManual = false;
    if(increment) {
      this._currentIndex++;
    }else{
      this._currentIndex--;
    }
    this._currentIndex = this._currentIndex % this._banners.length;
    if(0 == this._currentIndex) {
      this._pageController.jumpToPage(this._currentIndex);
      this._nextBannerTask();
      //setState(() {});
    }else{
      this._pageController.animateToPage(
        this._currentIndex,
        duration: widget.animationDuration,
        curve: widget.curve,
      ).whenComplete(() {
        if(!mounted) {
          return;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: PageView.builder(
        itemBuilder: (context, index) {
          return new GestureDetector(
            child: this._banners[index],
            onTapDown: (detail) {
              this._cancel(manual: true);
            },
          );
        },
        controller: this._pageController,
        itemCount: this._banners.length,
        onPageChanged: (index) {
          this._currentIndex = index;
          if(!(this._timer?.isActive ?? false)) {
            this._nextBannerTask();
          }
          setState(() {});
          if(null != widget.onPageChanged) {
            widget.onPageChanged(index);
          }
        },
        physics: ClampingScrollPhysics(),
      ),
      onNotification: (notification) {
        this._handleScrollNotification(notification);
      },
    );
  }

  void _handleScrollNotification(Notification notification) {
    void _resetWhenAtEdge(PageMetrics pm) {
      if(null == pm || !pm.atEdge) {
        return;
      }
      if(!widget.cycleRolling) {
        return;
      }
      try{
        if(this._currentIndex == 0) {
          this._pageController.jumpToPage(this._banners.length - 2);
        }else if(this._currentIndex == this._banners.length - 1) {
          this._pageController.jumpToPage(1);
        }
      }catch (e){
        print('Exception: ${e?.toString()}');
      }
    }

    void _handleUserScroll(UserScrollNotification notification) {
      UserScrollNotification sn = notification;

      PageMetrics pm = sn.metrics;
      var page = pm.page;
      var depth = sn.depth;

      var left = page == .0 ? .0 : page % (page.round());

      if(_seriesUserScrollRecordCount == 0) {
        this._cancel(manual: true);
      }
      if(depth == 0) {

        if(left == 0) {
          if (_seriesUserScrollRecordCount != 0) {
            setState(() {
              _seriesUserScrollRecordCount = 0;
              _canceledByManual = false;
              _resetWhenAtEdge(pm);
            });
            this._nextBannerTask();
          }else {
            _seriesUserScrollRecordCount ++;
          }
        }else {
          _seriesUserScrollRecordCount ++;
        }
      }
    }

    void _handleOtherScroll(ScrollUpdateNotification notification) {
      ScrollUpdateNotification sn = notification;
      if(widget.cycleRolling && sn.metrics.atEdge) {
        if(this._canceledByManual) {
          return;
        }
        _resetWhenAtEdge(sn.metrics);
      }
    }

    if(notification is UserScrollNotification) {

      _handleUserScroll(notification);
    }else if(notification is ScrollUpdateNotification) {

      _handleOtherScroll(notification);
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _cancel();
    super.dispose();
  }
}