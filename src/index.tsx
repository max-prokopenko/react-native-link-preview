import { NativeModules } from 'react-native';

type ReactNativeLinkPreviewType = {
  generate(url: string): Promise<{
    title: string;
    type: string;
    url: string;
    imageURL: string;
    description: string;
  }>;
};

const { ReactNativeLinkPreview } = NativeModules;

const generatePreview = (url: string) => {
  return ReactNativeLinkPreview.generate(url);
};

const LinkPreview = {
  generate: generatePreview,
};

export default LinkPreview as ReactNativeLinkPreviewType;
