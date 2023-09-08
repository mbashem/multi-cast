import {NativeStackScreenProps} from '@react-navigation/native-stack';
import {RootStackParamList} from '../Navigation';
import {Text, View} from 'native-base';

const Inbox = ({
  route,
  navigation,
}: NativeStackScreenProps<RootStackParamList, 'Inbox'>) => {
  const {userId} = route.params;

  return (
    <View>
      <Text>Inbox {userId}</Text>
    </View>
  );
};

export default Inbox;
