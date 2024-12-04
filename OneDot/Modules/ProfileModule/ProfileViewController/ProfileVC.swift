//
//  ProfileViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import UIKit
import HealthKit

class ProfileVC: UIViewController, UIScrollViewDelegate {
    
    
    // MARK: - Properties
        let healthStore = HKHealthStore() // Для работы с HealthKit
        var workouts: [HKWorkout] = []   // Массив тренировок для отображения
        
        // Таблица для отображения тренировок
        let tableView: UITableView = {
            let table = UITableView()
            table.backgroundColor = .clear
            table.translatesAutoresizingMaskIntoConstraints = false
            return table
        }()
    

    private let blurEffectView: UIVisualEffectView = {
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effect.disableAutoresizingMask()
        effect.layer.masksToBounds = true
        effect.layer.cornerRadius = .barCorner
        return effect
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "additionalHideIcon"), for: .normal)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let view = UIPageControl()
        view.disableAutoresizingMask()
        view.numberOfPages = 2
        view.currentPageIndicatorTintColor = .myPaletteGold
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.disableAutoresizingMask()
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        return view
    }()
    
    private let segmenter: UISegmentedControl = {
        let view = UISegmentedControl(items: ["Week", "Month", "Year", "All time"])
        view.disableAutoresizingMask()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        scrollView.delegate = self
        
        
        
        setViews()
        setConstraints()
        requestHealthKitAccess()
        
        scrollView.contentSize = CGSize(width: view.frame.width * 2, height: 100)
        
        let firstPanel = createMetricPanel(time: "06:40:54", distance: "64.6 km", calories: "3568 kcal")
                firstPanel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
                scrollView.addSubview(firstPanel)
                
                // Добавление второй панели
                let secondPanel = createMetricPanel(time: "03:20:27", distance: "32.3 km", calories: "1784 kcal")
                secondPanel.frame = CGRect(x: view.frame.width, y: 0, width: view.frame.width, height: 100)
                scrollView.addSubview(secondPanel)
    }
    
    private func createMetricPanel(time: String, distance: String, calories: String) -> UIView {
           let panel = UIView()
           
           let timeLabel = UILabel()
           timeLabel.text = time
           timeLabel.font = .systemFont(ofSize: 16, weight: .bold)
           timeLabel.textAlignment = .center
           
           let distanceLabel = UILabel()
           distanceLabel.text = distance
           distanceLabel.font = .systemFont(ofSize: 16)
           distanceLabel.textAlignment = .center
           
           let caloriesLabel = UILabel()
           caloriesLabel.text = calories
           caloriesLabel.font = .systemFont(ofSize: 16)
           caloriesLabel.textAlignment = .center
           
           let stackView = UIStackView(arrangedSubviews: [timeLabel, distanceLabel, caloriesLabel])
           stackView.axis = .vertical
           stackView.alignment = .center
           stackView.spacing = 8
           stackView.frame = panel.bounds
           stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           
           panel.addSubview(stackView)
           return panel
       }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scroll")
    }
       
       // MARK: - Запрос доступа к HealthKit
       func requestHealthKitAccess() {
           let workoutType = HKObjectType.workoutType() // Тип данных - тренировки
           
           healthStore.requestAuthorization(toShare: nil, read: [workoutType]) { [weak self] success, error in
               if success {
                   self?.fetchWorkouts()
                   print("fetchWorkouts")
               } else {
                   print("Ошибка при запросе доступа: \(error?.localizedDescription ?? "неизвестная ошибка")")
               }
           }
       }
       
       // MARK: - Загрузка данных о тренировках
       func fetchWorkouts() {
           let workoutType = HKObjectType.workoutType()
           let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
           
           let query = HKSampleQuery(sampleType: workoutType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { [weak self] _, samples, error in
               if let error = error {
                   print("Ошибка загрузки тренировок: \(error.localizedDescription)")
                   return
               }
               
               guard let workouts = samples as? [HKWorkout] else { return }
               self?.workouts = workouts
               
               DispatchQueue.main.async {
                   self?.tableView.reloadData()
               }
           }
           
           healthStore.execute(query)
       }
    
    @objc private func dismissProfile() {
        dismiss(animated: true)
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        
        view.backgroundColor = .clear
        view.addSubview(blurEffectView)
        
        blurEffectView.contentView.addSubview(dismissButton)
        blurEffectView.contentView.addSubview(pageControl)
        blurEffectView.contentView.addSubview(scrollView)
        
        blurEffectView.contentView.addSubview(segmenter)
        
        blurEffectView.contentView.addSubview(tableView)
        
        dismissButton.setImage(UIImage(named: "SSHide"), for: .normal)
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
            
            scrollView.widthAnchor.constraint(equalToConstant: .barWidth),
            scrollView.heightAnchor.constraint(equalToConstant: 200),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor),
            
            segmenter.widthAnchor.constraint(equalToConstant: .barWidth),
            segmenter.heightAnchor.constraint(equalToConstant: 42),
            segmenter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmenter.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: segmenter.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}


extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return workouts.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "WorkoutCell")
           cell.backgroundColor = .red
           
           let workout = workouts[indexPath.row]
           cell.textLabel?.text = workout.workoutActivityType.name // Тип тренировки (название)
           
           let duration = workout.duration / 60 // Длительность в минутах
           let energy = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0 // Сожженные калории
           
           cell.detailTextLabel?.text = String(format: "Длительность: %.1f мин, Калории: %.0f ккал", duration, energy)
           return cell
       }
       
       // MARK: - UITableViewDelegate
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           let workout = workouts[indexPath.row]
           print("Вы выбрали тренировку: \(workout.workoutActivityType.name)")
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
