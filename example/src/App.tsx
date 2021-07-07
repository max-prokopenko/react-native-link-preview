import * as React from 'react';

import {
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
  Image,
  TextInput,
  LayoutAnimation,
  ScrollView,
} from 'react-native';
import LinkPreview from '@lowkey/react-native-link-preview';

export default function App() {
  const [url, setUrl] = React.useState<string>('');
  const [metaData, setMetaData] = React.useState<{
    generated: boolean;
    title?: string;
    type?: string;
    url?: string;
    imageURL?: string;
    description?: string;
    genDuration?: number;
  }>({
    generated: false,
  });

  const generateLinkData = React.useCallback(() => {
    const start = Date.now();
    LinkPreview.generate(url).then((data) => {
      const end = Date.now();
      LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
      setMetaData({
        ...data,
        generated: true,
        genDuration: end - start,
      });
    });
  }, [url]);

  return (
    <ScrollView
      style={styles.container}
      contentContainerStyle={styles.containerContent}
    >
      <View style={styles.generateContainer}>
        <TextInput
          style={styles.input}
          value={url}
          onChangeText={setUrl}
          clearTextOnFocus
        />
        <TouchableOpacity onPress={generateLinkData} style={styles.button}>
          <Text>Generate</Text>
        </TouchableOpacity>
      </View>
      <View style={styles.previewContainer}>
        <Image
          source={{ uri: metaData.imageURL }}
          style={styles.previewImage}
        />
        <Text style={styles.previewTitle}>{metaData.title}</Text>
        <Text style={styles.previewDescription}>{metaData.description}</Text>
        <Text style={styles.previewUrl} numberOfLines={1}>
          {metaData.url}
        </Text>
      </View>
      <Text style={styles.genDuration}>
        Generated in {metaData.genDuration}ms
      </Text>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  containerContent: {
    alignItems: 'center',
    justifyContent: 'center',
    flex: 1,
  },
  generateContainer: {
    flexDirection: 'row',
    width: 350,
  },
  input: {
    borderColor: '#e1e1e1',
    borderWidth: 2,
    borderRadius: 10,
    flex: 1,
    marginRight: 10,
    paddingHorizontal: 10,
  },
  button: {
    paddingHorizontal: 20,
    paddingVertical: 15,
    borderRadius: 10,
    backgroundColor: '#e1e1e1',
    width: 100,
  },
  previewContainer: {
    backgroundColor: '#e1e1e1',
    borderRadius: 15,
    overflow: 'hidden',
    maxWidth: 350,
    marginTop: 20,
  },
  previewImage: {
    width: 350,
    height: 200,
    backgroundColor: '#d5d5d5',
  },
  previewTitle: {
    fontWeight: '700',
    padding: 10,
    paddingTop: 10,
    fontSize: 15,
  },
  previewDescription: {
    paddingHorizontal: 10,
    paddingTop: 0,
    paddingBottom: 20,
  },
  previewUrl: {
    paddingHorizontal: 10,
    paddingTop: 5,
    paddingBottom: 10,
    paddingRight: 40,
    color: '#777',
    fontWeight: '300',
  },
  genDuration: {
    marginTop: 10,
    fontSize: 12,
    fontStyle: 'italic',
  },
});
