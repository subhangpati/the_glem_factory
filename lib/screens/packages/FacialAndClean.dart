import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_glem_factory/components/service_provider.dart';
import 'package:the_glem_factory/model/cart_model.dart';
import '../Cart.dart';

List<String> subPackage = [
  'CleanUp Collection',
  'Facial Collection',
];
ServiceProvider packageData;
double currentPageValue = 0;
int selectedIndex = 0;
PageController _pageController;

class FacialAndClean extends StatefulWidget {
  @override
  _FacialAndCleanState createState() => _FacialAndCleanState();
}

class _FacialAndCleanState extends State<FacialAndClean> {
  @override
  void initState() {
    super.initState();
    currentPageValue = 0;
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    packageData = Provider.of<ServiceProvider>(context);
    if (selectedIndex == 0) {
      packageData.subPackage = 'cleanupCollection';
    } else {
      packageData.subPackage = 'facialCollection';
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios),
          onTap: () => Navigator.pop(context),
        ),
        title: Text(
          'FACIAL & CLEAN UP',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Cart()));
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: packageData.getStreamPackage('facial'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 25,
                    child: ListView.builder(
                      cacheExtent: 800,
                      itemCount: subPackage.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(index,
                                curve: Curves.decelerate,
                                duration: Duration(milliseconds: 300));
                            setState(() {
                              selectedIndex = index;
                              switchPackage();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                Text(
                                  subPackage[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: selectedIndex == index ? 17 : 15,
                                    color: selectedIndex == index
                                        ? Color(0xffff7d85)
                                        : Colors.black87,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  height: 4,
                                  width: 35,
                                  color: selectedIndex == index
                                      ? Color(0xffff7d85)
                                      : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    if (!snapshot.hasData) {
                      return Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return listCard(snapshot);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Cart()));
        },
        label: Text('PROCEED TO CART'),
        icon: Icon(FontAwesomeIcons.arrowCircleRight),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  ListView listCard(AsyncSnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.documents.length,
      itemBuilder: (BuildContext context, index) {
        DocumentSnapshot package = snapshot.data.documents[index];
        return Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(8),
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: CachedNetworkImage(
                              imageUrl: package['img'],
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress)),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(
                                top: 10, left: 10, bottom: 10, right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    package['title'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'inter',
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '₹ ${package['currentPrice']}',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      '₹ ${package['previousPrice']}',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    )
                                  ],
                                ),
                                Text('${package['time']} min'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: RaisedButton(
                              color: Color(0xffff7d85),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              onPressed: () {
                                productSelected(
                                  title: package['title'],
                                  currentPrice: package['currentPrice'],
                                  previousPrice: package['previousPrice'],
                                  time: package['time'],
                                );
                              },
                              child: Text("ADD"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // second half of card
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void productSelected({String title, int currentPrice, previousPrice, time}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Do you want to add this item in cart?"),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  print(title);
                  Provider.of<CartItem>(context, listen: false)
                      .addItem(title, currentPrice, previousPrice, time);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Thank you'),
                          content: Text('$title added to cart'),
                          actions: [
                            FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('OK'))
                          ],
                        );
                      });
                },
                child: const Text("ADD")),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("CANCEL"),
            ),
          ],
        );
      },
    );
  }

  void switchPackage() {
    switch (selectedIndex) {
      case 0:
        packageData.subPackage = 'cleanupCollection';
        break;
      case 1:
        packageData.subPackage = 'facialCollection';
        break;
    }
  }

}
