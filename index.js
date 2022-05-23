// main index.js

import {NativeModules, NativeEventEmitter} from "react-native";

const {ReactNativeStarMicronicsIO} = NativeModules;

const {
  stopDiscoverScales: _stopDiscoverScales,
  discoverScales: _discoverScales,
  connectScale: _connectScale,
  setupScales: _setupScales,
} = ReactNativeStarMicronicsIO;


/**
 * Sets up the package and the availability to connect to sacles
 */
export async function setupScales() {
  return _setupScales();
}

/**
 * Starts a search for scales
 */
export async function discoverScales() {
  return _discoverScales();
}

/**
 * Stops discovering scales
 */
export async function stopDiscoverScales() {
  return _stopDiscoverScales();
}

/**
 * Connects to a scale
 *
 * @param scale         The scale object that is returned from onDiscoverScale
 */
export async function connectScale(scale) {
  return _connectScale(scale);
}

/**
 * Registers a listener attached to the package
 *
 * @param key                   Listener key
 * @param method                Listener function
 */
export function registerStarListener(key, method) {
  return listeners.addListener(key, method);
}

const listeners = new NativeEventEmitter(ReactNativeStarMicronicsIO);

