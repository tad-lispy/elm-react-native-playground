import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

// Elm program
import Elm from './lib/main';

let worker = Elm.Main.worker();

export default class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { counr: 0 };
  }
  componentDidMount() {
    worker.ports.state.subscribe(count => this.setState({ count }));
  }
  render() {
    return (
      <View style={styles.container}>
        <Text>Open up App.js to start working on your app, pal!</Text>
        <Text>{this.state.count}</Text>
        <Text>Changes you make will automatically reload.</Text>
        <Text>Shake your phone to open the developer menu.</Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center'
  }
});
