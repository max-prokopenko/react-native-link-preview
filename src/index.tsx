import { NativeModules } from 'react-native';

type ReactNativeLinkPreviewType = {
  multiply(a: number, b: number): Promise<number>;
};

const { ReactNativeLinkPreview } = NativeModules;

export default ReactNativeLinkPreview as ReactNativeLinkPreviewType;
