/*
 Copyright 2017 Spotify AB

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#ifndef Simple_Track_Playback_Config_h
#define Simple_Track_Playback_Config_h

#warning Please update these values to match the settings for your own application as these example values could change at any time.
// For an in-depth auth demo, see the "Basic Auth" demo project supplied with the SDK.
// Don't forget to add your callback URL's prefix to the URL Types section in the target's Info pane!

// Your client ID
//#define kClientId "e6695c6d22214e0f832006889566df9c"
#define kClientId "d26ef9eab50a4879adaa91d41b979dd1"

// Your applications callback URL
//#define kCallbackURL "spotifyiossdkexample://"
#define kCallbackURL "spotify-ios-quick-start://spotify-login-callback"

// The URL to your token swap endpoint
// If you don't provide a token swap service url the login will use implicit grant tokens, which means that your user will need to sign in again every time the token expires.

 #define kTokenSwapServiceURL "https://test-spotify-token-swap.herokuapp.com/token"

// The URL to your token refresh endpoint
// If you don't provide a token refresh service url, the user will need to sign in again every time their token expires.

 #define kTokenRefreshServiceURL "https://test-spotify-token-swap.herokuapp.com/api/refresh_token"


#define kSessionUserDefaultsKey "SpotifySession"

#endif


// Launch Screen bg photo courtesy of Brad Cook on Flickr: https://www.flickr.com/photos/bradeatscheese/16032088701/in/photolist-qqGDqr-57LjYh-j6ZGLr-Mgr7w-oBymLh-8nhTkM-4bmajA-Wu7tpJ-dMJJQy-dWzzFm-7QWS1U-7dvcux-WddQdr-kzTqxi-kCm4jc-4tB1x1-3FRF9T-7oFxR1-frntFk-eG5JHC-9TijWs-8njqyW-5GgDsr-4ahg75-8o53Ew-akAxN9-qK6Y4u-bQt16g-bMK2Y4-5hvwRe-de4kka-rguHjB-72zhLZ-8KnHc1-5RCvgr-zejvN-8SXBo1-85m1XK-fqrmC3-oB8gc7-fqGgpo-6rcEFR-r18oEF-77SpLB-mo5N8K-7duGvX-813kP3-ak6htA-m2wHr4-k25kNf/
