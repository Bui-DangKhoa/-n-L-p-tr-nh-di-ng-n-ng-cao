plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.myapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.myapp"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // tạm thời dùng debug key
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BoM - đồng bộ với Google Services 4.4.3
    implementation(platform("com.google.firebase:firebase-bom:33.5.1"))

    // Firebase Analytics
    implementation("com.google.firebase:firebase-analytics")

    // Firebase Authentication
    implementation("com.google.firebase:firebase-auth")
    
    // Cloud Firestore
    implementation("com.google.firebase:firebase-firestore")
}
