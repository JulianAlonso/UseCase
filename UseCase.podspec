Pod::Spec.new do |s|
  s.name             = "UseCase"
  s.version          = "1.0.2"
  s.summary          = "UseCase Base class to use .then, .catch"
  s.ios.deployment_target = '9.0'
  s.description      = <<-DESC
                       UseCase base class is designed to use .then and .catch when use case is finished.
                       It use apple operations framework to execute your use case `main` code.
                       DESC

  s.homepage         = "https://github.com/julianalonso/UseCase"
  s.license          = 'MIT'
  s.author           = { "Julian Alonso" => "julian.alonso.dev@gmail.com" }
  s.source           = { :git => "https://github.com/julianalonso/UseCase.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MaisterJuli'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Sources/**/*.swift'

end
