plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.authenticateapp"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.authenticateapp"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    // ✅ Kotlin options block goes INSIDE android in KTS Gradle

}

dependencies {
    implementation(libs.appcompat)
    implementation(libs.material)
    implementation(libs.activity)
    implementation(libs.constraintlayout)

    // Firebase Authentication
    implementation("com.google.firebase:firebase-auth:23.0.0")

    // Firebase BOM
    implementation(platform("com.google.firebase:firebase-bom:33.1.1"))

    // Play services
    implementation("com.google.android.gms:play-services-auth:21.1.0")

    // Core Kotlin extensions
    implementation("androidx.core:core-ktx:1.13.1")

    testImplementation(libs.junit)
    androidTestImplementation(libs.ext.junit)
    androidTestImplementation(libs.espresso.core)
}
