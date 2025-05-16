buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Add the classpath for the Google services plugin (keep this here)
        classpath("com.google.gms:google-services:4.4.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// Registering a clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
