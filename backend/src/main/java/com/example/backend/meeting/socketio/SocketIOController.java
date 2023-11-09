package com.example.backend.meeting.socketio;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.annotation.OnConnect;
import com.corundumstudio.socketio.annotation.OnDisconnect;
import com.corundumstudio.socketio.annotation.OnEvent;

import java.util.*;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;

@Controller
@Slf4j
public class SocketIOController {

    private final SocketIOServer server;
    private static final Map<String, String> users = new HashMap<>();
    private static final Map<String, String> rooms = new HashMap<>();
    private static final Map<String, HashSet<String>> participants = new HashMap<>();

    public SocketIOController(SocketIOServer server) {
        this.server = server;
        server.addListeners(this);
        server.start();
    }

    @OnConnect
    public void onConnect(SocketIOClient client) {
        log.info("Client connected: " + client.getSessionId());
        String clientId = client.getSessionId().toString();
        client.getNamespace().getClient(client.getSessionId()).sendEvent("userInfo",
                MeetingEvent.builder().msg(clientId).sender("Server").to(clientId).build());
        users.put(clientId, null);
    }

    @OnDisconnect
    public void onDisconnect(SocketIOClient client) {
        String clientId = client.getSessionId().toString();
        String room = rooms.get(clientId);
        if (!Objects.isNull(room)) {
            log.info("Client disconnected: {} from : {}", clientId, room);
            users.remove(clientId);
            client.getNamespace().getRoomOperations(room).sendEvent("userDisconnected",
                    MeetingEvent.builder().sender(clientId).build());
        }
        printLog("onDisconnect", client, room);
    }

    /**
     * msg will contain name
     */
    @OnEvent("joinRoom")
    public void onJoinRoom(SocketIOClient client, MeetingEvent meetingEvent) {
        var room = meetingEvent.getRoom();
        var name = meetingEvent.getMsg();
        var currClientSessionId = client.getSessionId().toString();
        users.put(currClientSessionId, name);
        rooms.put(currClientSessionId, room);
        var clients = server.getRoomOperations(room).getClients();
        clients.forEach((prv) -> {
            var prvClientSessionId = prv.getSessionId().toString();
            log.info(prvClientSessionId);
            client.getNamespace().getClient(prv.getSessionId())
                    .sendEvent("newUser",
                            MeetingEvent.builder().msg(name).sender(currClientSessionId)
                                    .to(prvClientSessionId).build());

            client.getNamespace().getClient(client.getSessionId())
                    .sendEvent("prvUser", MeetingEvent.builder()
                            .msg(users.get(prvClientSessionId)).to(currClientSessionId)
                            .sender(prvClientSessionId).build());
        });
        client.joinRoom(room);
        printLog("joinRoom", client, room);
    }

    @OnEvent("ready")
    public void onReady(SocketIOClient client, String room, AckRequest ackRequest) {
        client.getNamespace().getBroadcastOperations().sendEvent("ready", room);
        printLog("onReady", client, room);
    }

    @OnEvent("candidate")
    public void onCandidate(SocketIOClient client, MeetingEvent meetingEvent) {
        var room = meetingEvent.room;
        client.getNamespace().getClient(UUID.fromString(meetingEvent.getTo()))
                .sendEvent("candidate", meetingEvent);
        printLog("onCandidate", client, room);
    }

    @OnEvent("offer")
    public void onOffer(SocketIOClient client, MeetingEvent meetingEvent) {
        var room = meetingEvent.room;
        client.getNamespace().getClient(UUID.fromString(meetingEvent.getTo()))
                .sendEvent("offer", meetingEvent);
        printLog("onOffer", client, room);
    }

    @OnEvent("answer")
    public void onAnswer(SocketIOClient client, MeetingEvent meetingEvent) {
        var room = meetingEvent.room;
        client.getNamespace().getClient(UUID.fromString(meetingEvent.getTo()))
                .sendEvent("answer", meetingEvent);
        printLog("onAnswer", client, room);
    }

    private static void printLog(String header, SocketIOClient client, String room) {
        if (room == null) return;
        int size = 0;
        try {
            size = client.getNamespace().getRoomOperations(room).getClients().size();
        } catch (Exception e) {
            log.error("error ", e);
        }
        log.info("#ConncetedClients - {} => room: {}, count: {}", header, room, size);
    }
}