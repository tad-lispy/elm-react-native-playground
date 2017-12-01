import React from 'react';
import { StyleSheet, Text, View, Button, Slider } from 'react-native';
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
        <Slider
          style={{ width: '100%' }}
          value={this.state.value}
          onValueChange={this.slide}
        />
        <Slider
          style={{ width: '100%' }}
          value={this.state.value}
          onValueChange={this.slide}
        />
        <Slider style={{ width: '100%' }} />

        <Button title="Do a weird thing" onPress={this.freakOut} />
      </View>
    );
  }

  // Initialization

  constructor(props) {
    super(props);
    this.state = { count: 0, value: 0.5 };
  }

  componentDidMount() {
    worker.ports.state.subscribe(state => {
      console.log('JS received: ' + inspect(state));
      this.setState(state);
    });
  }

  // User actions' handlers
  slide(value) {
    console.log('Slide: ' + inspect(value));
    // this.setState({ value });
    worker.ports.events.send({ kind: 'Slide', data: value });
  }
  decrement() {
    worker.ports.events.send({ kind: 'Decrement', data: null });
  }
  freakOut(event) {
    console.log('Weird: ' + inspect(event));
    worker.ports.events.send({ kind: 'Weird', data: event.nativeEvent });
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
