Pod::Spec.new do |s|

  s.name         = "ZLPolygonView"
  s.version      = "1.0.2"
  s.summary      = "ZLPolygonView"

  s.description  = <<-DESC
                      六芒星能力值控件
                   DESC

  s.homepage     = "https://github.com/czl0325/ZLPolygonView-IOS"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "czl0325" => "295183917@qq.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/czl0325/ZLPolygonView-IOS.git", :tag => s.version }
  
  #s.ios.deployment_target = '8.0'
  s.source_files  = "ZLPolygonViewDemo/ZLPolygonView/*.{h,m}"
  #s.resources = 'SXWaveAnimate/images/*.{png,xib}'
 #s.exclude_files = "Classes/Exclude"
  s.requires_arc = true

end
