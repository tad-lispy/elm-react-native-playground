import React from 'react';
import { StyleSheet, Text, View, Button } from 'react-native';
import { inspect } from 'util';

// Elm program
import Elm from './lib/main';

let worker = Elm.Main.worker();

export default class App extends React.Component {
  render() {
    return (
      <View style={styles.container}>
        <Text>{this.state.count}</Text>
        <Button title="Decrement" onPress={this.decrement} />
        <Button title="Do a weird thing" onPress={this.freakOut} />
      </View>
    );
  }

  // Initialization

  constructor(props) {
    super(props);
    this.state = { count: 0 };
  }

  componentDidMount() {
    worker.ports.state.subscribe(state => {
      console.log('JS received: ' + inspect(state));
      this.setState(state);
    });
  }

  // User actions' handlers

  decrement() {
    worker.ports.events.send('Decrement');
  }
  freakOut() {
    worker.ports.events.send('Weird');
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'space-around'
  }
});
