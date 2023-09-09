import {faker} from '@faker-js/faker';

// Chat List
export const createRandomChat = () => {
  return {
    chatId: faker.string.uuid(),
    chatName: faker.internet.userName(),
    chatAvatar: faker.image.avatar(),
    userName: faker.internet.userName(),
    userAvatar: faker.image.avatar(),
    lastMessage: faker.lorem.sentence(),
    lastSent: faker.date.recent(),
  };
};

export const getRandomChats = (count: number) => {
  return faker.helpers.multiple(createRandomChat, {
    count: count,
  });
};

// Inbox messages
export const createRandomMessage = (id: string) => {
  return {
    chatId: id,
    userName: faker.internet.userName(),
    userAvatar: faker.image.avatar(),
    message: faker.lorem.sentence(),
    sent: faker.date.recent(),
    messageId: faker.string.uuid(),
    type: 'text',
  };
};

export const getRandomInbox = (chatId: string, count: number) => {
  return faker.helpers.multiple(() => createRandomMessage(chatId), {
    count: count,
  });
};