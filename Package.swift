// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription


// Get the values we need to populate the LIBTIDY_VERSION and RELEASE_DATE macros later.
func tidyVersion() -> [String] {
    let fileURL = URL(fileURLWithPath: #filePath)
    let versionFileURL = fileURL.deletingLastPathComponent().appendingPathComponent("Sources").appendingPathComponent("CLibTidy").appendingPathComponent("version.txt")

    if let contents = try? String(contentsOf: versionFileURL, encoding: .utf8) {
        return contents.components(separatedBy: "\n")
    }

    return ["5.0.0", "2021/01/01"]
}


let package = Package(
    name: "SwLibTidy",
    platforms: [
        .macOS(.v15),
    ],
    products: [

        .library(
            name: "SwLibTidy",
            targets: ["SwLibTidy"]),

        .executable(
            name: "Console",
            targets: ["Console"]),
    ],
    
    dependencies: [],
    
    targets: [

        .target(
            name: "CLibTidy"
            , dependencies: []
            , path: "Sources/CLibTidy"
            , exclude: [
                "CMakeLists.txt",
                "tidy.pc.cmake.in",
                "README.md",
                "version.txt",
                "build",
                "console",
                "experimental",
                "localize",
                "man",
                "README",
                "regression_testing",
                "include/buffio.h",
                "include/platform.h",
            ]
            , sources: ["src"]
            , publicHeadersPath: "include"
            , cSettings: [
                .define("LIBTIDY_VERSION", to: "\"\(tidyVersion()[0])\"", nil),
                .define("RELEASE_DATE", to: "\"\(tidyVersion()[1])\"", nil),
                .unsafeFlags(["-Wno-shorten-64-to-32"])
            ]
        ),
        
        .target(
            name: "SwLibTidy",
            dependencies: ["CLibTidy"],
            path: "Sources/SwLibTidy",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        
        .executableTarget(
            name: "Console",
            dependencies: ["SwLibTidy"],
            path: "Sources/Console",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),

        .testTarget(
            name: "SwLibTidyTests",
            dependencies: ["CLibTidy", "SwLibTidy"],
            resources: [
                .process("Resources/")
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
    ],
    
    cLanguageStandard: CLanguageStandard.gnu89
)
