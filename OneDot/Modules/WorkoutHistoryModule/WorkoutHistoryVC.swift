//
//  ProfileViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import UIKit
import HealthKit

class WorkoutHistoryVC: UIViewController {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    private enum Mode {
        case workouts
        case selectedWorkout
        case screenshot
        case settings
        case dismiss
    }
    
    let healthStore = HKHealthStore()
    var healthKitDataList: [WorkoutData]?
    
    private let blurEffectView: UIVisualEffectView = {
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        effect.disableAutoresizingMask()
        effect.layer.masksToBounds = true
        effect.layer.cornerRadius = 10
        return effect
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "BodyHide"), for: .normal)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.disableAutoresizingMask()
        pageControl.numberOfPages = 4
        pageControl.currentPageIndicatorTintColor = .myPaletteGold
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private let metricsPanel: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.disableAutoresizingMask()
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let segmenter: UISegmentedControl = {
        let view = UISegmentedControl(items: ["Week", "Month", "Year", "All time"])
        view.selectedSegmentTintColor = .myPaletteGold
        view.selectedSegmentIndex = 1
        view.setTitleTextAttributes([.foregroundColor: UIColor.white,
                                     .font: UIFont.systemFont(ofSize: 16,
                                                              weight: .medium,
                                                              width: .compressed)], for: .selected)
        view.setTitleTextAttributes([.foregroundColor: UIColor.myPaletteGray,
                                     .font: UIFont.systemFont(ofSize: 16,
                                                              weight: .light,
                                                              width: .compressed)], for: .normal)
        view.disableAutoresizingMask()
        return view
    }()
    
    private let workoutsListTable: UITableView = {
        let tableView = UITableView()
        tableView.disableAutoresizingMask()
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        return tableView
    }()
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        workoutsListTable.dataSource = self
        workoutsListTable.delegate = self
        
        metricsPanel.delegate = self
        metricsPanel.dataSource = self
        metricsPanel.register(AverageStatisticCell.self, forCellWithReuseIdentifier: "MetricsPanelCell")

        setViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        let currentMetricsPageValue = UserDefaultsManager.shared.profileMetricsPageValue
        DispatchQueue.main.async { self.setCurrentMetricsPage(currentPage: currentMetricsPageValue) }
    }
    
    //MARK: - DidScroll & CurrentMetrics
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView != metricsPanel { return }
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        setCurrentMetricsPage(currentPage: currentPage)
    }
    
    private func setCurrentMetricsPage(currentPage: Int) {
        pageControl.currentPage = currentPage
        let indexPath = IndexPath(row: currentPage, section: 0)
        metricsPanel.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        UserDefaultsManager.shared.profileMetricsPageValue = currentPage
    }
    
    //MARK: - Dismiss
    
    @objc private func selfDismiss() {
        dismiss(animated: true)
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        view.addSubview(blurEffectView)
        
        
        view.addSubview(pageControl)
        view.addSubview(metricsPanel)
        metricsPanel.backgroundColor = .clear
        
        view.addSubview(segmenter)
        
        view.addSubview(workoutsListTable)
        
        view.addSubview(dismissButton)
        
        workoutsListTable.register(WorkoutCell.self, forCellReuseIdentifier: "WorkoutCell")
        
        dismissButton.addTarget(self, action: #selector(selfDismiss), for: .touchUpInside)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            dismissButton.widthAnchor.constraint(equalToConstant: .iconSide),
            dismissButton.heightAnchor.constraint(equalToConstant: .iconSide),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            
            metricsPanel.topAnchor.constraint(equalTo: dismissButton.bottomAnchor),
            metricsPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            metricsPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            metricsPanel.heightAnchor.constraint(equalToConstant: 200),
            
            segmenter.widthAnchor.constraint(equalToConstant: .barWidth),
            segmenter.heightAnchor.constraint(equalToConstant: 42),
            segmenter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmenter.topAnchor.constraint(equalTo: metricsPanel.bottomAnchor),
            
            workoutsListTable.topAnchor.constraint(equalTo: segmenter.bottomAnchor),
            workoutsListTable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            workoutsListTable.widthAnchor.constraint(equalToConstant: .barWidth - 10),
            workoutsListTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - CollectionView


extension WorkoutHistoryVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = metricsPanel.dequeueReusableCell(withReuseIdentifier: "MetricsPanelCell", for: indexPath) as! AverageStatisticCell
        
        cell.workoutData = healthKitDataList
        
        switch indexPath.row {
        case 0:
            cell.activateMode(mode: .timeAndCalories)
        case 1:
            cell.activateMode(mode: .distanceAndClimb)
        case 2:
            cell.activateMode(mode: .heartRateAndPace)
        case 3:
            cell.activateMode(mode: .stepsAndCadence)
        default:
            break
        }
        return cell
    }
}


extension WorkoutHistoryVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return healthKitDataList?.count ?? 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           if let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell") as? WorkoutCell {

               cell.workoutData = healthKitDataList?[indexPath.row]
               cell.updateLabels()
               return cell
           }
           
           return UITableViewCell()
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        104
    }
       
       // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hapticGenerator.selectionChanged()
        
        let workoutFocusVC = WorkoutSnapshotVC()
        self.navigationController?.pushViewController(workoutFocusVC, animated: true)
        workoutFocusVC.workoutData = healthKitDataList?[indexPath.row]
    }
}



