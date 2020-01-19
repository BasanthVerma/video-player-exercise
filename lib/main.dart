import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player_exercise/model/resource.dart';
import 'ui/screens/playback_screen.dart';
import 'routes.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft
  ]).then((_) async {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ResourceModel>(
      create: (context) => ResourceModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Video Player Exercise",
        routes: Routes.routes,
        home: PlayBackScreen(),
      ),
    );
  }
}
