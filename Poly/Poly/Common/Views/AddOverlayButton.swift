import UIKit

final class AddOverlayButton: UIButton {
    var isEditing: Bool = false

    override func layoutSubviews() {
        super.layoutSubviews()

        if isEditing {
            setImage(nil, for: .normal)
            setTitle("Done", for: .normal)
            setTitleColor(.black, for: .normal)
            backgroundColor = .white
        } else {
            setImage(UIImage(systemName: "plus.app.fill"), for: .normal)
            setTitle("Add Overlay", for: .normal)
            setTitleColor(.white, for: .normal)
            backgroundColor = .black
        }

        tintColor = .white

        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        applyEdgeInsets()
        applyShadowAndRadius()
    }

    private func applyEdgeInsets() {
        if !isEditing {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
            contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        } else {
            imageEdgeInsets = .zero
            titleEdgeInsets = .zero
            contentEdgeInsets = .zero
        }
    }

    private func applyShadowAndRadius() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 4.0
        layer.masksToBounds = false
        layer.cornerRadius = bounds.height / 2
    }

}
