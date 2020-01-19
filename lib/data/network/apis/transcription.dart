import 'dart:async';

import 'package:video_player_exercise/data/network/constants/endpoints.dart';
import 'package:video_player_exercise/model/transcript.dart';
import 'package:dio/dio.dart';

class TranscriptionApi {

  TranscriptionApi();

  /// Returns list of transcription bits in response
  Future<List<Transcript>> getTranscriptionFor(resourceId) async {
    try {
      Response response = await Dio().get(Endpoints.baseUrl + resourceId + ".json");
      if (response.statusCode == 200 && response.data != null) {

        List<Transcript> res = response.data.map<Transcript>((json) => Transcript.fromJson(json)).toList();
        res.sort((a,b) {
          return a.time.compareTo(b.time);
        });
        return res;
       } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

}