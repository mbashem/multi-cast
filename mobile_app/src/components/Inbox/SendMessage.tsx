import {Box, Button, Input} from "native-base";
import {useState} from "react";

interface Props {
  onSubmit: (message: string) => void;
}

const SendMessage = ({onSubmit}: Props) => {
  const [message, setMessage] = useState("");

  return (
    <Box flexDirection="row" alignItems="center" p={2}>
      <Input
        placeholder="Type your message"
        flex={1}
        value={message}
        onChangeText={text => setMessage(text)}
      />
      <Button
        colorScheme="teal"
        onPress={() => {
          onSubmit(message);
          setMessage("");
        }}
        ml={2}>
        Send
      </Button>
    </Box>
  );
};

export default SendMessage;
