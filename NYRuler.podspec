
Pod::Spec.new do |s|
  s.name         = "NYRuler"
  s.version      = "1.0"
  s.summary      = "A ruler for scroll"

  s.description  = <<-DESC
                   commit the first version
                   DESC

  s.homepage     = "https://github.com/Akries/NYRuler.git"

  s.license      = "MIT"


  s.author             = { "Akries.Ni" => "zxcnoo@163.com" }
  s.source       = { :git => "https://github.com/Akries/NYRuler.git", :tag => "master{1.0}" }


  s.source_files  = "NYRuler-master/*.{h,m}"
  s.requires_arc = true

end
