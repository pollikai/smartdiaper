# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


def shared_pods
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    # Pods for targets
    pod 'SwiftLint'
    pod 'R.swift'
    pod 'RxSwift',    '~> 4.0'
    pod 'RxCocoa',    '~> 4.0'
end

target 'SmartDiaper' do
    shared_pods
    pod 'Firebase/Core'
end

target 'ColorAnalysis' do
    shared_pods
end

target 'SmartDiaperTests' do
    inherit! :search_paths
    # Pods for testing
end

