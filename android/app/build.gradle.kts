plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "ma.congress.congress_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "ma.congress.congress_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "congress"
    productFlavors {
        create("agpc") { dimension = "congress"; applicationId = "ma.congress.agpc"; resValue("string", "app_name", "AGPC") }
        create("somcep") { dimension = "congress"; applicationId = "ma.congress.somcep"; resValue("string", "app_name", "SOMCEP") }
        create("ama") { dimension = "congress"; applicationId = "ma.congress.ama"; resValue("string", "app_name", "AMA") }
        create("smcpre") { dimension = "congress"; applicationId = "ma.congress.smcpre"; resValue("string", "app_name", "SMCPRE") }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
