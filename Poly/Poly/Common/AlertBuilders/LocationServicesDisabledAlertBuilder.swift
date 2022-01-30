import UIKit

struct LocationServicesDisabledAlertBuilder {
    let primaryActionHandler: () -> Void
    var cancelHandler: (() -> Void)?
}

extension LocationServicesDisabledAlertBuilder: AlertBuilder {
    func make() -> UIAlertController {
        let primaryAction = UIAlertAction(title: "Go to settings", style: .destructive) { _ in self.primaryActionHandler() }
        let cancelAction = UIAlertAction(title: "I'll do it later", style: .cancel) { _ in self.cancelHandler?() }
        let alertController = UIAlertController(
            title: "Oops",
            message: "To be able to track your location, you need to enable location services from settings.",
            preferredStyle: .alert
        )
        alertController.addAction(primaryAction)
        alertController.addAction(cancelAction)
        return alertController
    }
}

