// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MeetingStore on _MeetingStore, Store {
  late final _$statusMapAtom =
      Atom(name: '_MeetingStore.statusMap', context: context);

  @override
  ObservableMap<String, UserStatusEvent> get statusMap {
    _$statusMapAtom.reportRead();
    return super.statusMap;
  }

  @override
  set statusMap(ObservableMap<String, UserStatusEvent> value) {
    _$statusMapAtom.reportWrite(value, super.statusMap, () {
      super.statusMap = value;
    });
  }

  late final _$_MeetingStoreActionController =
      ActionController(name: '_MeetingStore', context: context);

  @override
  void addUpdateStatus(String sessionId, UserStatusEvent status) {
    final _$actionInfo = _$_MeetingStoreActionController.startAction(
        name: '_MeetingStore.addUpdateStatus');
    try {
      return super.addUpdateStatus(sessionId, status);
    } finally {
      _$_MeetingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeStatus(String sessionId) {
    final _$actionInfo = _$_MeetingStoreActionController.startAction(
        name: '_MeetingStore.removeStatus');
    try {
      return super.removeStatus(sessionId);
    } finally {
      _$_MeetingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
statusMap: ${statusMap}
    ''';
  }
}
