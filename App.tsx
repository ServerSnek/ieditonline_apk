import React, {useRef, useEffect, useState} from 'react';
import {
  SafeAreaView,
  StatusBar,
  StyleSheet,
  View,
  BackHandler,
  Linking,
} from 'react-native';
import {WebView} from 'react-native-webview';

const App = () => {
  const webViewRef = useRef<WebView>(null);
  const [canGoBack, setCanGoBack] = useState(false);
  
  const BASE_URL = 'https://staging.ieditonline.com';

  // Helper to handle the logic in one place
  const handleUrlCheck = (url: string) => {
    if (!url) return true;

    // 1. Ignore about:blank
    if (url === 'about:blank') return true;

    // 2. Strict check: Is it EXACTLY the homepage?
    // We check for with and without slash to be safe
    const isHomepage = url === BASE_URL || url === `${BASE_URL}/`;

    if (isHomepage) {
      return true; // Stay in WebView
    } else {
      // 3. Any other URL -> Stop loading & Open System Browser
      webViewRef.current?.stopLoading();
      Linking.openURL(url).catch(err => console.error("Couldn't open link", err));
      
      // If we are "stuck" on a non-homepage URL inside the webview (due to JS navigation),
      // force the webview back to the homepage so the user doesn't see a blank/error screen.
      // (Optional, but provides better UX)
      webViewRef.current?.goBack(); 
      
      return false; 
    }
  };

  useEffect(() => {
    const backHandler = BackHandler.addEventListener('hardwareBackPress', () => {
      // If back button is pressed, exit app (since we don't nav inside webview)
      return false;
    });
    return () => backHandler.remove();
  }, []);

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" backgroundColor="#ffffff" />
      <View style={styles.webViewContainer}>
        <WebView
          ref={webViewRef}
          source={{uri: BASE_URL + '/'}}
          style={styles.webView}

          // 1. Catches standard links (standard HTML <a href>)
          onShouldStartLoadWithRequest={(request) => {
            return handleUrlCheck(request.url);
          }}

          // 2. Catches JS navigation (React Router / Next.js / SPAs)
          onNavigationStateChange={(navState) => {
             // We only care if the URL actually changed and it's NOT loading
             // This prevents infinite loops
             if (!navState.loading) {
                 handleUrlCheck(navState.url);
             }
             setCanGoBack(navState.canGoBack);
          }}

          originWhitelist={['*']}
          javaScriptEnabled={true}
          domStorageEnabled={true}
          startInLoadingState={true}
          scalesPageToFit={true}
          setSupportMultipleWindows={false}
        />
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#ffffff',
  },
  webViewContainer: {
    flex: 1,
  },
  webView: {
    flex: 1,
  },
});

export default App;