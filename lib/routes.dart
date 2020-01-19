import 'package:flutter/material.dart';

import 'ui/screens/playback_screen.dart';

class Routes {

  Routes._();

  static final routes = <String, WidgetBuilder>{
    PlayBackScreen.routeName: (BuildContext context) => PlayBackScreen(),
  };

}
