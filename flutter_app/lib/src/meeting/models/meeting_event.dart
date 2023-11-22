class MeetingEvent {
  String? room;
  String? msg;
  String? sender;
  String? to;
  MeetingEvent({this.room, this.msg, this.sender, this.to});

  MeetingEvent.fromJson(Map<String, dynamic> json)
      : room = json['room'],
        msg = json['msg'],
        sender = json["sender"],
        to = json["to"];

  Map<String, dynamic> toJson() {
    return {
      'room': room,
      'msg': msg,
      'sender': sender,
      'to': to,
    };
  }

  @override
  String toString() {
    return 'MeetingEvent{room: $room, msg: $msg, sender: $sender, to: $to}';
  }
}
