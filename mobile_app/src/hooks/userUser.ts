import { getRandomInbox } from "../FakeData/Chats";
import { createRandomUser } from "../FakeData/User";

const useUser = () => {
	const user = createRandomUser();
	return { user };
}

export default useUser;