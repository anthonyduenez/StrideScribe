//
//  runTracker.swift
//  StrideScribe
//
//  Created by Anthony Duenez on 2/28/25.
//
import Foundation
import MapKit
import AudioToolbox
import BackgroundTasks

struct RunData: Identifiable {
    var id = UUID()
    var date: Date
    var distance: Double
    var pace: Double
    var elapsedTime: Int
    var locations: [CLLocation]
    
    func toDictionary() -> [String: Any] {
            return [
                "id": id.uuidString,
                "date": date.timeIntervalSince1970,
                "distance": distance,
                "pace": pace,
                "elapsedTime": elapsedTime,
                "locations": locations.map { ["lat": $0.coordinate.latitude, "lon": $0.coordinate.longitude] }
            ]
        }

        static func fromDictionary(_ dict: [String: Any]) -> RunData? {
            guard let idString = dict["id"] as? String,
                  let dateTimestamp = dict["date"] as? TimeInterval,
                  let distance = dict["distance"] as? Double,
                  let pace = dict["pace"] as? Double,
                  let elapsedTime = dict["elapsedTime"] as? Int,
                  let locationDicts = dict["locations"] as? [[String: Double]] else { return nil }

            let id = UUID(uuidString: idString) ?? UUID()
            let date = Date(timeIntervalSince1970: dateTimestamp)
            let locations = locationDicts.map { CLLocation(latitude: $0["lat"]!, longitude: $0["lon"]!) }

            return RunData(id: id, date: date, distance: distance, pace: pace, elapsedTime: elapsedTime, locations: locations)
        }
}
class runTracker: NSObject, ObservableObject {
    @Published var region = MKCoordinateRegion(center: .init(latitude: 32.6514, longitude: -161.4333), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    @Published var distance = 0.0
    @Published var pace = 0.0
    @Published var elapsedTime = 0
    @Published var isRunning = true
    @Published var presentCountdown = false
    @Published var presentRunView = false
    @Published var presentStopView = false
    @Published var locations = [CLLocation]()
    
    @Published var pastRuns: [RunData] = []
    
    var polyline: MKPolyline {
        let coordinates = locations.map { $0.coordinate }
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
    
    private var timer: Timer?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    //Track the location
    private var locationManager: CLLocationManager?
    private var startLocation: CLLocation?
    private var lastLocation: CLLocation?
    
    override init() {
        super.init()
        loadRunData()
        loadPastRuns()
        
        Task{
            await MainActor.run {
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.allowsBackgroundLocationUpdates = true
                locationManager?.pausesLocationUpdatesAutomatically = false
                locationManager?.requestAlwaysAuthorization()
                locationManager?.startUpdatingLocation()
            }
        }
    }
    
    func startRun(){
        registerBackgroundTask()
        UserDefaults.standard.set(Date(), forKey: "runStartTime")
        
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)){}
        presentRunView = true
        presentStopView = false
        isRunning = true
        startLocation = nil
        lastLocation = nil
        elapsedTime = 0
        distance = 0.0
        pace = 0.0
        locations.removeAll()
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else {return}
            self.elapsedTime += 1
            if self.distance > 0 {
                pace = ((Double(self.elapsedTime) / 60) / (self.distance / 1609) ) * 60
            }
        }
        locationManager?.startUpdatingLocation()
    }
    
    func resumeRun(){
        isRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else {return}
            self.elapsedTime += 1
            if self.distance > 0 {
                pace = ((Double(self.elapsedTime) / 60) / (self.distance / 1609)) * 60
            }
        }
        locationManager?.startUpdatingLocation()
    }
    func pauseRun(){
        isRunning = false
        locationManager?.stopUpdatingLocation()
        timer?.invalidate()
    }
    
    func stopRun(){
        presentRunView = false
        presentStopView = true
        isRunning = false
        locationManager?.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
        
        let completedRun = RunData(date: Date(), distance: distance, pace: pace, elapsedTime: elapsedTime, locations: locations)
        self.pastRuns.insert(completedRun, at: 0)
        print("🏃 Run saved! Total runs stored: \(self.pastRuns.count)")
        savePastRuns()
    }
    
    func deleteRun(at offsets: IndexSet){
        pastRuns.remove(atOffsets: offsets)
        savePastRuns()
    }
    
    func savePastRuns() {
        let runDicts = pastRuns.map {$0.toDictionary()}
        UserDefaults.standard.set(runDicts, forKey: "pastRuns")
    }
    
    func loadRunData(){
        if let savedStartTime = UserDefaults.standard.object(forKey: "runStartTime") as? Date {
            elapsedTime = Int(Date().timeIntervalSince(savedStartTime))
        }
        distance = UserDefaults.standard.double(forKey: "distance")
        
        if distance > 0{
            pace = ((Double(elapsedTime) / 60) / (distance / 1609)) * 60
        }
    }
    
    func loadPastRuns() {
        guard let runDicts = UserDefaults.standard.array(forKey: "pastRuns") as? [[String: Any]] else { return }
        pastRuns = runDicts.compactMap(RunData.fromDictionary)
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            self.endBackgroundTask()
        }
    }
    
    func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
}

//Mark location tracking
extension runTracker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.region.center = location.coordinate
        }
        
        self.locations.append(location)
        
        if startLocation == nil {
            startLocation = location
            lastLocation = location
            return
        }
        if let lastLocation {
            distance += lastLocation.distance(from: location)
        }
        lastLocation = location
    }
}
