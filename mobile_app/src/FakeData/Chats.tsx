import {faker} from '@faker-js/faker';

export const createRandomChat = () => {
  return {
    chatId: faker.string.uuid(),
    chatName: faker.internet.userName(),
		chatAvatar: faker.image.avatar(),
    userId: faker.string.uuid(),
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

export const createRandomMessage = (id: string) => {
  return {
    chatId: id,
    userId: faker.string.uuid(),
    username: faker.internet.userName(),
    avatar: faker.image.avatar(),
    message: faker.lorem.sentence(),
    sent: faker.date.recent(),
  };
};

export const getRandomInbox = (chatId: string, count: number) => {
  return faker.helpers.multiple(() => createRandomMessage(chatId), {
    count: count,
  });
};
