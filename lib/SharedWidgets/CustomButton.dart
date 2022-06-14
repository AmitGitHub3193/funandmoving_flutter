import 'package:flutter/material.dart';

class MainButton extends StatefulWidget {
  String label;
  Function? action;
  double? height,width;

  MainButton({Key? key, required this.label, this.action,this.height,this.width}) : super(key: key);

  @override
  _MainButtonState createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  int tap=0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.action as void Function()?,
      onTapDown: (details){
        setState((){
          tap=-1;
        });
      },
      onTapUp: (details){
        setState((){
          tap=1;
        });
      },
      onTapCancel: (){
        setState((){
          tap=1;
        });
      },
      child: Container(
        width: widget.width??280,
        height: widget.height??50,
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
          color: tap==-1?Theme.of(context).primaryColor:Theme.of(context).buttonColor,
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          boxShadow: [
            BoxShadow(
              color: tap==-1?Theme.of(context).primaryColor.withAlpha(200):Theme.of(context).buttonColor.withAlpha(200),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}