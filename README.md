# Barcode Data Matcher

Match data collected from the front of ID cards against the barcode on the back

## Installation

1. Open your project in Xcode
2. In the top menu select File -> Swift Packages -> Add Package Dependency ...
3. Enter the URL of this repository: `https://github.com/AppliedRecognition/Barcode-Data-Matcher-Apple`
4. Enter the desired version range, branch or commit hash
5. Press the Finish button

## Usage

1. Create an instance of `DocumentFrontPageData`, filling in the values for first name, last name, document number, etc.
2. Get the raw PDF417 barcode data from a barcode scanner.
3. Execute the `match(_:)` method on the `DocumentFrontPageData` instance to get a match score.
4. The score ranges from 0 (not matching at all) to 1 (all elements from the front page match the barcode).
