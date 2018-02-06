#!/bin/sh

brew tap caskroom/cask

brew cask install android-sdk

export ANDROID_SDK_ROOT=/usr/local/share/android-sdk

brew cask install android-ndk

export ANDROID_NDK_HOME=/usr/local/share/android-ndk

