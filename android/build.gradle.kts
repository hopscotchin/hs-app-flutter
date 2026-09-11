allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

extra["clientId"] = "hopscotch"
extra["hyperSDKVersion"] = "2.2.2"

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    // `:app` builds into build/host, not build/app. Now that pubspec declares
    // `flutter: module:` (for add-to-app), the flutter tool looks for the host
    // app's APK/AAB under <project>/build/host/outputs/... - the same convention
    // as its own generated module host app. Without this, `flutter run` and
    // `flutter build apk` succeed in Gradle and then fail with "Gradle build
    // failed to produce an .apk file".
    val subprojectDirName = if (project.name == "app") "host" else project.name
    val newSubprojectBuildDir: Directory = newBuildDir.dir(subprojectDirName)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
