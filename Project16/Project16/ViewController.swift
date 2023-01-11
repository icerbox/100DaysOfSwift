//
//  ViewController.swift
//  Project16
//
//  Created by Айсен Еремеев on 10.01.2023.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate, UINavigationControllerDelegate {
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var satellite: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let yakutsk = Capital(title: "Якутск", coordinate: CLLocationCoordinate2D(latitude: 62.04189, longitude: 129.74092), info: "https://ru.wikipedia.org/wiki/Якутск")
    
    let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "https://ru.wikipedia.org/wiki/Лондон")
    
    let oslo = Capital(title: "Осло", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "https://ru.wikipedia.org/wiki/Осло")
    
    let paris = Capital(title: "Париж", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "https://ru.wikipedia.org/wiki/Париж")
    
    let rome = Capital(title: "Рим", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "https://ru.wikipedia.org/wiki/Рим")
    
    let washington = Capital(title: "Вашингтон округ Колумбия", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "https://ru.wikipedia.org/wiki/Вашингтон")
    mapView.addAnnotations([ yakutsk, london, oslo, paris, rome, washington])
    
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is Capital else { return nil }
    
    let identifier = "Capital"
    
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView?.canShowCallout = true
      
      let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      pin.canShowCallout = true
      pin.pinTintColor = UIColor.yellow
      annotationView = pin
      
      let btn = UIButton(type: .detailDisclosure)
      annotationView?.rightCalloutAccessoryView = btn
    } else {
      annotationView?.annotation = annotation
      
    }
    return annotationView
  }
  
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let capital = view.annotation as? Capital else { return }
    
    let placeInfo = capital.info

    let detailViewController = DetailViewController()
    detailViewController.currentUrl = placeInfo
    navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  @IBAction func showSatelliteView(_ sender: Any) {
    mapView.mapType = .satellite
  }
  @IBAction func showStandartView(_ sender: Any) {
    mapView.mapType = .standard
  }
  @IBAction func showHybridView(_ sender: Any) {
    mapView.mapType = .hybrid
  }
  

  
  
}





