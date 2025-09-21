plugins {
    id("com.android.library") version "8.5.2"
    kotlin("android") version "2.0.20"
    id("maven-publish")
}

android {
    namespace = "io.tezos.mobile"
    compileSdk = 34

    defaultConfig {
        minSdk = 24
        targetSdk = 34
        consumerProguardFiles("consumer-rules.pro")
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
        debug {
            isMinifyEnabled = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlin {
        jvmToolchain(17)
    }
}

dependencies {
    implementation(platform("org.jetbrains.kotlin:kotlin-bom:2.0.20"))
    implementation("org.jetbrains.kotlin:kotlin-stdlib:2.0.20")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.squareup.moshi:moshi:1.15.1")
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.2.1")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.6.1")
}

publishing {
    publications {
        create<MavenPublication>("release") {
            groupId = "io.tezos"
            artifactId = "mobile-android-sdk"
            version = "0.1.0"
        }
    }
}


