package com.example.backend.auth;

import com.example.backend.auth.jwt.JWTAuthResponse;
import com.google.firebase.auth.FirebaseAuthException;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@AllArgsConstructor
@RestController
@RequestMapping("/api/public/auth")
@Slf4j
public class AuthController {
    final AuthService authService;

    @PostMapping("/google-signin")
    public ResponseEntity<JWTAuthResponse> signin(@RequestBody GoogleSigninRequest signin) {
        var idToken = signin.getIdToken();

        log.info("Authenticating");
        try {
            var response = authService.tryGoogleAuth(idToken);
            return ResponseEntity.ok(response);
        } catch (FirebaseAuthException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            log.warn(e.getMessage());
            return ResponseEntity.internalServerError().build();
        }
    }
}
