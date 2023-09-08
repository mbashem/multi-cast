import { getRandomChats } from "../FakeData/Chats";

const useChatList = () => {
	const chatList = getRandomChats(10);
	return { chatList };
}

export default useChatList;