//
//  PhotoAlbumViewController.swift
//  Virtual_Tourist
//
//  Created by Dan Henshaw on 12/10/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: createAlert, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var pin: Pin?
    var photos = [Photo]()
    let flickr = FlickrManager()
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var photoCollection = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        updateActionButton()
        configureCollectionView()
        setUpMap(pin: pin!)
        
        if getPhotosFromCoreData().isEmpty {
            searchPhotos()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateActionButton() {
        if photoCollection.isEmpty {
            actionButton.setTitle("New Collection", for: UIControlState.normal)
        } else {
            actionButton.setTitle("Remove Selected Images", for: UIControlState.normal)
        }
    }
    
    func configureCollectionView() {
        
        // SCALE PHOTOS
        
        collectionView?.contentMode = UIViewContentMode.scaleAspectFit
        collectionView?.backgroundColor = UIColor.white
        let space : CGFloat = 2.0
        
        //CONFIGURE PHOTO DIMENSIONS
        
        let dimension = (UIDevice.current.orientation.isPortrait) ?  (self.view.frame.width - (2 * space)) / 3.0 : (self.view.frame.height - (2 * space)) / 3.0
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    // SETUP MAP
    
    func setUpMap(pin: Pin) {
        let regionRadius: CLLocationDistance = 4000
        
        // CENTRE MAP ON LOCATION
        
        self.mapView.centerMapOnLocation(pin: pin, radius: regionRadius)
        
        // PLACE DROP PIN
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        self.mapView.addAnnotation(annotation)
    }
    
    // SEARCH FOR PHOTOS
    
    func searchPhotos() {
        if let pin = self.pin {
            flickr.searchByLocation(pin: pin) { (result, error) in
                if let error = error {
                    self.createAlert(error)
                } else {
                    
                    // SAVE PHOTOS TO CORE DATA
                    
                    if let urls = result {
                        if urls.count > 0 {
                            
                            // CREATE A NEW PHOTO OBJECT
                            
                            for url in urls {
                                let photo = Photo(context: CoreDataStack.shared.context)
                                photo.url = url
                                photo.pin = self.pin
                                
                                self.photos.append(photo)
                            }
                            
                            // UPDATE COLLECTION VIEW
                            
                            performUpdatesOnMain {
                                self.collectionView.reloadData()
                            }
                            
                            CoreDataStack.shared.save()
                            
                        } else {
                            self.createAlert("No photos found at this location")
                        }
                    }
                }
            }
        }
    }
    
    // LOAD PHOTOS FROM CORE DATA
    
    func getPhotosFromCoreData() -> [Photo] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.sortDescriptors = []
        let predicate = NSPredicate(format: "pin = %@", argumentArray: [pin!])
        fetchRequest.predicate = predicate
        
        do {
            if let results = try CoreDataStack.shared.context.fetch(fetchRequest) as? [Photo] {
                photos = results
            }
        }
            
        catch {
            createAlert("Error while trying to fetch photos from core data.")
        }
        
        return photos
    }

    // DELETE ALL PHOTOS FROM CORE DATA
    
    private func deleteAllPhotos() {
        
        for photo in photos {
            CoreDataStack.shared.context.delete(photo)
        }
        
        // RESET ARRAYS AND SAVE
        
        photos = []
        collectionView.reloadData()
        CoreDataStack.shared.save()
        photoCollection = []
    }
    
    // DELETE SELECTED PHOTOS FROM CORE DATA
    
    private func deleteSelectedPhotos() {
        for photo in photoCollection {
            
            // REMOVE PHOTOS FROM THE ARRAY
            
            photos.remove(at: photos.index(of: photo)!)
            
            // DELETE FROM CORE DATA
            
            CoreDataStack.shared.context.delete(photo)
        }
        
        // SAVE NEW PHOTO COLLECTION
        
        collectionView.reloadData()
        CoreDataStack.shared.save()
        photoCollection = []
    }
    
    // COLLECTION VIEW TABLE - COUNT PHOTOS
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    // COLLECTION VIEW TABLE - CONFIGURATION
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = self.photos[indexPath.row]

        cell.imageView.image = nil
        
        // DOWNLOAD NEW IMAGES IF CORE DATA IS EMPTY
        
        if photo.image == nil {
            cell.activityIndicator.startAnimating()
            
            flickr.downloadPhotos(photoURL: photo.url!){ (image, error)  in
                guard let imageData = image,
                    let newImage = UIImage(data: imageData as Data) else {
                        return
                }
                
                // DISPLAY DOWNLOADED PHOTOS
                
                performUpdatesOnMain {
                    if let photoCell = self.collectionView.cellForItem(at: indexPath) as? PhotoCell {
                        photoCell.imageView.image = newImage
                        photoCell.activityIndicator.stopAnimating()
                    }
                }
                cell.imageView.image = UIImage(data: imageData as Data)
                
                // SAVE PHOTOS TO CORE DATA
                
                photo.image = imageData
                CoreDataStack.shared.save()
            }
        } else {
            
            // DISPLAY DOWNLOADED PHOTOS
            
            cell.imageView.image = UIImage(data: photo.image! as Data)
        }
        return cell
    }
    
    // NEW COLLECTION / REMOVE SELECTED PHOTOS BUTTON
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        
        // HAVE ANY PHTOS BEEN SELECTED
        
        if photoCollection.isEmpty {
            
            // DELETE ALL PHOTOS AND DOWNLOAD NEW PHOTS
            
            deleteAllPhotos()
            searchPhotos()
            
        } else {
            
            // DELETE SELECTED PHOTOS ONLY
            
            deleteSelectedPhotos()
        }
    }
    
    // SELECT / DESELECT PHOTO
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        
        // UNMARK A SELECTED PHOTO
        
        if photoCollection.contains(photo) {
            cell.alpha = 1.0
            photoCollection.remove(at: photoCollection.index(of: photo)!)
            
        } else {
            
            // HIGHLIGHT SELECTED IMAGE
            
            cell.alpha = 0.375
            photoCollection.append(photo)
        }
        
        updateActionButton()
    }
}
