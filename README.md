# CollectionManager

Um jeito simples de criar e manipular uma UICollectionView.

[![CI Status](https://img.shields.io/travis/jjfernandes87/CollectionViewManager.svg?style=flat)](https://travis-ci.org/jjfernandes87/CollectionViewManager)
[![Version](https://img.shields.io/cocoapods/v/CollectionManager.svg?style=flat)](http://cocoapods.org/pods/CollectionManager)
[![License](https://img.shields.io/cocoapods/l/CollectionManager.svg?style=flat)](http://cocoapods.org/pods/CollectionManager)
[![Platform](https://img.shields.io/cocoapods/p/CollectionManager.svg?style=flat)](http://cocoapods.org/pods/CollectionManager)

## Features

- [x] Carregue uma coleção de UICollectionViewCell passando apenas um array
- [x] Carregue uma coleção de UICollectionViewCell com UIEdgeInsets diferentes para cada sessão
- [x] Carregue UICollectionViewCell com xib, sem necessidade de implementar Register(nib)
- [x] Remova UICollectionViewCell com apenas uma linha
- [x] Personalize o tamanho da sua UICollectionViewCell

## Requirements

- iOS 9.3+
- Xcode 9.0+
- Swift 4.0+

## Communication

- Se você **encontrou um bug**, abra uma issue.
- Se você **tem uma nova feature**, abra uma issue.
- Se você **quer contribuir**, envie uma pull request.

## Example

Para rodar o projeto de exemplo, clone o repositório, e rode o comando `pod install` no diretório Example primeiro.

## Installation

CollectionManager esta disponível através [CocoaPods](http://cocoapods.org). Para instalar, basta adicionar a linha abaixo no seu Podfile:

```ruby
pod 'CollectionManager'
```
Criando uma CellController e CellView. Veja que é necessário você adicionar @objc para sua classe que extende CellController, precisamos disso porque nossa CollectionManager usa o nome da classe como cellIdentifier (você deve configurar sua UICollectionViewCell com o mesmo nome da sua CellController no seu Xib ou Storyboard)

```swift
import CollectionManager

@objc(CustomCell)
class CustomCell: CellController {
...
}

class CustomCellView: CellView {
...
}
```
Depois de criada sua classe CellController está na hora de implementar os métodos necessários para seu funcionamento.

```swift
import CollectionManager

@objc(CustomCell)
class CustomCell: CellController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        ...
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        ...
    }
}
```
Na sua classe CellView vamos expor nossos IBOutlets.

```swift

class CustomCellView: CellView {
    @IBOutlet weak var ...
}
```
Agora falta pouco!
Precisamos popular nossa Interface com as cell's que acabamos de construir.

```swift
import CollectionManager

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: CollectionViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.items = [CustomCell(),CustomCell(),CustomCell(),CustomCell(),CustomCell(),CustomCell()]
        //or
        collectionView.setSectionsAndItems = /* caso você tenha SectionController */
    }
}
```

Pronto!

## Author

jjfernandes87, julio.fernandes87@gmail.com

## License

CollectionManager is available under the MIT license. See the LICENSE file for more info.
