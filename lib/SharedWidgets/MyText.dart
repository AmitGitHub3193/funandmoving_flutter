
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyText extends StatefulWidget {
  final String? title, weight;
  final double? size;
  final clr;
  final toverflow;
  final bool? center;
  final int? line;
  final bool? under,cut;

  MyText(
      {this.title,
      this.size,
      this.clr,
      this.weight,
      this.center,this.line,
        this.under,
      this.toverflow,this.cut});

  @override
  _MyTextState createState() => _MyTextState();
}

class _MyTextState extends State<MyText> {

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.title!,
      overflow: widget.toverflow == null ? TextOverflow.visible : widget.toverflow,
      maxLines: widget.line,
      textScaleFactor: 1,
      style: GoogleFonts.firaSans(
          decoration: widget.under==true?TextDecoration.underline:widget.cut==true?TextDecoration.overline:TextDecoration.none,
          fontSize: widget.size,
          color: widget.clr??Theme.of(context).primaryColor,
          fontWeight: widget.weight == null
              ? FontWeight.normal
              : widget.weight == "Bold"
                  ? FontWeight.w700
                  : widget.weight == "Semi Bold"
                      ? FontWeight.w500
                      : FontWeight.normal),
      textAlign: widget.center == null
          ? TextAlign.left
          : widget.center!
              ? TextAlign.center
              : TextAlign.left,
    );
  }
}

