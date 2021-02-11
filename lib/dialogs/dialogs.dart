import 'package:flutter/cupertino.dart';
import 'package:flutter_app/size_config.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../constants.dart';

class Dialogs {
  BuildContext context;
  Dialogs(this.context);

  successDilalog(msg) {
    return Alert(
      context: context,
      type: AlertType.success,
      title: msg,
      content:Container(width:MediaQuery.of(context).size.width* 0.60,) ,
      buttons: [
        DialogButton(
          child: Text(
            "تم",
            style: TextStyle(color: white, fontSize: 16),
          ),
          onPressed: () => Navigator.of(context).pop(),
          width: getProportionateScreenWidth(120),
        )
      ],
    ).show();
  }

  warningDilalog({String msg, Function onpress}) async {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: msg,
       content:Container(width:MediaQuery.of(context).size.width* 0.60,) ,
      buttons: [
        DialogButton(
                height: getProportionateScreenHeight(50),
          color: red,
          child: Text(
            "لا",
            style: TextStyle(color: white, fontSize: 16),
          ),
          onPressed: () => Navigator.of(context).pop(),
          width: getProportionateScreenWidth(120),
        ),
        DialogButton(
                height: getProportionateScreenHeight(50),
          child: Text(
            "نعم",
            style: TextStyle(color: white, fontSize: 16),
          ),
          onPressed: await onpress,
          width: getProportionateScreenWidth(120),
        )
      ],
    ).show();
  }

  errorDilalog() {
    return Alert(
      context: context,
      type: AlertType.error,
      title: "حدث خطأ ما ",
       content:Container(width:MediaQuery.of(context).size.width* 0.60,) ,
      buttons: [
        DialogButton(
                height: getProportionateScreenHeight(50),
          child: Text(
            "تم",
            style: TextStyle(color: white, fontSize: 16),
          ),
          onPressed: () => Navigator.of(context).pop(),
          width: getProportionateScreenWidth(120),
        )
      ],
    ).show();
  }

  infoDilalog() {
    return Alert(
      context: context,
      type: AlertType.info,
      title: " !! برجاء استكمال البيانات",
       content:Container(width:MediaQuery.of(context).size.width* 0.60,) ,
      buttons: [
        DialogButton(
                height: getProportionateScreenHeight(50),
          child: Text(
            "تم",
            style: TextStyle(color: white, fontSize: 16),
          ),
          onPressed: () => Navigator.of(context).pop(),
          width: getProportionateScreenWidth(120),
        )
      ],
    ).show();
  }

warningDilalog2({String msg}) async {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: msg,
       content:Container(width:MediaQuery.of(context).size.width * 0.60,) ,
      buttons: [
        DialogButton(
                height: getProportionateScreenHeight(50),
          child: Text(
            "خروج",
            style: TextStyle(color: white, fontSize: 16),
          ),
          onPressed: ()=>Navigator.of(context).pop(),
          width: getProportionateScreenWidth(120),
        )
      ],
    ).show();
  }
}
