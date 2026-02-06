# Deploying the App to an Android Smartphone

This document outlines the steps to deploy your Flutter application to an Android smartphone for development and release.

## For Development (Running directly on device)

This method is ideal for testing the app during development.

1.  **Enable USB Debugging on your Android Device**:
    *   Go to your phone's **Settings** > **About phone** (or **About device**).
    *   Tap on **Build number** seven times. This will enable **Developer options**.
    *   Go back to **Settings**, search for or navigate to **Developer options**.
    *   Find and enable **USB debugging**.

2.  **Connect your Android Device to your Computer**:
    *   Use a USB cable to connect your phone to your computer.
    *   If prompted on your phone, allow **USB debugging** from your computer.

3.  **Verify Device Connection (Optional)**:
    *   Open your terminal or command prompt.
    *   Run `flutter devices`. You should see your connected Android device listed.
        ```bash
        flutter devices
        ```
        Example output:
        ```
        1 device connected:

        Pixel 3a (mobile) • 9CNBD11111 • android-arm64 • Android 12 (API 31)
        ```

4.  **Run the App on your Device**:
    *   With your device connected and recognized, run the Flutter application:
        ```bash
        flutter run
        ```
    *   The app will compile and install on your connected Android device.

## For Release (Generating a Signed APK/App Bundle)

To distribute your app (e.g., on Google Play Store or to users directly), you'll need to build a signed release version.

1.  **Generate an Upload Key**:
    If you don't already have one, create a keystore using `keytool`. This key is essential for signing your app. **Keep this key safe and private!**

    ```bash
    keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
    ```
    *   `~/key.jks`: This is the path to your keystore file. You can choose any name and location.
    *   `upload`: This is the alias for your key.

2.  **Reference the Keystore from Flutter**:
    *   Create a file named `key.properties` in your `android` folder (`my_time/android/key.properties`).
    *   Add the following lines, replacing the placeholder values with your actual keystore information:
        ```properties
        storePassword=<YOUR_STORE_PASSWORD>
        keyPassword=<YOUR_KEY_PASSWORD>
        keyAlias=upload
        storeFile=/Users/<YOUR_USERNAME>/key.jks
        ```
        **Important**: Do NOT check `key.properties` into version control. Add it to your `.gitignore`.

3.  **Configure Build Process to Sign the App**:
    *   Edit `android/app/build.gradle`.
    *   Locate the `android { ... }` block and add the following configuration to reference your `key.properties`:

        ```gradle
        android {
            ...
            defaultConfig { ... }
            signingConfigs {
                release {
                    storeFile file(System.env.STORE_FILE ?: project.properties['storeFile'])
                    storePassword System.env.STORE_PASSWORD ?: project.properties['storePassword']
                    keyAlias System.env.KEY_ALIAS ?: project.properties['keyAlias']
                    keyPassword System.env.KEY_PASSWORD ?: project.properties['keyPassword']
                }
            }
            buildTypes {
                release {
                    // TODO: Add your own signing config for the release build.
                    // Signing with the debug keys for now, so `flutter run --release` works.
                    signingConfig signingConfigs.release
                    ...
                }
            }
        }
        ```
    *   **Note**: Ensure `key.properties` is loaded securely. The example uses `project.properties`, but for CI/CD, you might use environment variables (e.g., `System.env.STORE_PASSWORD`).

4.  **Build the App Bundle (Recommended for Google Play)**:
    An App Bundle is Google Play's publishing format that includes all your app's compiled code and resources, but defers APK generation and signing to Google Play. This results in smaller app downloads for users.
    ```bash
    flutter build appbundle --release
    ```
    The generated App Bundle will be located at `build/app/outputs/bundle/release/app-release.aab`.

5.  **Build a Signed APK (for direct distribution)**:
    If you need to distribute the app directly without Google Play, you can build a signed APK.
    ```bash
    flutter build apk --release
    ```
    The generated APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.

**Always ensure your signing credentials are handled securely and never commit them to public repositories.**
