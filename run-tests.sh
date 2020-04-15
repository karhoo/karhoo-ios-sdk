#!/bin/bash

cd KarhooSDK

pod install

cd ../

fastlane ios unit_tests_integration_tests
