//
//  imageConverterTest.swift
//  teste 3
//
//  Created by AMANDA CAROLINE DA SILVA RODRIGUES on 03/02/25.
//

import Foundation
import UIKit
import CoreData

class ImageViewModel: ObservableObject {
    
    @Published var images: [UIImage] = []
    
    private let context = PersistenceController.persistencia.container.viewContext
    
    func saveImage(image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Erro ao encontrar o Document Directory")
            return
        }
        
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            do {
                try imageData.write(to: fileURL)
                let newImageEntity = ImageEntity(context: context)
                newImageEntity.imagePath = fileURL.path
                
                try context.save()
                
                print("imagem salva")
                
            } catch {
                print("erro ao salvar imagem ou o caminho: \(error)")
            }
        }
    }

    func loadImage() -> UIImage? {
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        
        do {
            let imageEntities = try context.fetch(fetchRequest)
            
            self.images = imageEntities.compactMap({ entity in
                guard let imagePath = entity.imagePath else { return nil }
                let fileURL = URL(fileURLWithPath: imagePath)
                return UIImage(contentsOfFile: fileURL.path)
            })
            
            print("imagens carregadas: \(self.images.count)")
        } catch {
            print("erro ao carregar imagem: \(error)")
        }
        
        return nil
    }



}

