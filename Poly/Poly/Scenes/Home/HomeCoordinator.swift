import UIKit

final class HomeCoordinator: NSObject {
    let window: UIWindow
    let interactor: HomeInteractor

    private lazy var homeViewController: HomeViewController = {
        let viewController = HomeViewController(interactor: interactor)
        viewController.delegate = self
        return viewController
    }()

    init(window: UIWindow) {
        self.window = window
        self.interactor = HomeInteractor()
        super.init()
    }

    func start() {
        window.rootViewController = homeViewController
        window.makeKeyAndVisible()
    }
}

extension HomeCoordinator: HomeViewControllerDelegate {
    func viewControllerWantsToNavigateToLocationSettings(_ viewController: HomeViewController) {
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
}
