#!/bin/bash

# **** Update me when new Xcode versions are released! ****
PLATFORM="platform=iOS Simulator,OS=9.2,name=iPhone 6"
SDK="iphonesimulator"

# It is pitch black.
set -e
function trap_handler() {
    echo -e "\n\nOh no! You walked directly into the slavering fangs of a lurking grue!"
    echo "**** You have died ****"
    exit 255
}
trap trap_handler INT TERM EXIT

MODE="$1"

if [ "$MODE" = "tests" ]; then
    echo "Building & testing GameOfThronesFeedReader."
    pod install
    xcodebuild \
        -workspace GameOfThronesFeedReader.xcworkspace \
        -scheme GameOfThronesFeedReader \
        -sdk "$SDK" \
        -destination "$PLATFORM" \
        test | xcpretty
    trap - EXIT
    exit 0
fi

if [ "$MODE" = "build" ]; then
    echo "Building GameOfThronesFeedReader."
    pod install
    xctool/xctool.sh \
        -workspace GameOfThronesFeedReader.xcworkspace \
        -scheme GameOfThronesFeedReader \
        -sdk "$SDK" \
        -destination "$PLATFORM" \
        build
    trap - EXIT
    exit 0
fi

echo "Unrecognised mode '$MODE'."
