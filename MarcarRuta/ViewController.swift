//
//  ViewController.swift
//  MarcarRuta
//
//  Created by Jose Navarro Alabarta on 25/1/16.
//  Copyright © 2016 ai2-upv. All rights reserved.
//

/***

Proyecto: Hacer una aplicación en Swift que se pueda correr en el simulador de iOS usando Xcode. Esta aplicación, cuando el usuario se mueva, deberá ir marcando con pines sobre un mapa, la ruta que el usuario sigue. Cada pin deberá contener en el Título, su posición en latitud y longitud, y en su Subtítulo, la distancia recorrida hasta ese momento.



Descripción: Hacer una aplicación en Swift que se pueda correr en el simulador de iOS usando Xcode y que permita:

NOTA: Como el programa corre en el simulador se debe seleccionar la opción de “Paseo en bicicleta” por lo que supondrá que la posición actual del dispositivo es Cupertino, CA, USA. Si el programa se corre en un dispositivo, marcará la ruta real seguida por el usuario.

    · Ponga un mapa en la pantalla.
    · Permita cambiar el tipo de mapa que muestra (Estándar, Satélite o Híbrido) mediante 3 botones o el mecanismo que usted desee.
    · El mapa debe estar centrado en la posición actual del dispositivo.
    · El mapa debe tener un zoom in en el que se puedan ver las calles de la ciudad (usted decide cuánto es).
    · Pedir autorización para leer la posición del dispositivo.
    · Muestre la posición actual del dispositivo en todo momento (punto azul).
    · Cada vez que el dispositivo se mueva a más de 50 metros del punto actual, deberá colocar un pin.
    · El pin debe tener como título, la posición en (longitud, latitud).
    · El pin debe tener como subtítulo, la distancia recorrida hasta el momento.
***/

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
     private let clManejador = CLLocationManager()
    let radioRegion:CLLocationDistance = 100.0
    var posAnterior:CLLocation = CLLocation()
    var posInicial:CLLocation? = nil
    var distanciaAcumulada = 0.0
    var distancia = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.clManejador.delegate = self
        self.clManejador.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.clManejador.requestWhenInUseAuthorization()
        mapa.showsUserLocation = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     
     Parte del GPS
     */
     
     
     //autorizacion de la app para que lo accepte el usuario
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            self.clManejador.startUpdatingLocation()
            self.clManejador.startUpdatingHeading()
            mapa.showsCompass = true
            mapa.zoomEnabled = true
            mapa.scrollEnabled = true
            self.clManejador.distanceFilter = 50.0
        }else{
            self.clManejador.stopUpdatingLocation()
            self.clManejador.stopUpdatingHeading()
            mapa.showsUserLocation = false
            mapa.showsCompass = false
            mapa.zoomEnabled = false
            mapa.scrollEnabled = false
        }
    }
    
    //se obtnienen los valores de los 6 paramétros del protocolo
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //let localizacionActual = locations.last
        let localizacionActual = self.clManejador.location!
        
        
        
        
        
        
        centerMapOnLocation(localizacionActual)
        
        if posInicial == nil{
            posInicial = localizacionActual
        }
        
        distancia = localizacionActual.distanceFromLocation(posInicial!)
        
        let pin = MKPointAnnotation() //MKPointAnnotation --> ya ha implementado el protocolo MKAnnotation
        pin.title = "\(localizacionActual.coordinate.latitude), \(localizacionActual.coordinate.longitude)"
        pin.subtitle = "\(distancia)"
        pin.coordinate = localizacionActual.coordinate
        mapa.addAnnotation(pin)
        
    
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, radioRegion * 2.0, radioRegion * 2.0)
        mapa.setRegion(coordinateRegion, animated: true)
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let alerta = UIAlertController(title: "Error", message: "error \(error.code)", preferredStyle: .Alert)
        // boton OK
        let accionOk = UIAlertAction(title: "Ok", style: .Default, handler:
            { accion in
                //hacer algo ..
        })
        
        alerta.addAction(accionOk)
        self.presentViewController(alerta, animated: true, completion: nil)
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //norteGeo.text = "\(newHeading.trueHeading)"
        //norteMg.text = "\(newHeading.magneticHeading)"
    }
    

    @IBAction func seleccionarMapaStandar(sender: UIButton) {
        if mapa.mapType != MKMapType.Standard {
            mapa.mapType = MKMapType.Standard
        }
    }
    
    
    
    @IBAction func seleccionarMapaSatelital(sender: UIButton) {
        
        if mapa.mapType != MKMapType.Satellite {
            mapa.mapType = MKMapType.Satellite
        }
    }
    
    
    
    @IBAction func seleccionarMapaHibrido(sender: UIButton) {
        if mapa.mapType != MKMapType.Hybrid {
            mapa.mapType = MKMapType.Hybrid
        }
    }
    
    
    
    
    


}

