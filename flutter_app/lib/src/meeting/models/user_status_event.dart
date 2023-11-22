class UserStatusEvent {
  bool isMicOn;
  bool isCameraOn;
  UserStatusEvent({required this.isMicOn, required this.isCameraOn});

  UserStatusEvent.fromJson(Map<String, dynamic> json)
      : isCameraOn = json['isCameraOn'],
        isMicOn = json['isMicOn'];

  Map<String, dynamic> toJson() {
    return {
      'isCameraOn': isCameraOn,
      'isMicOn': isMicOn,
    };
  }

  @override
  String toString() {
    return 'UserStatusEvent{isCameraOn: $isCameraOn, isMicOn: $isMicOn}';
  }
}
