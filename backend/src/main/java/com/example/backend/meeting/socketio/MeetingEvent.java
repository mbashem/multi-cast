package com.example.backend.meeting.socketio;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MeetingEvent {
    String room;
    String msg;
    String sender;
    String to;
}
