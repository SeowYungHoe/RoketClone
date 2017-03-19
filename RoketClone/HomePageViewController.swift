//
//  HomePageViewController.swift
//  RoketClone
//
//  Created by Seow Yung Hoe on 17/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit
import HealthKit

class HomePageViewController: UIViewController {
//--------------------Outlets---------------------
    
 
    @IBOutlet weak var profileButton: UIButton!{
        didSet{
            profileButton.addTarget(self, action: #selector(pushToProfilePage), for: .touchUpInside)

        }
    }
    
    @IBOutlet weak var historyButton: UIButton!{
        didSet{
            historyButton.addTarget(self, action: #selector(pushToHistoryPage), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var challengeButtonPressed: UIButton!{
        didSet{
            challengeButtonPressed.addTarget(self, action: #selector(pushToChallengePage), for: .touchUpInside)
        }
    }
    @IBOutlet weak var healthKitOutlet: UIButton!
    
    @IBOutlet weak var enableHealthKitButton: UIButton!{
        didSet{
            enableHealthKitButton.addTarget(self, action: #selector(getHealthKitPermission), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    //----------------Constants and Variables--------------
    let healthStore = HKHealthStore()
    
   

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        messageLabel.isHidden = true
        enableHealthKitButton.isHidden = true
        
        if HKHealthStore.isHealthDataAvailable() {
            let authorizationStatus = healthStore.authorizationStatus(for: .workoutType())
            
            
            if authorizationStatus == .notDetermined {
                enableHealthKitButton.isHidden = false
                
            } else if authorizationStatus == .sharingDenied {
                messageLabel.isHidden = false
                messageLabel.text = "Meditations doesn't have access to your workout data. You can enable access in the Settings application."
            }
            
        } else {
            messageLabel.isHidden = false
            messageLabel.text = "HealthKit is not available on this device."
        }
        
        healthKitOutlet.isHidden = !HKHealthStore.isHealthDataAvailable()
    }
    
    //----------------------------HealthKit------------------------------------
    func getHealthKitPermission(){
        var shareTypes = Set<HKSampleType>()
        shareTypes.insert(HKSampleType.workoutType())
        
        var readTypes = Set<HKObjectType>()
        readTypes.insert(HKObjectType.workoutType())
        
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { (success, error) -> Void in
            if success {
                print("success")
            } else {
                print("failure")
            }
            
            if let error = error { print(error) }
        }
    }
    
    
    func workOutAnHour() {
        
        let dateInterval = NSDateInterval()
        let finish = NSDate() // Now
        let start = finish.addingTimeInterval(-3600) // 1 hour ago
        let workout = HKWorkout(activityType: .running, start: start as Date, end: finish as Date)
        let totalEnergyBurned = HKQuantity(unit: HKUnit.jouleUnit(with: .kilo), doubleValue: 1000)
        let totalDistance = HKQuantity(unit: HKUnit.meter(), doubleValue: 3000)
        
        
        let workoutEvents: [HKWorkoutEvent] = [
            HKWorkoutEvent(type: .pause, date: dateInterval.startDate.addingTimeInterval(300)),
            HKWorkoutEvent(type: .resume, date: dateInterval.startDate.addingTimeInterval(600))
        ]
        
        
    }

    //---------------Navigation----------------
    func pushToProfilePage(){
        
        let storyboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated:true, completion: nil)
        
        
    }
    
    func pushToHistoryPage(){
        let storyboard = UIStoryboard(name: "MainPage", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController else {return}
        
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func pushToChallengePage(){
        
        
        let storyboard = UIStoryboard(name: "Friend", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "ChallengeViewController") as! ChallengeViewController
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated:true, completion: nil)

    }
    


}
