/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */
import React from 'react';

import Navigation from './src/Navigation';
import {SafeAreaProvider} from 'react-native-safe-area-context';
import {NativeBaseProvider} from 'native-base';

function App(): JSX.Element {
  return (
    <SafeAreaProvider>
      <NativeBaseProvider config={{initialColorMode: 'dark'}}>
        <Navigation />
      </NativeBaseProvider>
    </SafeAreaProvider>
  );
}

export default App;
