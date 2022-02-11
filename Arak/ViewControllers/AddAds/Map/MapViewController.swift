//
//  MapViewController.swift
//  Arak
//
//  Created by Abed Qassim on 28/02/2021.
//

import UIKit
import MapKit
class MapViewController: UIViewController {
  typealias SelectLocation = (CLLocation?, String?) -> Void
  typealias PermissionDenied = () -> Void

  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var map: MKMapView!

  private var pinAnnotationView: MKPinAnnotationView!
  private var selectedLocation: CLLocation?
  private var country: String = ""
  private var locationManager = LocationServiceManager()
  private var permissionDenied: PermissionDenied?
  private var confrimLocation: SelectLocation?
  private var currentLocation: CLLocation?

  // Create a search completer object
  override func viewDidLoad() {
        super.viewDidLoad()
    title = "Pick the location".localiz()
    self.setupLocationManager()
    self.setupUI()
        // Do any additional setup after loading the view.
    }
    
  @IBAction func Confirm(_ sender: Any) {
    if selectedLocation == nil {
        selectedLocation = currentLocation
    }
    confrimLocation?(selectedLocation, country)
    self.navigationController?.popViewController(animated: true)

  }

  func configue(permissionDenied: PermissionDenied?, confrimLocation: SelectLocation?) {
    self.permissionDenied = permissionDenied
    self.confrimLocation = confrimLocation

  }
    
    func showSettingsLocation() {
        let alertController = UIAlertController(title: "Location Permission Required".localiz(), message: "Please enable location permissions in settings.".localiz(), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Settings".localiz(), style: .default, handler: {(cAlertAction) in
            //Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .default, handler: {(cAlertAction) in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
  // call request authorization
  func setupLocationManager() {
    locationManager.setup {
      self.permissionDenied?()
      self.showSettingsLocation()
    } locationRetrieved: { (currentLocation) in
      self.currentLocation = currentLocation
      self.selectedLocation = currentLocation
      self.getCity()
      self.setupCurrentLocation()
    }
    addGesture()
  }
  private func getCity() {
    if let currentLocation = selectedLocation {
      CLGeocoder().reverseGeocodeLocation(currentLocation) { (pm, error) in
          if let placeMark = pm , placeMark.count > 0 {
            let pm = placeMark[0]
               var addressString : String = ""
               if pm.subLocality != nil {
                  addressString = addressString + pm.subLocality! + ", "
               }
               if pm.thoroughfare != nil {
                   addressString = addressString + pm.thoroughfare! + ", "
                }
               if pm.locality != nil {
                  addressString = addressString + pm.locality! + ", "
               }
               if pm.country != nil {
                  addressString = addressString + pm.country! + ", "
               }
               if pm.postalCode != nil {
                  addressString = addressString + pm.postalCode! + " "
                }

            self.country = addressString
          }
      }
    }
 }

  private func setupUI() {
    confirmButton.setTitle("Confrim".localiz(), for: .normal)
  }
  private func setupCurrentLocation() {
    addAnnotation(lat: currentLocation?.coordinate.latitude, lng: currentLocation?.coordinate.longitude)
    map.mapType =  MKMapType.standard
  }
   func addGesture() {
    let longPressGesture = UITapGestureRecognizer(target: self,
                                                  action: #selector(addAnnotationOnLongPress(gesture:)))
    map.addGestureRecognizer(longPressGesture)
  }

  @objc func addAnnotationOnLongPress(gesture: UITapGestureRecognizer) {
    if gesture.state == .ended {
      let point = gesture.location(in: map)
      let coordinate = map.convert(point, toCoordinateFrom: map)
      selectedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
      getCity()
      self.addAnnotation(lat: self.selectedLocation?.coordinate.latitude,
                         lng: self.selectedLocation?.coordinate.longitude)
    }
  }

  private func addAnnotation(lat: CLLocationDegrees?, lng: CLLocationDegrees?) {
    guard let lat = lat, let lng = lng else {return}
    map.removeAnnotations(map.annotations)
    let annotation = CustomPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
    annotation.title = ""
    annotation.pinCustomImageName = "location_pin"
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
    pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
    map.addAnnotation(pinAnnotationView.annotation!)
    map.setRegion(region, animated: true)
  }

}

extension MapViewController: MKMapViewDelegate {
  // change pin image view using custom image
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let reuseIdentifier = "pin"
    var annotationView = map.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
    if annotationView == nil {
      annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
      annotationView?.canShowCallout = true
    } else {
      annotationView?.annotation = annotation
    }
    if let customPointAnnotation = annotation as? CustomPointAnnotation {
      annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
    }
    return annotationView
  }
}
