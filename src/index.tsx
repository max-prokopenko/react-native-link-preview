import { NativeModules, Platform } from 'react-native';

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
  if (Platform.OS === 'ios') {
    return ReactNativeLinkPreview.generate(url);
  } else {
    return {
      title: '',
      type: '',
      url: '',
      imageURL: '',
      description: '',
    };
  }
};

const LinkPreview = {
  generate: generatePreview,
};

export default LinkPreview as ReactNativeLinkPreviewType;
