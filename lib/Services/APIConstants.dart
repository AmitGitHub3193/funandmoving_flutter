
bool sLOG_ENABLED = true;
bool isRequiredLogin = false;
bool isDevelopmentMode = false;

const museAPIKey = "UFPO7Zc1SgvJrS2gelox1qFV5ff5fbfd";

bool isRequireSignUpfromWeb = false;
bool isCompressFromGallery = false;
bool isCompressWhenUploading = false;

var BaseConfig = {
  "url": isDevelopmentMode
      ? " "
      : "https://www.funandmoving.com/",
  "subscribe": "",
};

String questionsURL="Api/questions_filtered";
String videosURL="Api/videos";
String videoDetailURL="Api/videodetail/";
String registerDeviceURL="Api/registernewdevice/";
String authenticateDeviceURL="Api/authenticatedevice/";
