import { createRandomChat, getRandomInbox } from "../FakeData/Chats";

const useInbox = (chatId: string) => {
	const messages = getRandomInbox(chatId, 10);
	const chatInfo = createRandomChat();

	const appendMessage = async (message: string) => {

	};

	return { messages, chatInfo, appendMessage };
}

export default useInbox;