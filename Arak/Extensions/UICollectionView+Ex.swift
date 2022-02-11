import UIKit

extension UICollectionView {

    func register<T:UICollectionViewCell>(_: T.Type){
        let bundle = Bundle(for: T.self)
        let nib =  UINib(nibName: T.nibName, bundle: bundle)


        register(nib, forCellWithReuseIdentifier: T.nibName)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath)-> T{

        guard let cell = dequeueReusableCell(withReuseIdentifier: T.nibName, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.nibName)")
        }

        return cell
    }

}

protocol NibLoadableView {
    static var nibName:String { get }
}

extension UICollectionViewCell:NibLoadableView{
    static var nibName:String {
        return String(describing: self)
    }


}

extension UICollectionViewFlowLayout {

    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }

}
