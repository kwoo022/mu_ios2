//
//  TGSULocationManager.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/03.
//

import CoreLocation


class TGSULocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let TAG = "[TGSULocationManager]"
    
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
        //위치정보승인요청
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation() 
    }
    
    func toggleUpdateLocation(_ isUpdate : Bool) {
        if isUpdate {
            manager.startUpdatingLocation()
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
            
        case .denied :
            // Alert
            //locationPermissionDenied = true
            TGSULog.log(TAG, "Authorization - Denied")
            //TGSULog.log(locationPermissionDenied)
            
        case .restricted:
            TGSULog.log(TAG, "Authorization - restricted")
            
        case .notDetermined:
            // Request
            TGSULog.log(TAG, "Authorization - not Determined")
            manager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse :
            TGSULog.log(TAG, "Authorization - Authorized when in use")
            manager.allowsBackgroundLocationUpdates = true
            manager.startUpdatingLocation()
            
        default:
            TGSULog.log(TAG, "Authorization - Default")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        TGSULog.log(TAG, "error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        location = locations.first?.coordinate
        
        if locations.first != nil {
            TGSULog.log(TAG, "location: \(location)")
        }
        
    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        location = locations.first?.coordinate
    //
    //        //위치 정보 업데이트 중단
    //        manager.stopUpdatingLocation()
    //    }
}
