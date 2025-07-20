// android/app/build.gradle.kts

plugins {
    id("com.android.application")
    kotlin("android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.project_beauty_admin" // Uygulamanızın paket adı
    compileSdk = 35 // Android API seviyesi 35 olarak güncellendi

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/tools/publishing/app-signing#application-id)
        applicationId = "com.example.project_beauty_admin" // Uygulama ID'si
        minSdk = 21 // Minimum desteklenen Android SDK versiyonu
        targetSdk = 35 // Hedeflenen Android SDK versiyonu da 35 olarak güncellendi
        versionCode = flutter.versionCode.toInt()
        versionName = flutter.versionName
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Read more about signing your app: https://developer.android.com/studio/publish/app-signing
            signingConfig = signingConfigs.getByName("debug") // Örnek olarak debug config kullanıldı
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Test bağımlılıkları
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
}
