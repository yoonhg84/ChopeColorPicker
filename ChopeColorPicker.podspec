Pod::Spec.new do |s|
  s.name         = "ChopeColorPicker"
  s.version      = "0.0.1"
  s.summary      = "ColorPicker for selecting color"
  s.description  = <<-DESC
  ColorPicker for iOS
  Touch and select color in picker
                   DESC
  s.homepage     = "https://github.com/yoonhg84/ChopeColorPicker"
  s.screenshots  = "https://github.com/yoonhg84/ChopeColorPicker/blob/master/Screenshots/screenshot-1.gif?raw=true"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Chope" => "yoonhg2002@gmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/yoonhg84/ChopeColorPicker.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/**/*.swift"
end
