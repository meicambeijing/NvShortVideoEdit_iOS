#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint NvShortVideoEdit.podspec` to validate before publishing.
#
Pod::Spec.new do |spec|
  spec.name         = "NvShortVideoEdit"
  spec.version      = "0.0.1"
  spec.summary      = "the editor module"
  spec.description  = "the media asset editor"
  spec.homepage     = "https://www.meishesdk.com"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "meishe" => "meicamapp@meishesdk.com" }
  spec.source       = { :git => "https://github.com/meicambeijing/NvShortVideoEdit.git", :tag => "#{spec.version}" }

  spec.platform              = :ios
  spec.static_framework      = false
  spec.ios.deployment_target = '12.0'
  spec.ios.requires_arc      = true

  spec.ios.pod_target_xcconfig   = {
    'SWIFT_VERSION'                    => '5.0',
    'ENABLE_BITCODE'                   => 'NO',
    'DEFINES_MODULE'                   => 'YES',
    'BUILD_LIBRARIES_FOR_DISTRIBUTION' => 'YES'
  }
  
  spec.ios.source_files = 'SourceFiles/*'
  spec.ios.public_header_files = 'SourceFiles/*.h'
  #iOS sdk文件放在Frameworks文件夹下 需要的配置，
  spec.ios.vendored_frameworks = [
    'Frameworks/MNN.xcframework',
    'Frameworks/NvStreamingSdkCore.xcframework',
    'Frameworks/NvMSAutoTemplate.xcframework',
    'Frameworks/NvShortVideoCore.xcframework'
  ]

  spec.ios.dependency 'SSZipArchive'
  spec.ios.dependency 'SDWebImageWebPCoder'
 
end

  
