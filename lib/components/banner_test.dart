import 'package:flutter/material.dart';
import 'package:flutter_common/widget/banner/banner.dart';

class BannerTest extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      height: 256.0,
      child: BannerWidget(
          children: [
            Container(
              child: Image.network("http://attach.bbs.miui.com/forum/201708/03/104453y7qi0iqv44rvl6nn.jpg", fit: BoxFit.cover,)
            ),
            Container(
                child: Image.network("http://attach.bbs.miui.com/album/201605/09/155052ru0wm064s8jh0mju.jpg", fit: BoxFit.cover,)
            ),
            Container(
                child: Image.network("http://attachments.gfan.com/forum/attachments2/day_110514/110514014419e664eeb0365e38.jpg", fit: BoxFit.cover,)
            ),
            Container(
                child: Image.network("http://img.mp.itc.cn/upload/20170324/663c85eae74f4320a3e382f03af76d52_th.jpg", fit: BoxFit.cover,)
            )
          ]
      ),
    );
  }
}