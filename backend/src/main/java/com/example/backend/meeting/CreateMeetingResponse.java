package com.example.backend.meeting;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
@AllArgsConstructor
public class CreateMeetingResponse {
    String MeetingId;
    Integer hostId;
}
