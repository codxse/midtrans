#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'midtrans'
  s.version          = '0.0.1'
  s.summary          = 'An in app payment with Midtrans'
  s.description      = <<-DESC
An in app payment with Midtrans.
                       DESC
  s.homepage         = 'https://nadiar.id'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Nadiar AS' => 'codxse@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'MidtransCoreKit'
  s.dependency 'MidtransKit'

  s.ios.deployment_target = '8.0'
end
