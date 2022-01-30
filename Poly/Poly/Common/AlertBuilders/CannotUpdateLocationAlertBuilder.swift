import UIKit

struct CannotUpdateLocationAlertBuilder: AlertBuilder {
    func make() -> UIAlertController {
        let primaryAction = UIAlertAction(title: "OK", style: .default)
        let alertController = UIAlertController(
            title: "Oops",
            message: "We are not able to get your location info.",
            preferredStyle: .alert
        )
        alertController.addAction(primaryAction)
        return alertController
    }
}

