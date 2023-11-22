package com.example.backend.meeting;

import com.example.backend.auth.GoogleSigninRequest;
import com.example.backend.auth.jwt.JWTAuthResponse;
import com.google.firebase.auth.FirebaseAuthException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api")
public class MeetingController {
    @GetMapping("/create-meeting")
    public ResponseEntity<CreateMeetingResponse> createMeeting() {
        var meetingId = UUID.randomUUID().toString();

        return ResponseEntity.ok(CreateMeetingResponse.builder().MeetingId(meetingId).hostId(42).build());
    }

    @GetMapping("/join-meeting")
    public ResponseEntity<String> joinMeeting() {
        return ResponseEntity.ok("Join meeting");
    }
}
