pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "tezos-android-example"
include(":app")

includeBuild("../../android-sdk") {
    dependencySubstitution {
        substitute(module("io.tezos:mobile-android-sdk")).using(project(":"))
    }
}


