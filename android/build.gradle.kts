// build.gradle.kts (root project)

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// ✅ Không cần buildscript dependencies nữa
// buildscript {
//     dependencies {
//         classpath("com.google.gms:google-services:4.4.2")
//     }
// }

// ✅ Plugin đã được khai báo trong settings.gradle.kts
// plugins {
//     id("com.google.gms.google-services") version "4.4.3" apply false
// }
