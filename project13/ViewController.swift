//
//  ViewController.swift
//  project13
//
//  Created by Tamim Khan on 5/3/23.
//
import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "instaFilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPiture))
        
        
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
       
        
        
    }
    @objc func importPiture(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        currentImage = image
        
        let begainImage = CIImage(image: currentImage)
        currentFilter.setValue(begainImage, forKey: kCIInputImageKey)
        applyProcessing()
        
        
    }
    
    
    
    
    @IBAction func changeFilter(_ sender: UIButton) {
        
        let ac = UIAlertController(title: "choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        
        
        if let popOverController = ac.popoverPresentationController{
            popOverController.sourceView = sender
            popOverController.sourceRect = sender.bounds
        }
        
        present(ac, animated: true)
        
    }
    
    func setFilter(action: UIAlertAction){
        guard currentImage != nil else {return}
        guard let actionTile = action.title else {return}
        currentFilter = CIFilter(name: actionTile)
        
        
        let begainImage = CIImage(image: currentImage)
        currentFilter.setValue(begainImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {return}
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_ :didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    func applyProcessing() {
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey){
            currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey){
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey){
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        
        guard let image = currentFilter.outputImage else { return }
        if let cgimg = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            imageView.image = processedImage
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if let error = error {
            let ac = UIAlertController(title: "save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
        }else{
            let ac = UIAlertController(title: "saved", message: "your photo has been saved", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            present(ac, animated: true)
        }
    }
    
    
}

