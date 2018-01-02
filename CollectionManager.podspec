Pod::Spec.new do |s|
    s.name             = 'CollectionManager'
    s.version          = '0.0.3'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.summary          = 'Um jeito simples de criar e manipular uma UICollectionView.'
    s.homepage         = 'https://github.com/jjfernandes87/CollectionViewManager'
    s.social_media_url = 'https://twitter.com/jfernandes87'
    s.author           = { 'jjfernandes87' => 'julio.fernandes87@gmail.com' }
    s.source           = { :git => 'https://github.com/jjfernandes87/CollectionViewManager.git', :tag => s.version }
    s.ios.deployment_target = '9.3'
    s.source_files = 'CollectionManager/Classes/**/*'

    s.description      = <<-DESC
Esqueça todos os metodos obrigatórios para criar e manipular uma CollectionView, carregue modelos diferentes de UICollectionViewCell sem a necessidade de if no seu código.
    DESC
end
