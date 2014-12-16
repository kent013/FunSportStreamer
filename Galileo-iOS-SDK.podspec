Pod::Spec.new do |s|
  s.name                = "Galileo-iOS-SDK"
  s.version             = "0.9.6"
  s.vendored_frameworks = "Galileo-iOS-SDK/frameworks/GalileoControl.framework"
  s.libraries = 'xml2'
  s.frameworks = 'ExternalAccessory', 'CoreBluetooth'
end
