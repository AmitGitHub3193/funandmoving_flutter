import '../SharedWidgets/MyText.dart';
import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  String? mystring;
  Icon? customIcon;
  NotFound({this.mystring,this.customIcon});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Center(
        //     child: Lottie.asset('asset/empty.json',width: 150,height: 150)),
        Center(
          child: customIcon==null?Icon(Icons.search,color: Theme.of(context).primaryColor,size: 45,):customIcon
        ),
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: MyText(
            center: true,
            title: mystring??"",
            size: 14,
          ),
        )
      ],
    );
  }
}
