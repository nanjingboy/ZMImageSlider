Pod::Spec.new do |s|
  s.name             = 'ZMImageSlider'
  s.version          = '0.1.0'
  s.summary          = 'A simple image slide show library by Objective-C.'
  s.homepage         = 'https://github.com/nanjingboy/ZMImageSlider'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tom.Huang' => 'hzlhu.dargon@gmail.com' }
  s.source           = { :git => 'https://github.com/nanjingboy/ZMImageSlider.git', :tag => s.version.to_s }
  s.requires_arc = true
  s.ios.deployment_target = '7.0'
  s.source_files = "Source/*.{h,m}"
  s.resources    = 'ZMImageSlider.bundle'
  s.dependency "SDWebImage", "~> 3.7"
  s.dependency "Toast", "~> 3.0"
end
