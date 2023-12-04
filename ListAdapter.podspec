
Pod::Spec.new do |s|
  s.name             = 'ListAdapter'
  s.version          = '1.0.0'
  s.summary          = 'A short description of ListAdapter.'
  s.description      = <<-DESC
  By encapsulating the delegates of tableView and collectionView, and using DiffableDataSource for refreshing data, it significantly simplifies the process of list construction and enhances development efficiency.
                       DESC
  s.homepage         = 'https://github.com/tanxl/ListAdapter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tanxl' => '125322078@qq.com' }
  s.source           = { :git => 'https://github.com/cocomanbar/ListAdapter.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '13.0'
  
  s.swift_version = '5.0'
  
  s.static_framework = true
  
  s.source_files = 'ListAdapter/Classes/**/*'
  
  s.frameworks = 'UIKit', 'Combine'
  
end
