import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
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
        applicationId = "com.itechevent.agpc2026"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keyFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            if (keyFile != null && keyFile.exists()) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = keyFile
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    flavorDimensions += "congress"
    productFlavors {
        create("agpc") { dimension = "congress"; applicationId = "com.itechevent.agpc2026"; resValue("string", "app_name", "AGPC") }
        create("somcep") { dimension = "congress"; applicationId = "com.itechevent.somcep2026"; resValue("string", "app_name", "SOMCEP") }
        create("ama") { dimension = "congress"; applicationId = "ma.congress.ama"; resValue("string", "app_name", "AMA") }
        create("smcpre") { dimension = "congress"; applicationId = "ma.congress.smcpre"; resValue("string", "app_name", "SMCPRE") }
        create("amg11") { dimension = "congress"; applicationId = "ma.congress.amg11fes"; resValue("string", "app_name", "AMG 11") }
    }

    buildTypes {
        release {
            val releaseSigning = signingConfigs.getByName("release")
            signingConfig = if (releaseSigning.storeFile != null && releaseSigning.storeFile!!.exists()) {
                releaseSigning
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
