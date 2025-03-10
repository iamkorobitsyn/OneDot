//
//  ProfileViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import UIKit
import HealthKit

class WorkoutListVC: UIViewController {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    private enum Mode {
        case workouts
        case selectedWorkout
        case screenshot
        case settings
        case dismiss
    }
    
    var workoutList: [WorkoutData]?
    var workoutStatistics: WorkoutStatistics?
    
    private let blurEffectView: UIVisualEffectView = UIVisualEffectView()
    
    private let pageControl: UIPageControl = UIPageControl()
    private let metricsPanel: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private let segmenter: UISegmentedControl = UISegmentedControl()
    
    private let workoutsListTable: UITableView = UITableView()

    private let dismissButton: UIButton = UIButton()
    
    //MARK: - DidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        metricsPanel.register(AverageStatisticCell.self, forCellWithReuseIdentifier: "MetricsPanelCell")
        metricsPanel.delegate = self
        metricsPanel.dataSource = self
        workoutsListTable.register(WorkoutCell.self, forCellReuseIdentifier: "WorkoutCell")
        workoutsListTable.dataSource = self
        workoutsListTable.delegate = self

        setViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        let currentMetricsPageValue = UserDefaultsManager.shared.profileMetricsPageValue
        DispatchQueue.main.async { self.setCurrentMetricsPage(currentPage: currentMetricsPageValue) }
    }
    
    //MARK: - Segmenter
    
    private func setSegmenter() {
        segmenter.selectedSegmentIndex = UserDefaultsManager.shared.statisticsSegmenterValue
        segmenterTapped(segmenter)
    }
    
    @objc private func segmenterTapped(_ sender: UISegmentedControl) {
        
        UserDefaultsManager.shared.statisticsSegmenterValue = sender.selectedSegmentIndex
        guard let workoutList else { return }
        workoutStatistics = CalculationsService.shared.getWorkoutStatistics(workoutList: workoutList,
                                                                            segmenterIndex: sender.selectedSegmentIndex)
        metricsPanel.reloadData()
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
        [blurEffectView, pageControl, metricsPanel, segmenter, workoutsListTable, dismissButton].forEach { view in
            self.view.addSubview(view)
            view.disableAutoresizingMask()
        }
        
        blurEffectView.effect = UIBlurEffect(style: .extraLight)
        blurEffectView.layer.masksToBounds = true
        blurEffectView.layer.cornerRadius = 10
        
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = .myPaletteGold
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.isUserInteractionEnabled = false

        metricsPanel.backgroundColor = .clear
        metricsPanel.isPagingEnabled = true
        metricsPanel.showsHorizontalScrollIndicator = false
        
        segmenter.insertSegment(withTitle: "Week", at: 0, animated: true)
        segmenter.insertSegment(withTitle: "Month", at: 1, animated: true)
        segmenter.insertSegment(withTitle: "Year", at: 2, animated: true)
        segmenter.selectedSegmentTintColor = .myPaletteGold
        segmenter.selectedSegmentIndex = 1
        segmenter.setTitleTextAttributes([.foregroundColor: UIColor.white,
                                     .font: UIFont.systemFont(ofSize: 16,
                                                              weight: .medium,
                                                              width: .compressed)], for: .selected)
        segmenter.setTitleTextAttributes([.foregroundColor: UIColor.myPaletteGray,
                                     .font: UIFont.systemFont(ofSize: 16,
                                                              weight: .light,
                                                              width: .compressed)], for: .normal)
        segmenter.addTarget(self, action: #selector(segmenterTapped(_:)), for: .valueChanged)
        setSegmenter()
        
        workoutsListTable.backgroundColor = .clear
        workoutsListTable.separatorColor = .clear
        
        dismissButton.setImage(UIImage(named: "BodyHide"), for: .normal)
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


extension WorkoutListVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = metricsPanel.dequeueReusableCell(withReuseIdentifier: "MetricsPanelCell", for: indexPath) as! AverageStatisticCell
        
        switch indexPath.row {
            
        case 0:
            cell.activateMode(mode: .timeAndCalories, statistics: workoutStatistics)
        case 1:
            cell.activateMode(mode: .distanceAndPace, statistics: workoutStatistics)
        case 2:
            cell.activateMode(mode: .heartRateAndCadence, statistics: workoutStatistics)
        default:
            break
        }
    
        return cell
    }
}


extension WorkoutListVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return workoutList?.count ?? 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           if let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell") as? WorkoutCell {

               cell.workoutData = workoutList?[indexPath.row]
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
        
        let snapshotVC = SnapshotVC()
        self.navigationController?.pushViewController(snapshotVC, animated: true)
        snapshotVC.workoutData = workoutList?[indexPath.row]
    }
}



