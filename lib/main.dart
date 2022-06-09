import 'package:flutter/material.dart';
import 'package:lec_9/album.dart';
import 'package:lec_9/artist.dart';
import 'package:lec_9/music.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
void main()
{
  runApp(MaterialApp(
    home: demo(),
  ));
}

class demo extends StatefulWidget {
  const demo({Key? key}) : super(key: key);

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  dynamic _razorpay = Razorpay();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ElevatedButton(onPressed: () {

        var options = {
          'key': 'rzp_test_9hB7EiR9oCdIWg',
          'amount': 1000,
          'name': 'Acme Corp.',
          'description': 'Fine T-Shirt',
          'prefill': {
            'contact': '8888888888',
            'email': 'test@razorpay.com'
          }
        };
        _razorpay.open(options);

      },child: Text("pay"),),
    );
  }
}


class music extends StatefulWidget {

  @override
  State<music> createState() => _musicState();
}

class _musicState extends State<music> {

  permission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        //      Permission.location,
        Permission.storage,
      ].request();
      print(statuses[Permission.storage]);
    }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child: Scaffold(
        appBar: AppBar(
          title: Text("Music"),
          bottom: TabBar(
            tabs: [
              Text("song"),
              Text("album"),
              Text("artist"),
            ],
          ),
        ),
        body:
        TabBarView(
          children: [
            song(),
            album(),
            artist(),
          ],
        )
    )
    );
  }
}