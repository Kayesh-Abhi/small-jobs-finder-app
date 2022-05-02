import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PayMent(),
      ),
    );
  }
}

class PayMent extends StatefulWidget {
  @override
  _PayMentState createState() => _PayMentState();
  //check this line i changed default generated code _PayMentState
}

class _PayMentState extends State<PayMent> {
  TextEditingController _controller = TextEditingController();
  late Razorpay _razorpay; //added 'late'

  @override
  void initState() {
    _razorpay = Razorpay();
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Container(
                child: Text(
                  "    Please enter the payment below",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            SizedBox(
              height: 9,
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  width: 5,
                  color: Colors.blue,
                ),
              )),
            ),
            SizedBox(
              height: 15,
            ),
            RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  openCheckout();
                },
                child: Text(
                  "Make Payment",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_lLyI7hSLmpZ7CR',
      'amount':
          (double.parse(_controller.text) * 100.roundToDouble()).toString(),
      'name': 'Job Payments',
      'description': 'Payment amount',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("SUCCESS: " + response.paymentId!)));
    print('Success Response: $response');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
            "ERROR: " + response.code.toString() + " - " + response.message!)));
    print('Error Response: $response');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("EXTERNAL_WALLET: " + response.walletName!)));
    print('External SDK Response: $response');
  }
}
