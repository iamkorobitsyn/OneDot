//
//  TabBarController.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    let customTabBar = CustomTabBar()
    let trackerButton = TrackerButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue(customTabBar, forKey: "tabBar")
        setViewControllers()
        setButton()
    }
    
    private func setButton() {
        tabBar.addSubview(trackerButton)
        trackerButton.setState(.pressed)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap))
        trackerButton.addGestureRecognizer(tap)

        trackerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackerButton.widthAnchor.constraint(equalToConstant:
                                                    trackerButton.buttonDiameter),
            trackerButton.heightAnchor.constraint(equalToConstant:
                                                    trackerButton.buttonDiameter),
            trackerButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -16),
            trackerButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor)
        ])
    }
    
    @objc private func tap() {
        trackerButton.setState(.pressed)
        selectedIndex = 1
    }

    private func setViewControllers() {
        
        let toolsVC: UIViewController = setNavigation(ToolsViewController(),
                                                      "Tools")
        let trackerVC: UIViewController = setNavigation(TrackerViewController(),
                                                        "Tracker")
        let profileVC: UIViewController = setNavigation(ProfileViewController(),
                                                        "Profile")
    
        
        toolsVC.tabBarItem.image = UIImage(named: "iconHelperCircled")
        toolsVC.tabBarItem.selectedImage = UIImage(named: "iconHelperPainted")

        profileVC.tabBarItem.image = UIImage(named: "iconProfileCircled")
        profileVC.tabBarItem.selectedImage = UIImage(named: "iconProfilePainted")
        
 
        viewControllers = [toolsVC,
                           trackerVC,
                           profileVC]
        
        selectedViewController = trackerVC
    }
    
    private func setNavigation(_ rootVC: UIViewController,
                               _ title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootVC)
        rootVC.title = title
        navigationVC.navigationBar.tintColor = UIColor.green
        navigationVC.tabBarItem.title = .none
        navigationVC.navigationBar.prefersLargeTitles = true
        
        let appearence = UINavigationBarAppearance()
        appearence.backgroundColor = UIColor.customBlueDeep
        appearence.largeTitleTextAttributes = [.backgroundColor: UIColor.clear,
                                               .foregroundColor: UIColor.customBlueLight]
        appearence.titleTextAttributes = [.backgroundColor: UIColor.customBlueLight,
                                          .foregroundColor: UIColor.customBlueLight]
        navigationVC.navigationBar.standardAppearance = appearence
        navigationVC.navigationBar.scrollEdgeAppearance = appearence
        navigationVC.navigationBar.tintColor = UIColor.red
        
        return navigationVC
    }

}

extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let selectedIndex = self.tabBar.items?.firstIndex(of: item)
        if selectedIndex == 1 {
            trackerButton.setState(.pressed)
        } else {
            trackerButton.setState(.free)
        }
    }
}
