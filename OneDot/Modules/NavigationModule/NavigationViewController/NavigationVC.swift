//
//  Controller.swift
//  OneDot
//
//  Created by Александр Коробицын on 25.09.2023.
//

import UIKit

class NavigationVC: UINavigationController, UINavigationControllerDelegate, CAAnimationDelegate {
    
    
    let mainVC = MainBarColorThemesView()
    let test = MainVC()
    
    
    let greetingLoadingView: GreetingView = GreetingView()
    let tabBar: TabBar = TabBar()
    let settingsButton: UIButton = UIButton()
    
    let profileVC: ProfileVC = ProfileVC()
    let settingsVC: SettingsVC = SettingsVC()
    
    
    //MARK: - Metrics
    
    let tabBarWidth: CGFloat = UIScreen.main.bounds.width / 1.05
    let tabBarHeight: CGFloat = 95

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        Animator.shared.greetingViewRotation(greetingLoadingView.launchLogo,
                                             delegate: greetingLoadingView)
        setViews()
        getCurrentUserInterfaceStyle()
        setConstraints()
        
    }
    
    
        
    override func viewDidAppear(_ animated: Bool) {
        for vc in viewControllers {
            if let main = vc as? MainVC {
                main.mainBarBody.colorThemesView.navigationVCDelegate = self
            }
        }
        
      
        
        for vc in viewControllers {
            if let main = vc as? MainVC {
                main.tabBarCompletion = { [weak self] hide in
                    guard let self else {return}
                    if hide == true {
                        Animator.shared.tabBarHide(tabBar, self)
                    } else {
                        Animator.shared.tabBarShow(tabBar)
                        tabBar.isHidden = false
                    }
                }
            }
        }
    }
    
    
    //MARK: - SetView
    
    private func setViews() {
        view.addSubview(tabBar)
//        view.addSubview(settingsButton)
        view.addSubview(greetingLoadingView)
        
        tabBar.backgroundColor = .custom.mainDynamic
        
        

        tabBar.profileButton.addTarget(self,
                                       action: #selector(presentProfile), 
                                       for: .touchUpInside)
        
//        settingsButton.addTarget(self, action: #selector(presentSettings), for: .touchUpInside)
//        settingsButton.setImage(UIImage(named: "Image"), for: .normal)
//        settingsButton.setImage(UIImage(named: "Image"), for: .highlighted)

//        settingsButton.layer.cornerRadius = 21
//        settingsButton.layer.borderColor = UIColor.white.cgColor
//        settingsButton.layer.borderWidth = 0.5
//        settingsButton.backgroundColor = UIColor.sunsetSkyColor
        
        let button = UIBarButtonItem(systemItem: .add)
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = button
        
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
                .custom.mainDynamic,
                .custom.titleDynamic,
                .label)
        } else if i == 2 {
            setNavigationBar(false,
                .custom.mainDynamic,
                .custom.titleDynamic,
                .label)
        } else if i == 0 {
            if traitCollection.userInterfaceStyle == .light {
                setNavigationBar(true,
                    .custom.mainDynamic,
                    .custom.titleDynamic,
                    .label)
            } else if traitCollection.userInterfaceStyle == .dark {
                setNavigationBar(false,
                    .custom.mainDynamic,
                    .custom.titleDynamic,
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
             .font: UIFont.systemFont(ofSize: 35, weight: .medium, width: .compressed)]
            
        } else {

            let appearence = UINavigationBarAppearance()
            appearence.largeTitleTextAttributes = [.backgroundColor: UIColor.clear,
                                                   .foregroundColor: foregroundColor,
                                                   .font: UIFont.systemFont(ofSize: 35,
                                                    weight: .medium,
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
            settingsButton.isHidden = false
        } else if viewController == profileVC {
            tabBar.isUserInteractionEnabled = false
            settingsButton.isHidden = false
        } else if viewController == settingsVC {
            tabBar.isUserInteractionEnabled = false
            settingsButton.isHidden = true
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        greetingLoadingView.translatesAutoresizingMaskIntoConstraints = false
//        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            greetingLoadingView.topAnchor.constraint(equalTo: view.topAnchor),
            greetingLoadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            greetingLoadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            greetingLoadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            tabBar.widthAnchor.constraint(equalToConstant: tabBarWidth),
            tabBar.heightAnchor.constraint(equalToConstant: tabBarHeight),
            tabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, 
                                            constant: -20),
//            settingsButton.widthAnchor.constraint(equalToConstant: 24),
//            settingsButton.heightAnchor.constraint(equalToConstant: 24),
//            settingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
//            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, 
//                                            constant: -20)
        ])
    }
}


extension NavigationVC: NavigationVCColorSetProtocol {
    func update(_ set: ColorSetProtocol, _ barBGIsHidden: Bool) {
        tabBar.backgroundColor = set.mainDynamic
        
        
        settingsButton.backgroundColor = .white
        setNavigationBar(barBGIsHidden, set.mainDynamic, set.titleDynamic, set.titleDynamic)
    }
    

}

