//
//  Controller.swift
//  OneDot
//
//  Created by Александр Коробицын on 25.09.2023.
//

import UIKit

class NavigationVC: UINavigationController, UINavigationControllerDelegate, CAAnimationDelegate {
    
    
    let themesVC = ThemesVC()
    let test = MainVC()
    
    
    let splashScreen: SplashScreen = SplashScreen()
    let tabBar: TabBar = TabBar()
    
    let profileVC: ProfileVC = ProfileVC()
    let settingsVC: SettingsVC = SettingsVC()
    
    
    //MARK: - Metrics
    
    let tabBarWidth: CGFloat = UIScreen.main.bounds.width / 1.05
    let tabBarHeight: CGFloat = 95

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        Animator.shared.splashScreenAnimate(splashScreen.launchLogo,
                                          splashScreen.gradientLayer,
                                             delegate: splashScreen)
        setViews()
        getCurrentUserInterfaceStyle()
        setConstraints()
        
    }
    
    
        
    override func viewDidAppear(_ animated: Bool) {
        for vc in viewControllers {
            if let main = vc as? MainVC {
                for cell in main.toolsBar.themesVC.currentRows {
                    if let themesCell = cell as? ColorThemeViewCell {
                        themesCell.navigationVCColorSetDelegate = self
                    }
                }
            }
        }
        
      
        
        for vc in viewControllers {
            if let main = vc as? MainVC {
                main.toolsBar.showTabBarCompletion = { [weak self] show in
                    guard let self else {return}
                    if show == true {
                        Animator.shared.tabBarShow(tabBar)
                        tabBar.isHidden = false
                        main.trackerBar.statesRefresh(locations: false,
                                                      tools: true)
                    } else {
                        Animator.shared.tabBarHide(tabBar, self)
                    }
                }
            }
        }
    }
    
    
    //MARK: - SetView
    
    private func setViews() {
        
        view.addSubview(tabBar)
        view.addSubview(splashScreen)
        
        
        tabBar.backgroundColor = .currentColorSet.tabBarColor
        
        

        tabBar.profileButton.addTarget(self,
                                       action: #selector(presentProfile), 
                                       for: .touchUpInside)
    }
    
    @objc private func presentSettings() {
        present(settingsVC, animated: true)
    }
    
    @objc private func presentProfile() {
        pushViewController(profileVC, animated: true)
        
        Animator.shared.tabBarHide(tabBar, self)

    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        tabBar.isHidden = true
    }
    
    
    
    //MARK: - SetNavigationBar
    
    private func getCurrentUserInterfaceStyle() {
        let i = TraitCollectionManager.shared.theme.getUserInterfaceStyle().rawValue
        print(i)
        if i == 1 {
            setNavigationBar(true,
                .currentColorSet.mainDynamicColor,
                .currentColorSet.titleDynamicColor,
                .label)
        } else if i == 2 {
            setNavigationBar(false,
                .currentColorSet.mainDynamicColor,
                .currentColorSet.titleDynamicColor,
                .label)
        } else if i == 0 {
            if traitCollection.userInterfaceStyle == .light {
                setNavigationBar(true,
                    .currentColorSet.mainDynamicColor,
                    .currentColorSet.titleDynamicColor,
                    .label)
            } else if traitCollection.userInterfaceStyle == .dark {
                setNavigationBar(false,
                    .currentColorSet.mainDynamicColor,
                    .currentColorSet.titleDynamicColor,
                    .label)
            }
        }
        
    }
    
    private func setNavigationBar(_ backgroundIsHidden: Bool,
                                  _ backgroundColor: UIColor,
                                  _ foregroundColor: UIColor,
                                  _ tintColor: UIColor) {
        
        navigationBar.prefersLargeTitles = true
        navigationBar.tintColor = tintColor
        
       
        
        if backgroundIsHidden == true {
            
            navigationBar.scrollEdgeAppearance = .none
            navigationBar.standardAppearance.largeTitleTextAttributes = 
            [.backgroundColor: UIColor.clear,
             .foregroundColor: foregroundColor,
             .font: UIFont.systemFont(ofSize: 35, weight: .black, width: .compressed)]
            
        } else {
        
            let appearence = UINavigationBarAppearance()
            appearence.largeTitleTextAttributes = [.backgroundColor: UIColor.clear,
                                                   .foregroundColor: foregroundColor,
                                                   .font: UIFont.systemFont(ofSize: 35,
                                                    weight: .black,
                                                    width: .compressed)]
            appearence.backgroundColor = backgroundColor
            navigationBar.scrollEdgeAppearance = appearence
        }
        

    }
    
    //MARK: - NavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController != profileVC, viewController != settingsVC {
          
            Animator.shared.tabBarShow(tabBar)
            
            tabBar.isHidden = false
            tabBar.isUserInteractionEnabled = true
        } else if viewController == profileVC {
            tabBar.isUserInteractionEnabled = false
        } else if viewController == settingsVC {
            tabBar.isUserInteractionEnabled = false
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        splashScreen.translatesAutoresizingMaskIntoConstraints = false
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            splashScreen.topAnchor.constraint(equalTo: view.topAnchor),
            splashScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            splashScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            splashScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            tabBar.widthAnchor.constraint(equalToConstant: tabBarWidth),
            tabBar.heightAnchor.constraint(equalToConstant: tabBarHeight),
            tabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, 
                                            constant: -20)
        ])
    }
}


extension NavigationVC: NavigationVCColorSetProtocol {
    func update(_ set: ColorSetProtocol, _ barBGIsHidden: Bool) {
        tabBar.backgroundColor = set.tabBarColor
        setNavigationBar(barBGIsHidden, set.mainDynamicColor, set.titleDynamicColor, set.titleDynamicColor)
    }
    

}

