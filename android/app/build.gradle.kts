plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

android {
    namespace = "in.hopscotch.android.flutter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_18
        targetCompatibility = JavaVersion.VERSION_18
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_18.toString()
    }

    defaultConfig {
        applicationId = "in.hopscotch.android.flutter"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        debug {
//            applicationIdSuffix = ".debug"
            // CleverTap TEST workspace — mirrors native Android's `debug` /
            // `staging` / `qa` / `uat` buildTypes which all ship the test creds.
            manifestPlaceholders["CLEVERTAP_ACCOUNT_ID"] = "TEST-ZW4-64W-955Z"
            manifestPlaceholders["CLEVERTAP_TOKEN"] = "TEST-046-401"
        }
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            // CleverTap production workspace — mirrors native Android's
            // `release` / `beta` buildTypes.
            manifestPlaceholders["CLEVERTAP_ACCOUNT_ID"] = "WW4-64W-955Z"
            manifestPlaceholders["CLEVERTAP_TOKEN"] = "046-400"
        }
        // Flutter's third variant. Its Gradle plugin registers this build type
        // with `initWith debug`, but it does so while applying the plugin —
        // before this block runs — so the placeholders set on `debug` above are
        // not there to copy and profile inherits none. Without them the manifest
        // merger fails on the CleverTap meta-data and `flutter run --profile`
        // cannot build at all, which is what the profile launch config in
        // .vscode/launch.json hits. maybeCreate fills in the existing build type
        // rather than replacing it, so the signing config it took from debug
        // stays intact.
        //
        // TEST creds, matching debug rather than release: a profile build is for
        // measuring, and pointing it at the production CleverTap workspace would
        // put profiling runs into real analytics.
        maybeCreate("profile").apply {
            manifestPlaceholders["CLEVERTAP_ACCOUNT_ID"] = "TEST-ZW4-64W-955Z"
            manifestPlaceholders["CLEVERTAP_TOKEN"] = "TEST-046-401"
        }
    }
}

flutter {
    source = "../.."
}
