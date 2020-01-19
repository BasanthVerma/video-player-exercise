import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';


class ResourceModel with ChangeNotifier {

  String id = "4d79041e-f25f-421d-9e5f-3462459b9934";

  void changeId(resourceId) {
    id = resourceId;
    notifyListeners();
  }
}