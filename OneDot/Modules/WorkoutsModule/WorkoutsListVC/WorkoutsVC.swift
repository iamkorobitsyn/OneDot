//
//  ProfileViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import UIKit
import HealthKit

class WorkoutsVC: UIViewController {
    
    let workout = HKWorkout(activityType: .running,
                            start: Date(),
                            end: Date(),
                            workoutEvents: nil,
                            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 200),
                            totalDistance: HKQuantity(unit: .meter(), doubleValue: 5000),
                            metadata: nil)
    
    let secondWorkout = HKWorkout(activityType: .running, start: Date(), end: Date(), workoutEvents: nil, totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 200), totalDistance: HKQuantity(unit: .meter(), doubleValue: 2000), totalSwimmingStrokeCount: nil, device: .local(), metadata: nil)
    
    
    let healthStore = HKHealthStore()
    var workouts: [HealthKitData] = []
    
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
        button.setImage(UIImage(named: "DSHideGray"), for: .normal)
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
    
    private let workoutTable: UITableView = {
        let tableView = UITableView()
        tableView.disableAutoresizingMask()
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        return tableView
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

    override func viewDidLoad() {
        super.viewDidLoad()
        workoutTable.dataSource = self
        workoutTable.delegate = self
        
        metricsPanel.delegate = self
        metricsPanel.dataSource = self
        metricsPanel.register(StatisticCell.self, forCellWithReuseIdentifier: "MetricsPanelCell")

        setViews()
        setConstraints()
        fetchHealthkitData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        let currentMetricsPageValue = UserDefaultsManager.shared.profileMetricsPageValue
        DispatchQueue.main.async { self.setCurrentMetricsPage(currentPage: currentMetricsPageValue) }
    }
    
       
    // MARK: - HealthKitRequest
    
    func fetchHealthkitData() {
        Task { [weak self] in
            
            do {
                guard let self else {return}
                let workouts = try await HealthKitManager.shared.fetchHealthKitData()
                self.workouts = workouts
                self.workoutTable.reloadData()
                
            } catch let error as HealthKitManager.HealthKitError {
                HealthKitManager.shared.errorHanding(error: error)
            }
        }
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
    
    @objc private func dismissProfile() {
        dismiss(animated: true)
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        view.addSubview(blurEffectView)
        
        view.addSubview(dismissButton)
        view.addSubview(pageControl)
        view.addSubview(metricsPanel)
        metricsPanel.backgroundColor = .clear
        
        view.addSubview(segmenter)
        
        view.addSubview(workoutTable)
        
        workoutTable.register(WorkoutCell.self, forCellReuseIdentifier: "WorkoutCell")

        dismissButton.addTarget(self, action: #selector(dismissProfile), for: .touchUpInside)
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
            
            workoutTable.topAnchor.constraint(equalTo: segmenter.bottomAnchor),
            workoutTable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            workoutTable.widthAnchor.constraint(equalToConstant: .barWidth - 10),
            workoutTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension WorkoutsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = metricsPanel.dequeueReusableCell(withReuseIdentifier: "MetricsPanelCell", for: indexPath) as! StatisticCell
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


extension WorkoutsVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return workouts.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           if let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell") as? WorkoutCell {
               let workout = workouts[indexPath.row]
               
               // Тип тренировки
               cell.topLeadingLabel.text = workout.workout.workoutType
               
               // Длительность тренировки
               let duration = workout.workout.duration / 60 // в минутах
               cell.topTrailingLabel.text = String(format: "%.1f мин", duration)
               
               
               if let distanceInMeters = workout.distance?.totalDistance {
                   let kilometers = Int(distanceInMeters / 1000)
                   let meters = Int(distanceInMeters.truncatingRemainder(dividingBy: 1000))
                   
                   cell.bottomLeadingLabel.text = "\(kilometers) km \(meters) m"
               }
               
               if let coordinates = workout.route?.locations {
                   print(coordinates.count)
               }
                    
               // Дата тренировки
               let dateFormatter = DateFormatter()
               dateFormatter.dateStyle = .short
               let workoutDate = dateFormatter.string(from: workout.workout.startDate)
               cell.bottomTrailingLabel.text = workoutDate
               
               
               
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
           // Получаем выбранную тренировку
              let workout = workouts[indexPath.row]
              
              // Создаём новый ViewController
           let workoutDetailsVC = DetailsVC()
           workoutDetailsVC.title = "Детали тренировки"
              
              // Переходим на новый ViewController через существующий navigationController
              navigationController?.pushViewController(workoutDetailsVC, animated: true)

       }
   }


// MARK: - Расширение для отображения названий типов тренировок
extension HKWorkoutActivityType {
    var name: String {
        switch self {
        case .running: return "Бег"
        case .walking: return "Ходьба"
        case .cycling: return "Велосипед"
        case .swimming: return "Плавание"
        case .yoga: return "Йога"
        case .other: return "Другое"
        default: return "Неизвестная тренировка"
        }
    }
}
