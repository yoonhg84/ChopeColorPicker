Pod::Spec.new do |s|
  s.name         = "ChopeColorPicker"
  s.version      = "0.0.1"
  s.summary      = "ColorPicker for selecting color"
  s.description  = <<-DESC
  ColorPicker for iOS
                   DESC
  s.homepage     = "https://github.com/yoonhg84/ChopeColorPicker"
  s.license      = "MIT"
  s.author             = { "Chope" => "yoonhg2002@gmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/yoonhg84/ChopeColorPicker.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/**/*.swift"
end
