import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:funandmoving/Services/Services.dart';
import 'package:funandmoving/UI/Client/BaseLayer.dart';
import 'package:funandmoving/UI/Client/Downloads.dart';
import 'package:funandmoving/UI/Client/Login.dart';
import 'package:funandmoving/UI/Client/Telemed.dart';
import 'package:funandmoving/UI/Trainer/VideoForm.dart';
import 'package:funandmoving/Utils/TextConstants.dart';
import 'package:funandmoving/Utils/colors.dart';
import 'package:funandmoving/Utils/images.dart';

import 'MyText.dart';

class CustomBottomBar extends StatefulWidget {
  final int index;

  CustomBottomBar(this.index);

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  Services service=Services();
  Map data={};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    service.getLocalData().then((value) {
      setState(() {
        data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 5,
      currentIndex: widget.index,
      selectedColor: primary,
      onTap: (val){
        if(val==0){
          Navigator.push(context,MaterialPageRoute(
              builder: (BuildContext context) => BaseLayer(
                  title: "Class",
                  question: service.videoClass.question,
                  data: service.videoClass.selections,
                  nickname: false,
                  logo: true
              )
          )
          );
        }else if(val==1){
          if(widget.index==val){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Telemed()));
          }else {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Telemed()));
          }
        }else if(val==2){
          if(widget.index==val){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Downloads()));
          }else {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Downloads()));
          }
        }else if(val==3){
          if(data[ISLOGIN]==true && data[ISTRAINER]==false){
            service.deleteLocalData().then((value) {
              setState(() {
                data = value;
              });
              Navigator.of(context).popUntil((route) => true);
              Navigator.push(context,MaterialPageRoute(
                  builder: (BuildContext context) => BaseLayer(
                      title: "Class",
                      question: service.videoClass.question,
                      data: service.videoClass.selections,
                      nickname: false,
                      logo: true
                  )
              )
              );
            });
          }
          else if(data[ISLOGIN]==true && data[ISTRAINER]==true){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoForm()));
          }
          else {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
          }
        }
      },
      items: [
        CustomNavigationBarItem(
          icon: Icon(Icons.home),
          showBadge: false,
          title: MyText(
            title: "Home",
            size: 10,
            clr: Colors.black,
          ),
        ),
        CustomNavigationBarItem(
          icon: Image.asset(widget.index==1?stelemed:telemed,),
          showBadge: false,
          title: MyText(
            title: "TeleMed",
            size: 10,
            clr: Colors.black,
          ),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.favorite),
          showBadge: false,
          title: MyText(
            title: "Favorites",
            size: 10,
            clr: Colors.black,
          ),
        ),
        CustomNavigationBarItem(
          icon: Icon(data[ISLOGIN]==true?Icons.logout:Icons.login_rounded),
          showBadge: false,
          title: MyText(
            title: data[ISLOGIN]==true?data[ISTRAINER]==true?"Trainer":"Logout":"Login",
            size: 10,
            clr: Colors.black,
          ),
        ),
      ],
    );
  }
}