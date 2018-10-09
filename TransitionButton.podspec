Pod::Spec.new do |s|
  s.name             = 'TransitionButton'
  s.version          = '0.5.2'
  s.summary          = 'UIButton sublass for loading and transition animation.'

  s.description      = <<-DESC
  UIButton sublass for loading and transition animation. Useful for network based application where you need to animate a button while doing background tasks.
  DESC
 
  s.homepage        = 'https://github.com/aladinway/TransitionButton'
  s.screenshots     = 'http://www.itechnodev.com/img/button-loading.png', 'http://www.itechnodev.com/img/button-transition-expanding.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alaeddine M.' => 'itechnodev@gmail.com' }
  s.source           = { :git => 'https://github.com/aladinway/TransitionButton.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '8.0'
  
  s.source_files = 'Source/*.{h,m,swift}'
  s.frameworks = 'UIKit'

end
