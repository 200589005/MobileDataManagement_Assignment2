
import UIKit
import AssetsLibrary
import Photos
import PhotosUI
enum CameraStyle : Int {
    case front = 0,rear,none
}
public typealias imageComplition = ( _ image : UIImage?,_ strName : String?,_ error : Error?) -> Void

class CameraAndGalleryPermisson: NSObject{
    var cameraType : CameraStyle = .front
    static let sharedInstance = CameraAndGalleryPermisson()
    
    
    var complation = {( _ image : UIImage?,_ strName : String?,_ error : Error?) -> Void in  }
    
    override init() {
        super.init()
    }
    
    func openCamaraAndPhotoLibrary(_ viewController : UIViewController,isEdit : Bool = true,_ imageComplition : @escaping imageComplition){
        let alert:UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {
            UIAlertAction in
            self.openCamara(viewController, isEdit: isEdit, imageComplition)
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: .default) {
            UIAlertAction in
            self.openPhotoLibrary(viewController, isEdit: isEdit, imageComplition)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openCamara(_ vc : UIViewController,isEdit : Bool,_ imageComplition : @escaping imageComplition){
        
        
        CameraAndGalleryPermisson.sharedInstance.checkPermissionForCamera(authorizedRequested: {
            let picker = UIImagePickerController()
            picker.delegate = self
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                DispatchQueue.main.async{
                    picker.sourceType = UIImagePickerController.SourceType.camera
                    picker.cameraDevice = self.cameraType == .front ? .front : .rear
                    picker.allowsEditing = isEdit
                    picker.isEditing = isEdit
                    vc.present(picker, animated: true, completion: nil)
                }
                self.complation = imageComplition
            }
            else {
                DispatchQueue.main.async{
                    vc.showAlert(string: "You don't have camera")
                }
               
            }
        }) {
            DispatchQueue.main.async{
                vc.showAlertWithOkAndCancelHandler(string: "In order to upload transaction picture MovieApp needs to access your Camera.Please go to settings and allow Camera access", strOk: "Settings", strCancel: "Cancel", handler: { (isSettings) in
                    if isSettings{
                        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: { (_ ) in
                            
                        })
                    }
                })
            }
        }
    }
    
    func openPhotoLibrary(_ vc : UIViewController,isEdit : Bool,_ imageComplition : @escaping imageComplition){
        self.checkPhotoLibraryPermission(authorizedRequested: {
            if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)) {
                DispatchQueue.main.async {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.sourceType = UIImagePickerController.SourceType.photoLibrary
                    picker.allowsEditing = isEdit
                    picker.isEditing = isEdit
                    
                    vc.present(picker, animated: true, completion: nil)
                    self.complation = imageComplition
                }
                
            }else{
                //no photoLibrary
                DispatchQueue.main.async{
                    vc.showAlert(string: "You don't have photoLibrary")
                }
            }
        }) {
            //deniedRequested
            DispatchQueue.main.async{
                vc.showAlertWithOkAndCancelHandler(string: "In order to upload transaction picture MovieApp needs to access your Photo Library.Please go to settings and allow Photo Library access", strOk: "Settings", strCancel: "Cancel", handler: { (isSettings) in
                    if isSettings{
                        DispatchQueue.main.async{
                            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: { (_ ) in
                                
                            })
                        }
                    }
                })
            }
        }
        
    }
    
    func checkPermissionForCamera(authorizedRequested : @escaping () -> Swift.Void,deniedRequested : @escaping () -> Swift.Void) -> Void {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            DispatchQueue.main.async{
                authorizedRequested()
            }
        }
        else if AVCaptureDevice.authorizationStatus(for: .video) ==  .denied || AVCaptureDevice.authorizationStatus(for: .video) ==  .restricted {
            //restricted
            DispatchQueue.main.async{
                deniedRequested()
            }
        }else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    DispatchQueue.main.async{
                        authorizedRequested()
                    }
                } else {
                    DispatchQueue.main.async{
                        deniedRequested()
                    }
                }
            })
        }
    }
    
    private func checkPhotoLibraryPermission(authorizedRequested : @escaping () -> Swift.Void,deniedRequested : @escaping () -> Swift.Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //handle authorized status
            DispatchQueue.main.async{
                authorizedRequested()
            }
            break
        case .denied, .restricted :
            //handle denied status
            DispatchQueue.main.async{
                deniedRequested()
            }
            break
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    // as above
                    DispatchQueue.main.async{
                        authorizedRequested()
                    }
                    break
                case .denied, .restricted:
                    DispatchQueue.main.async{
                        deniedRequested()
                    }
                    break
                case .notDetermined:
                    // won't happen but still
                    break
                 default:
                    break;
                }
            }
            break
         default:
            break;
        }
    }
    
    
    
}

extension CameraAndGalleryPermisson : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker .dismiss(animated: true, completion: nil)
        var image : UIImage?
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            image = img
        }else if let originalImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            image = originalImg
        }else{
            image = nil
        }
        var strImageName = ""
        if (info[.imageURL] as? NSURL) != nil {
            let imageUrl          = info[.imageURL] as! NSURL
            let imageName :String! = imageUrl.pathExtension
            strImageName = "\(Int(Date().timeIntervalSince1970))."
            strImageName = strImageName.appending(imageName)
        }else{
            strImageName = "\(Int(Date().timeIntervalSince1970)).png"
        }
        guard image != nil else {
            DispatchQueue.main.async{
                self.complation(nil,nil,"enable to get image" as? Error)
            }
            return
        }
        DispatchQueue.main.async{
            self.complation(image,strImageName,nil)
        }
    }
   
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker .dismiss(animated: true, completion: nil)
        DispatchQueue.main.async{
            self.complation(nil,nil,nil)
        }
    }
}

