import {faker} from '@faker-js/faker';

export const createRandomUser = () => {
  return {
    userName: faker.internet.userName(),
    firstName: faker.person.firstName(),
    lastName: faker.person.lastName(),
    userAvatar: faker.image.avatar(),
    lastActive: faker.date.recent(),
  };
};
