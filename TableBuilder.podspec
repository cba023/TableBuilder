Pod::Spec.new do |s|
  s.name             = 'TableBuilder'
  s.version          = '2.0.2'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.8' }
  s.summary          = 'Easier to write TableView page.'
  s.homepage         = 'https://github.com/cba023/TableBuilder'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chenbo' => 'cba023@hotmail.com' }
  s.source           = { :git => 'https://github.com/cba023/TableBuilder.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'TableBuilder/Sources/**/*'
end
