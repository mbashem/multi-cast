import React, {useState} from "react";
import {NativeStackScreenProps} from "@react-navigation/native-stack";
import {RootStackParamList} from "../Navigation";
import {Text, View, Box, Avatar, ScrollView, Input, Button} from "native-base"; // Import NativeBase components
import useInbox from "../hooks/useInbox";
import useUser from "../hooks/userUser";
import SendMessage from "../components/Inbox/SendMessage";

const Inbox = ({
  route,
  navigation,
}: NativeStackScreenProps<RootStackParamList, "Inbox">) => {
  const {userId} = route.params;
  const {messages, chatInfo, appendMessage} = useInbox(userId);
  const {user} = useUser();

  const handleSendMessage = (newMessage: string) => {
    appendMessage(newMessage);
    console.log(`Sending message: ${newMessage}`);
  };

  return (
    <View flex={1} bg="white">
      <Text fontSize={24} textAlign="center" my={4}>
        {chatInfo.chatName}
      </Text>
      <ScrollView flex={1}>
        {messages.map(message => {
          const sentByUser = Math.random() > 0.5;
          return (
            <View
              key={message.messageId}
              flexDirection={sentByUser ? "row-reverse" : "row"}
              alignItems="center"
              p={2}>
              <Avatar
                size="md"
                maxWidth="20%"
                source={{uri: message.userAvatar}}
                m={2}
              />
              <Box
                p={3}
                borderRadius={10}
                flexWrap="wrap"
                maxWidth="80%"
                bg={sentByUser ? "teal.500" : "gray.300"}>
                <Text
                  fontSize="md"
                  color={sentByUser ? "white" : "black"}
                  width="100%">
                  {message.message}
                </Text>
              </Box>
            </View>
          );
        })}
      </ScrollView>
      <SendMessage onSubmit={newMessage => handleSendMessage(newMessage)} />
    </View>
  );
};

export default Inbox;
