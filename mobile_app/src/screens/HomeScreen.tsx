import React from 'react';
import {View, Text, Box, Avatar, ScrollView, Button} from 'native-base'; // Import NativeBase components
import useChatList from '../hooks/useChatList';
import moment from 'moment';
import {NativeStackScreenProps} from '@react-navigation/native-stack';
import {RootStackParamList} from '../Navigation';

const HomeScreen = ({
  navigation,
}: NativeStackScreenProps<RootStackParamList, 'Home'>) => {
  const {chatList} = useChatList();

  // Function to calculate the time ago
  const getTimeAgo = (timestamp: Date) => {
    return moment(timestamp).fromNow();
  };

  return (
    <ScrollView bg="white">
      {chatList.map(item => (
        <Button
          key={item.userId}
          onPress={() =>
            navigation.navigate('Inbox', {
              chatId: item.chatId,
            })
          } // Navigate to Inbox screen when chat item is clicked
        >
          <Box
            key={item.userId}
            borderBottomWidth={1}
            borderBottomColor="gray.300"
            p={4}
            flexDirection="row"
            alignItems="center">
            <Avatar
              size="md"
              source={{
                uri: item.chatAvatar, // Use the avatar image URL from the item
              }}
              mr={4}
            />
            <View flex={1}>
              <Text fontWeight="bold" fontSize="lg">
                {item.userName}
              </Text>
              <Text fontSize="md" color="gray.600">
                {item.lastMessage}
              </Text>
            </View>
            <Text fontSize="xs" color="gray.400">
              {getTimeAgo(item.lastSent)}
            </Text>
          </Box>
        </Button>
      ))}
    </ScrollView>
  );
};

export default HomeScreen;
