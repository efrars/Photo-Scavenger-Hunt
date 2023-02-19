//
//  TaskDetailViewController.swift
//  Photo Scavenger Hunt
//
//  Created by Efrain Rodriguez on 2/16/23.
//

import UIKit
import MapKit
import PhotosUI



class TaskDetailViewController: UIViewController, MKMapViewDelegate {
    
 
    
    var task: Task!
    
    @IBOutlet private weak var checkMarkImage: UIImageView!
    
    @IBOutlet private weak var questionLabel: UILabel!
    
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet var navigationTitle: UINavigationItem!
    
    @IBOutlet private weak var mapView: MKMapView!
    
    
    @IBOutlet var attachPhoto: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.layer.cornerRadius = 12
        updateUI()
        updateMapView()
        mapView.register(TaskAnnotationView.self, forAnnotationViewWithReuseIdentifier: TaskAnnotationView.identifier)
        mapView.delegate = self
    }
    
    private func updateUI() {
        titleLabel.text = task.title
        questionLabel.text = task.question
        
        navigationTitle.title = task.title
        
        let completedImage = UIImage(systemName: task.isComplete ? "circle.inset.filled" : "circle")
        
        checkMarkImage.image = completedImage?.withRenderingMode(.alwaysTemplate)
        
        
        let color: UIColor = task.isComplete ? .systemBlue: .tertiaryLabel
        checkMarkImage.tintColor = color
        titleLabel.textColor = color
        
        
      
        attachPhoto.isHidden = task.isComplete
        
        
        
        
    }
    
    func presentGoToSettingsAlert() {
        let alertController = UIAlertController (
            title: "Photo Access Required",
            message: "In order to post a photo to complete a task, we need access to your photo library. You can allow access in Settings",
            preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func didTapAttachPhotoButton(_ sender: Any) {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized {
            
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                switch status {
                case .authorized:
                    
                    DispatchQueue.main.async {
                        self?.presentImagePicker()
                        
                    }
                default:
                    DispatchQueue.main.async {
                        // helper method to show settings alert
                        self?.presentGoToSettingsAlert()
                    }
                }
            }
        } else {
            presentImagePicker()
        }
        
        
        
    }
    func updateMapView() {
        // TODO: Set map viewing region and scale
        
  
        
        // Make sure the task has image location
        guard let imageLocation = task.imageLocation else { return }
        
        // Get the coordinate from the image location. This is the latitude/longitude of the location
        
        let coordinate = imageLocation.coordinate
        
        // Set the map view's region based on the coordinate of the image
        // The span represents the map's "zoom level". A smaller value yields a more "zoomed in" map area, while a larger value is more "zoomed out".
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
        // Add an annotation to the map view based on image location.
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        
        
    }
    
    private func presentImagePicker() {
        // TODO: Create, configure and present image picker.
        // Create a configuration object
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        
        // Set the filter to only show images as options (i.e no videos, etc)
        config.filter = .images
        
        // Request the original file format. Fastest method as it avoids transcoding.
        config.preferredAssetRepresentationMode = .current
        
        // Only allow 1 image to be selected at a time.
        
        config.selectionLimit = 1
        
        // Instantiate a picker, passing in the configuration.
        
        let picker = PHPickerViewController(configuration: config)
        
        // Set the picker delegate so we can receive whatever image the user picks.
        
        picker.delegate = self
        
        // Present the picker
        present(picker, animated: true)
        
        
    }
    
    private func showAlert(for error: Error? = nil) {
        let alertController = UIAlertController(
            title: "Oops...",
            message: "\(error?.localizedDescription ?? "Please try again...")",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
    
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

  
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: TaskAnnotationView.identifier, for: annotation) as? TaskAnnotationView else {
            fatalError("Unable to dequeue TaskAnnotationView")
        }


        annotationView.configure(with: task.image)
        return annotationView
    }
    
}

extension TaskDetailViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        
        picker.dismiss(animated: true)
        
        let result = results.first
        
        guard let assetId = result?.assetIdentifier,
        let location = PHAsset.fetchAssets(withLocalIdentifiers: [assetId] , options: nil).firstObject?.location else {
            return
        }
        
        print("Image location coordinate: \(location.coordinate)")
        
        guard let provider = result?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self]  object, error in
            
            if let error = error {
                DispatchQueue.main.async { [weak self] in self?.showAlert(for: error)}
                
             
            }
            
            
            guard let image = object as? UIImage else { return }
            print("We have an image!")
            
            DispatchQueue.main.async { [weak self] in
                
                self?.task.set(image, with: location)
                
                self?.updateUI()
                
                self?.updateMapView()
                
               
            }
            
        }
    }
    
    
}
