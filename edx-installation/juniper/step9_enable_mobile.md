# Active Mobile

## Enable mobile on LMS.yml configure file

In the **/edx/etc/lms.yml** file, add the following lines in the **FEATURE** section. Then restart lms service.
```
FEATURES:
  ENABLE_MOBILE_REST_API: true
  ENABLE_OAUTH2_PROVIDER: true
  ENABLE_COMBINED_LOGIN_REGISTRATION: true
```

## Create OAuth Clients

First, you need to create 2 users for each app. Ex: android_mobile_app and ios_mobile_app.

Then, Create an OAuth client ID and secret key to allow mobile app accessing.
1. Goto https://<lms-domain>/.
2. In **AUTHENTICATION AND AUTHORIZATION**, select **Users**.
3. Click **ADD USER** and create mobileapp user.
4. In **DJANGO OAUTH TOOLKIT**, select **Applications**.
5. Click **Add APPLICATION**.
6. Redirect uris: *https://<lms-domain>/api/mobile/v0.5/?app=android*.
7. Client Type: *public*.
8. Authorization grant type: *Resource owner password-based*.
9. Select **Save**.
10. Repeat steps 2 - 9 for the second mobile application.

## Configure iOS and Android app
In this section, I will change Android Mobile Configure, the iOS Mobile is the similar.

### Git Resource
- iOS: https://github.com/edx/edx-app-ios
- Android: https://github.com/edx/edx-app-android

### Configure Android app
#### Clone App repo
```
git clone https://github.com/edx/edx-app-android
```

#### Configure App
1. Open Android Studio, run **Clean Project** and **Gradle Sync**.

2. Reorder gradle plugin, open *build.gradle(Module: OpenEdXMobile)*, find and move down *kotlin-android-extensions* under *kotlin-android* like below code
```
apply plugin: 'edxapp'
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply plugin: 'kotlin-android-extensions'
apply plugin: 'jacoco-android'
```
3. Create configure folder (Ex: virgo_config) as a sibling of the edx-app-android repository

4. Create **/OpenEdXMobile/edx.properties** file at the top level of the repository. In **edx.properties** file, set
```
edx.dir='path_to_configure_dir'  # Ex: '../virgo_config'
```

5. Custom Resource
To customize images, colors andlayouts, you can specify a custom resource directory.

- Create **./path_to_resource** folder
- Add your resource directory to **Gradle Scripts > constants.gradle** file
```
project.ext {
  ...
  RES_DIR = "../path_to_your_resource"
}
```

6. BUilding for release
To build an APK for release, you have to specify an application ID and sigining key

- Change APPLICATION_ID in **Gradle Scripts > constants.gradle** file
```
project.ext {
  APPLICATION_ID = "com.virgodarth.mobile"
}
```

- Create Key store, you can use Android Studio to create keystore (Android Studio > Build > Generate Signed Bundle/ APK ... > APK + Next > Create new... > Enter form and OK).

- To Build for release version, you follow Android Studio > Build > Generate Signed Bundle/ APK ... > APK + Next > Enter keys above step > prodRelease > Finish.

## Note
- Don't upgrade gradle
