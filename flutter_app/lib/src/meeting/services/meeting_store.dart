import 'package:flutter_app/src/meeting/models/user_status_event.dart';
import 'package:flutter_app/src/utils/logger.dart';
import 'package:mobx/mobx.dart';

part 'meeting_store.g.dart';

class MeetingStore = _MeetingStore with _$MeetingStore;

abstract class _MeetingStore with Store {
  @observable
  ObservableMap<String, UserStatusEvent> statusMap =
      ObservableMap<String, UserStatusEvent>();

  @action
  void addUpdateStatus(String sessionId, UserStatusEvent status) {
    logger.i("addUpdateStatus : $sessionId $status");
    statusMap[sessionId] = status;
  }

  @action
  void removeStatus(String sessionId) {
    statusMap.remove(sessionId);
  }
}
