
enum Speaker { customer, rep }

class Transcript {
  String snippet;
  Speaker speaker;
  double time;

  Transcript({
    this.snippet,
    this.speaker,
    this.time,
  });

  factory Transcript.fromJson(Map<String, dynamic> json) {
    return Transcript(
      snippet: json['snippet'] as String,
      speaker: json['speaker'] as String == "Cust" ? Speaker.customer : Speaker.rep ,
      time: json['time'] as double,
    );
  }
}