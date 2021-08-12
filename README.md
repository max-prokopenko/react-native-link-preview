# @lowkey/react-native-link-preview
Fully native link metadata generation to create link preview in React Native. Metadata generation happens on native thread, so the JS thread stays unblocked with 60fps. 

Supports most of the basic links, Spotify, Youtube and Facebook.

Supported on iOS and Android.


https://user-images.githubusercontent.com/20337903/124804885-73a6ce00-df63-11eb-8a24-6dd5888dfafb.mov



## Installation

```sh
npm install @lowkey/react-native-link-preview
```

or 

```sh
yarn add @lowkey/react-native-link-preview
```

then install pods

```sh
cd ios/ && pod install
```

## Usage
### Get URL metadata

```js
import LinkPreview from "@lowkey/react-native-link-preview";

// ...
const url = 'https://www.apple.com/ipad/';
const metadata = await LinkPreview.generate(url);

/*
console.log(metadata);
{
    title: string;
    type: string;
    url: string;
    imageURL: string;
    description: string;
}
*/
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
