
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let networkService = NetworkService(baseURL: "https://www.avito.st/s/interns-ios")
        let advertisementsService = AdvertisementsService(networkService: networkService)
        
        window.rootViewController = UINavigationController(
            rootViewController: AdvertisementsViewController(advertisementsService: advertisementsService)
        )
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

