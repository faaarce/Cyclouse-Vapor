//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 23/07/25.
//

import Vapor
import Fluent

struct UpdateProductImageURLes: AsyncMigration {
    func prepare(on database: Database) async throws {
        // Define the new image URLs for each product
        let productImageUpdates: [(productId: String, imageUrls: [String])] = [
          // Full Bikes
                 ("FB001", Array(repeating: "https://i.imgur.com/PGdOUkZ.jpeg", count: 5)),
                 ("FB002", Array(repeating: "https://i.imgur.com/AC3e5X0.jpeg", count: 5)),
                 ("FB003", Array(repeating: "https://i.imgur.com/YpWHDgc.jpeg", count: 5)),
                 ("FB004", Array(repeating: "https://i.imgur.com/h2baEk5.jpeg", count: 5)),
                 ("FB005", Array(repeating: "https://i.imgur.com/flfx0Bt.jpeg", count: 5)),
                 ("FB006", Array(repeating: "https://i.imgur.com/HpRaHJL.jpeg", count: 5)),
                 ("FB007", Array(repeating: "https://i.imgur.com/UL8zzYS.jpeg", count: 5)),
                 ("FB008", Array(repeating: "https://i.imgur.com/Xhb9Ce9.jpeg", count: 5)),
                 ("FB009", Array(repeating: "https://i.imgur.com/ewgPzQh.jpeg", count: 5)),
                 ("FB010", Array(repeating: "https://i.imgur.com/iBDRoyM.jpeg", count: 5)),
                 
                 // Handlebars
                 ("HB001", Array(repeating: "https://i.imgur.com/0y5rNGb.jpeg", count: 5)),
                 ("HB002", Array(repeating: "https://i.imgur.com/4ZzMuwv.jpeg", count: 5)),
                 ("HB003", Array(repeating: "https://i.imgur.com/Cfj9eut.jpeg", count: 5)),
                 ("HB004", Array(repeating: "https://i.imgur.com/p7UaXb4.jpeg", count: 5)),
                 ("HB005", Array(repeating: "https://i.imgur.com/MnsntUZ.png", count: 5)),
                 ("HB006", Array(repeating: "https://i.imgur.com/tTPwtv3.jpeg", count: 5)),
                 ("HB007", Array(repeating: "https://i.imgur.com/xkZvZWW.jpeg", count: 5)),
                 
                 // Saddles
                 ("SD001", Array(repeating: "https://i.imgur.com/I1VkV50.png", count: 5)),
                 ("SD002", Array(repeating: "https://i.imgur.com/UvlSItW.png", count: 5)),
                 ("SD003", Array(repeating: "https://i.imgur.com/vdKwwvY.png", count: 5)),
                 ("SD004", Array(repeating: "https://i.imgur.com/aUfBcdc.jpeg", count: 5)),
                 ("SD005", Array(repeating: "https://i.imgur.com/94uVJbK.jpeg", count: 5)),
                 ("SD006", Array(repeating: "https://i.imgur.com/PJFsFLd.jpeg", count: 5)),
                 ("SD007", Array(repeating: "https://i.imgur.com/9vDG2a5.jpeg", count: 5)),
                 
                 // Pedals
                 ("PD001", Array(repeating: "https://i.imgur.com/bmDiUer.jpeg", count: 5)),
                 ("PD002", Array(repeating: "https://i.imgur.com/NaRCs5m.jpeg", count: 5)),
                 ("PD003", Array(repeating: "https://i.imgur.com/QnOjBg5.jpeg", count: 5)),
                 ("PD004", Array(repeating: "https://i.imgur.com/eYevhYK.jpeg", count: 5)),
                 ("PD005", Array(repeating: "https://i.imgur.com/vKcWgYc.jpeg", count: 5)),
                 ("PD006", Array(repeating: "https://i.imgur.com/4LwQ7TG.png", count: 5)),
                 
                 // Seatposts
                 ("SP001", Array(repeating: "https://i.imgur.com/DZBw1ej.jpeg", count: 5)),
                 ("SP002", Array(repeating: "https://i.imgur.com/OiVAZbC.jpeg", count: 5)),
                 ("SP003", Array(repeating: "https://i.imgur.com/LDkHuMP.jpeg", count: 5)),
                 ("SP004", Array(repeating: "https://i.imgur.com/Stbol3r.png", count: 5)),
                 ("SP005", Array(repeating: "https://i.imgur.com/qKPCSu6.jpeg", count: 5)),
                 ("SP006", Array(repeating: "https://i.imgur.com/Rr7vzwJ.jpeg", count: 5)),
                 
                 // Stems
                 ("ST001", Array(repeating: "https://i.imgur.com/adfboov.jpeg", count: 5)),
                 
                 // Cranks
                 ("CR001", Array(repeating: "https://i.imgur.com/U3fyA1h.png", count: 5)),
                 
                 // Wheelsets
                 ("WS001", Array(repeating: "https://i.imgur.com/659Efkd.jpeg", count: 5)),
                 
                 // Frames
                 ("FR001", Array(repeating: "https://i.imgur.com/B6cCToB.png", count: 5)),
                 
                 // Tires
                 ("TR001", Array(repeating: "https://i.imgur.com/BZYQSbJ.png", count: 5)),
                 ("TR002", Array(repeating: "https://i.imgur.com/yNVPyjr.jpeg", count: 5))
        ]
        
        var updatedCount = 0
        var failedCount = 0
        
        for update in productImageUpdates {
            do {
                // Get existing images for this product
                let existingImages = try await ProductImage.query(on: database)
                    .filter(\.$product.$id == update.productId)
                    .sort(\.$displayOrder)
                    .all()
                
                // Update each image with new URL
                for (index, image) in existingImages.enumerated() {
                    if index < update.imageUrls.count {
                        image.imageUrl = update.imageUrls[index]
                        try await image.save(on: database)
                        updatedCount += 1
                    }
                }
            } catch {
                database.logger.error("Failed to update images for product \(update.productId): \(error)")
                failedCount += 1
            }
        }
        
        database.logger.info("""
            ✅ Product Image URL Update Complete
            - Updated: \(updatedCount) images
            - Failed: \(failedCount) products
            """)
    }
    
    func revert(on database: Database) async throws {
        // To revert, we'd need to store the old URLs somewhere
        // For now, we'll just log a warning
        database.logger.warning("""
            ⚠️ Image URL update cannot be automatically reverted.
            The original URLs were not preserved.
            """)
    }
}
