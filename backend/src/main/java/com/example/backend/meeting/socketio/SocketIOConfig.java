package com.example.backend.meeting.socketio;

import com.corundumstudio.socketio.AuthorizationListener;
import com.corundumstudio.socketio.HandshakeData;
import com.corundumstudio.socketio.SocketIOServer;
import com.example.backend.auth.jwt.JwtService;
import com.example.backend.user.UserService;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

@Configuration
@RequiredArgsConstructor
@Slf4j
public class SocketIOConfig {
    @Value("${socket.host}")
    private String host;
    @Value("${socket.port}")
    private int port;

    private final JwtService jwtService;
    private final UserService userService;

    @Bean
    public SocketIOServer socketIOServer() throws Exception {
        var config = new com.corundumstudio.socketio.Configuration();
        config.setHostname(host);
        config.setPort(port);

        config.setAuthorizationListener(new AuthorizationListener() {
            @Override
            public boolean isAuthorized(HandshakeData data) {
                String token = data.getSingleUrlParam("token");
                log.info("Token: " + token);
                var userEmail = jwtService.extractUserName(token);
                if (!userEmail.isEmpty()) {
                    UserDetails userDetails = userService.userDetailsService()
                            .loadUserByUsername(userEmail);
                    return jwtService.isTokenValid(token, userDetails);
                }
                return false;
            }
        });
        ;

        return new SocketIOServer(config);
    }
}
