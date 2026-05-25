// swift-tools-version:5.3
import PackageDescription

let package = Package(
   name: "caplink",
   platforms: [
     .iOS(.v14),
   ],
   products: [
      .library(name: "caplink", targets: ["caplink"])
   ],
   targets: [
      .binaryTarget(
         name: "caplink",
         url: "https://github.com/ctparton/food-rater/releases/download/1.0.0/caplink.xcframework.zip"
         ,checksum:"feaaa02e4fc82b2e07ea90fb9aaf7f20223da3616e61432311bdfecce110e08b")
   ]
)
