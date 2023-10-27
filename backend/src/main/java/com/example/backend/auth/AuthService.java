package com.example.backend.auth;

import com.example.backend.auth.jwt.JWTAuthResponse;
import com.example.backend.auth.jwt.JwtService;
import com.example.backend.user.Role;
import com.example.backend.user.User;
import com.example.backend.user.UserRepository;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {
    private final UserRepository userRepository;
    private final JwtService jwtService;

    public UserRecord googleSignInUserDetails(String idToken) throws FirebaseAuthException {
        var firebaseToken = FirebaseAuth.getInstance().verifyIdToken(idToken, true);
        var uid = firebaseToken.getUid();
        return FirebaseAuth.getInstance().getUser(uid);
    }

    public JWTAuthResponse tryGoogleAuth(String idToken) throws FirebaseAuthException {
        log.info("Fetching info from firebase");
        var userRecord = googleSignInUserDetails(idToken);
        log.info("Trying signin");
        try {
            return signin(userRecord);
        } catch (Exception e) {
            return signup(userRecord);
        }
    }

    public JWTAuthResponse signup(UserRecord userRecord) {
        log.info("Sing up");
        var user = User.builder().displayName(userRecord.getDisplayName())
                .email(userRecord.getEmail()).photoURL(userRecord.getPhotoUrl())
                .role(Role.USER).build();
        userRepository.save(user);
        var jwt = jwtService.generateToken(user);
        log.info("JWT generated from sign up");
        return JWTAuthResponse.builder().token(jwt).build();
    }

    public JWTAuthResponse signin(UserRecord userRecord) {
        log.info("Signing in");
        var user = userRepository.findByEmail(userRecord.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("User doesn't exist."));
        var jwt = jwtService.generateToken(user);
        log.info("JWT Generated from sign in");
        return JWTAuthResponse.builder().token(jwt).build();
    }
}
