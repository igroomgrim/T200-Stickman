import PackageDescription

let package = Package(
    name: "T200-Stickman",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 0, minor: 18)
    ]
)
