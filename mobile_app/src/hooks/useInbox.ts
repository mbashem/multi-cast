import { getRandomChats } from "../FakeData/Chats";

const useInbox = () => {
	const chats = getRandomChats(10);
	return { chats };
}

export default useInbox;