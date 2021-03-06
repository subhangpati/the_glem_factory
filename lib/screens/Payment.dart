import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:the_glem_factory/components/EventsOnOrder.dart';
import 'package:the_glem_factory/components/auth.dart';
import 'package:the_glem_factory/components/calendarHelper.dart';
import 'package:the_glem_factory/model/cart_model.dart';
import 'package:the_glem_factory/screens/confirmPage.dart';

class Payment extends StatefulWidget {
  final EventModel note;
  final String time;
  final String date;
  final String title;
  final int total;
  final DateTime eventDateUnformatted;
  Payment(
      {this.time,
      this.date,
      this.note,
      this.eventDateUnformatted,
      this.total,
      this.title});
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Razorpay _razorpay;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = new Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ConfirmPage()));

    final data = {
      'current_userID': Provider.of<Auth>(context, listen: false).currentUser(),
      'selected_time': widget.time,
      "event_date": widget.date,
      'event_date_unformatted': widget.eventDateUnformatted,
      'title': widget.title,
      'totalAmount': widget.total,
      'bundleID': DateTime.now(),
      'PaymentStatus': 'PAID',
      'TransactionID': response.paymentId,
    };
    if (widget.note != null) {
      await eventDBS.updateData(widget.note.id, data);
    } else {
      await eventDBS.create(data);
    }
    cartData.clear();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_VxgHgHpxVZ9RjU',
      'amount':
          Provider.of<CartItem>(context, listen: false).totalAmount() * 100,
      'name': 'The Glam Factory',
      'description': 'Bring the home salon',
      'prefill': {
        'contact':
            Provider.of<Auth>(context, listen: false).currentUserPhoneNo(),
        'email': Provider.of<Auth>(context, listen: false).currentUserEmail()
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  CartItem cartData;
  @override
  Widget build(BuildContext context) {
    cartData = Provider.of<CartItem>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: InkWell(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
          title: Text(
            'CHOOSE PAYMENT',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'Select your Payment method',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    openCheckout();
                  },
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.asset('asset/images/card.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: Text(
                              'Online',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ConfirmPage()));
                    cartData.clear();
                    final data = {
                      'current_userID':
                          Provider.of<Auth>(context, listen: false)
                              .currentUser(),
                      'selected_time': widget.time,
                      "event_date": widget.date,
                      'title': widget.title,
                      'totalAmount': widget.total,
                      'event_date_unformatted': widget.eventDateUnformatted,
                      'bundleID': DateTime.now(),
                      'PaymentStatus': 'DUE',
                    };
                    if (widget.note != null) {
                      await eventDBS.updateData(widget.note.id, data);
                    } else {
                      await eventDBS.create(data);
                    }

                    print(cartData.bundleItemsTitle());
                    print('---------${widget.total}--------');
                    print('---------${widget.title}--------');
                    print(widget.time);
                    print(widget.date);
                    print('bundle ID ${DateTime.now()}');
                  },
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                                'asset/images/icons/OpeningSlides/PayLater.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: Text(
                              'Pay at Home',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
