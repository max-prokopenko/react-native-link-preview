# @lowkey/react-native-link-preview
Get link metadata to show url preview in React Native. Metadata generation happens on native thread, so the JS thread stays unblocked with 60fps. Currently only supported on iOS, on Android returns empty strings for every field.

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
