//plugins {
//    id("com.android.application")
//    id("kotlin-android")
//    id("dev.flutter.flutter-gradle-plugin")
//    id("com.google.gms.google-services") // Apply plugin here without version and `apply false`
//}
//
//android {
//    namespace = "com.example.resqtrack1"
//    compileSdk = flutter.compileSdkVersion
//    ndkVersion = "27.0.12077973"
//
//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_11
//        targetCompatibility = JavaVersion.VERSION_11
//    }
//
//    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_11.toString()
//    }
//
//    defaultConfig {
//        applicationId = "com.tanishkasaxena.resqtrack"
//        minSdk = 24
//        targetSdk = flutter.targetSdkVersion
//        versionCode = flutter.versionCode
//        versionName = flutter.versionName
//    }
//
//    buildTypes {
//        release {
//            signingConfig = signingConfigs.getByName("debug")
//        }
//    }
//}
//
//flutter {
//    source = "../.."
//}
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.resqtrack1"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.tanishkasaxena.resqtrack"
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Add this line to include the androidx.annotation library
    implementation("androidx.annotation:annotation:1.7.0")
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.7.0-alpha01")
    implementation("com.google.android.material:material:1.9.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.6.1")
    implementation("androidx.core:core:1.12.0")
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("org.osmdroid:osmdroid-android:6.1.10")
    implementation("org.osmdroid:osmdroid-wms:6.1.10")
    implementation("org.osmdroid:osmdroid-geopackage:6.1.10")
    implementation("org.osmdroid:osmdroid-mapsforge:6.1.10")
}
