package com.example.backend;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;

import java.io.FileInputStream;
import java.io.IOException;

@SpringBootApplication
@Slf4j
public class BackendApplication {

    @Value("${firebase.credential.resource-path}")
    private static String keyPath;

    public static void main(String[] args) {

        try {
//            BackendApplication.firebaseInitialization();
            Resource resource = new ClassPathResource("/firebase_config.json");
            FileInputStream serviceAccount = new FileInputStream(resource.getFile());
            FirebaseOptions options = new FirebaseOptions.Builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();
            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
                log.info("Firebase...");
                log.info(FirebaseApp.getInstance().getName());
            }
        } catch (Exception e) {
            log.info(keyPath);
            log.info("Failed!", e.getMessage());
        }

        SpringApplication.run(BackendApplication.class, args);
    }
}
