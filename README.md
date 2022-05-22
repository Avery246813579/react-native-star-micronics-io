# react-native-star-micronics-io

React Native Star Micronics IO is a react-native module that will allow you to interact with the Star Micronics scales.
This package only currently works with bluetooth connections. 

## Getting started

`$ npm install react-native-star-micronics-io --save`

or 

`$ yarn add react-native-star-micronics-io`

### Mostly automatic installation

`$ cd ios;pod install`

or if you are using React Native before version 0.60, 

`$ react-native link react-native-star-micronics-io`

---

## Usage

### Setting up the package
You need to setup the package for use by using the `setupScales` function. Use it inside a componentDidMount or before
you use `discoverScales`

```javascript
import {setupScales} from 'react-native-star-micronics-io';

setupScales();
```

### Discover a scale
To start discovering a scale, the first thing you have to do is setup a listener for when a scale is found. Use the
`registerStarListener` function with `onDiscoverScale`. Then we can call the `discoverScales` function which will
find any scales through bluetooth. 

```javascript
import {registerStarListener, discoverScales} from 'react-native-star-micronics-io';

registerStarListener("onDiscoverScale", (scale) => {
  // do something with the scale we found
});

discoverScales();
```

### Connect to the scale
Once we have found a scale using `discoverScales` and the `onDiscoverScale` listener. All we have to do is call 
`connectScale` with the payload sent during the `onDiscoverScale`.

```javascript
import {registerStarListener, connectScale} from 'react-native-star-micronics-io';

registerStarListener("onDiscoverScale", (scale) => {
  connectScale(scale);
});
```

### Scale state
We can use the listeners `onScaleConnect` and `onScaleDisconnect` to check the state of the scales. 

```javascript
import {registerStarListener} from 'react-native-star-micronics-io';

registerStarListener("onScaleConnect", (scale) => {
  // Scale is connected
});

registerStarListener("onScaleDisconnect", (scale) => {
  // Scale lost it's connection
});
```

### Listen to scale data
Once we have connected to the scale and have gotten the onScaleConnect callback, we can start listening to the scale
data using `onScaleData`. It will send an object with `weight`, `type`, and `unit`.

```javascript
import {registerStarListener} from 'react-native-star-micronics-io';

registerStarListener("onScaleData", (data) => {
  const {weight, type, unit} = data;
  
  console.log("Scale data", weight, type, unit);
});
```

