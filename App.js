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
      </View>
    );
  }

  // Initialization

  constructor(props) {
    super(props);
    this.state = { counr: 0 };
  }

  componentDidMount() {
    worker.ports.state.subscribe(count => {
      console.log('JS received: ' + inspect(count));
      this.setState({ count });
    });
  }

  // User actions' handlers

  decrement() {
    worker.ports.events.send('Decrement');
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
