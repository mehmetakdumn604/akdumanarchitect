pluginManagement {
    val flutterSdkPath: String = run {
        val properties = java.util.Properties()
        val localPropertiesFile = file("local.properties")
        localPropertiesFile.inputStream().use { properties.load(it) }
        val flutterSdk = properties.getProperty("flutter.sdk")
        require(flutterSdk != null) { "flutter.sdk not set in local.properties" }
        flutterSdk
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "7.2.0" apply false
    id("org.jetbrains.kotlin.android") version "1.7.10" apply false
}

include(":app")

