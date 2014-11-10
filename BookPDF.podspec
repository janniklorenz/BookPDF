Pod::Spec.new do |spec|
  spec.name         = 'BookPDF'
  spec.version      = '1.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'http://www.janniklorenz.de'
  spec.authors      = { 'Jannik Lorenz' => 'dev@janniklorenz.de' }
  spec.summary      = 'iOS 7 iBooks like PDF Viewer with Thumbnail Bar'
  spec.source       = { :git => 'https://github.com/janniklorenz/BookPDF', :tag => 'v1.0' }
  spec.source_files = '*.{h,m}'
  spec.framework    = 'SystemConfiguration'
end
