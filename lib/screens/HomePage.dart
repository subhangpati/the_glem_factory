import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_glem_factory/components/appWidgets/SideDrawer.dart';
import 'package:the_glem_factory/components/appWidgets/getIndicator.dart';
import 'package:the_glem_factory/components/appWidgets/guideLinesBar.dart';
import 'package:the_glem_factory/components/appWidgets/homeImageCarousel.dart';
import 'package:the_glem_factory/components/appWidgets/offersCarousel.dart';
import 'package:the_glem_factory/components/appWidgets/videoPlayer.dart';
import 'package:the_glem_factory/model/home_service_model.dart';
import 'package:the_glem_factory/screens/Cart.dart';
import 'package:video_player/video_player.dart';

import '../constant.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xffFFFAFA),
          scaffoldBackgroundColor: Color(0xffFFFAFA),
        ),
        home: MainHomePage(),
      ),
    );
  }
}

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int currentPage = 0;
  PageController _pageController = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'asset/images/Logo/LogoAndMonolog/SM.png',
                  scale: 6,
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.shoppingBag,
                  color: Colors.black54,
                ),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Cart())),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  //color: Colors.green,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      VideoPlayerScroll(
                        videoPlayerController: VideoPlayerController.asset(
                            'asset/images/slider/scroll1.mp4'),
                        looping: true,
                      ),
                      HomeImageCarousel(
                        img: 'scroll2',
                      ),
                      HomeImageCarousel(
                        img: 'scroll3',
                      ),
                      HomeImageCarousel(
                        img: 'scroll4',
                      ),
                      HomeImageCarousel(
                        img: 'scroll5',
                      ),
                    ],
                    onPageChanged: (value) => {setCurrentPage(value)},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => GetIndicator(
                        pageNo: index,
                        cPageNo: currentPage,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              child: Text(
                'Services',
                style: kHeadingStyle,
              ),
              margin: EdgeInsets.symmetric(horizontal: 10),
            ),
          ])),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                HomeService service = serviceTab[index];
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => service.onPress),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.height / 9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        kBoxShadow,
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image(
                          height: 60.0,
                          image: AssetImage(service.img),
                        ),
                        Text(
                          service.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: 6,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 3,
              crossAxisSpacing: 3,
              childAspectRatio: 1,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                OffersCarousel(),
                GuidelinesBar(),
                Divider(
                  height: 40,
                  color: Colors.black,
                  thickness: 1,
                  indent: 150,
                  endIndent: 150,
                ),
                Text(
                  'Bring the Home Salon',
                  style: TextStyle(
                    fontFamily: 'autobio',
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: SideDrawer(),
    );
  }

  setCurrentPage(int value) {
    currentPage = value;
    setState(() {});
  }
}
