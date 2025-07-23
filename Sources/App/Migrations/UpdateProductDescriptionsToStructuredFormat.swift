//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/07/25.
//

import Vapor
import Fluent
import Foundation

// Corrected migration
struct UpdateProductDescriptionsToStructuredFormat: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        // Check if table exists by attempting to query it
        let tableExists = await checkTableExists(database: database)
        
        if !tableExists {
            try await database.schema(MigrationRollback.schema)
                .id()
                .field("product_id", .string, .required)
                .field("old_description", .string, .required)
                .field("migration_name", .string, .required)
                .field("created_at", .datetime)
                .create()
            
            database.logger.info("Created migration rollback table")
        }
        
        // Get all the product updates
        let productUpdates = Self.getAllProductUpdates()
        
        // Track statistics for logging
        var updatedCount = 0
        var skippedCount = 0
        
        // Process each product update
        for update in productUpdates {
            // Fetch the existing product
            guard let existingProduct = try await Product.find(update.id, on: database) else {
                database.logger.warning("Product \(update.id) not found - skipping")
                skippedCount += 1
                continue
            }
            
            // Skip if already updated
            if existingProduct.description == update.description {
                database.logger.info("Product \(update.id) already has updated description - skipping")
                skippedCount += 1
                continue
            }
            
            // Save rollback data before updating
            let rollbackRecord = MigrationRollback(
                productId: update.id,
                oldDescription: existingProduct.description,
                migrationName: String(describing: Self.self)
            )
            try await rollbackRecord.save(on: database)
            
            // Update the product description
            existingProduct.description = update.description
            try await existingProduct.save(on: database)
            
            updatedCount += 1
        }
        
        // Log the results
        database.logger.info("""
            ✅ Product Description Migration Complete
            - Updated: \(updatedCount) products
            - Skipped: \(skippedCount) products
            - Rollback data saved for all updates
            """)
    }
    
    func revert(on database: Database) async throws {
        // Check if rollback table exists
        let tableExists = await checkTableExists(database: database)
        
        guard tableExists else {
            database.logger.warning("Rollback table does not exist - cannot revert")
            return
        }
        
        // Fetch all rollback records for this migration
        let rollbackRecords = try await MigrationRollback.query(on: database)
            .filter(\.$migrationName == String(describing: Self.self))
            .all()
        
        var revertedCount = 0
        var failedCount = 0
        
        // Process each rollback record
        for record in rollbackRecords {
            // Find the product to revert
            guard let product = try await Product.find(record.productId, on: database) else {
                database.logger.warning("Product \(record.productId) not found during revert")
                failedCount += 1
                continue
            }
            
            // Restore the old description
            product.description = record.oldDescription
            try await product.save(on: database)
            
            // Delete the rollback record after successful revert
            try await record.delete(on: database)
            
            revertedCount += 1
        }
        
        // If the rollback table is empty, we can delete it
        let remainingRecords = try await MigrationRollback.query(on: database).count()
        if remainingRecords == 0 {
            try await database.schema(MigrationRollback.schema).delete()
        }
        
        database.logger.info("""
            ✅ Product Description Revert Complete
            - Reverted: \(revertedCount) products
            - Failed: \(failedCount) products
            """)
    }
    
    // Helper method to check if table exists
    private func checkTableExists(database: Database) async -> Bool {
        do {
            // Try to count records in the table
            // If the table doesn't exist, this will throw an error
            _ = try await MigrationRollback.query(on: database).count()
            return true
        } catch {
            // Table doesn't exist
            return false
        }
    }
    
    // Helper method to get all product updates
    static func getAllProductUpdates() -> [(id: String, description: String)] {
        return [
            // Full Bikes
          // Full Bikes
                   (id: "FB001", description: "Overview:\nAn iconic high-performance track bike designed for aggressive street riding and competitive criterium racing. Its race-proven geometry delivers sharp, responsive handling for the ultimate fixed-gear experience.\n\nKey Specifications:\n* Model Year: 2025\n* Origin: Designed in Italy, Manufactured in Taiwan\n* Material: Columbus Airplane Aluminum Alloy Frame"),
                   (id: "FB002", description: "Overview:\nA versatile full-suspension trail bike engineered for confident climbing and capable descending on any terrain. Its modern geometry and premium suspension provide the ultimate all-around mountain biking experience.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: Alpha Platinum Aluminum Frame"),
                   (id: "FB003", description: "Overview:\nA cutting-edge aero road bike that combines lightweight construction with wind-cheating performance. Engineered for competitive cyclists who demand speed without compromising comfort on long rides.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Germany, Manufactured in Germany\n* Material: Advanced Grade Carbon Fiber Frame"),
                   (id: "FB004", description: "Overview:\nAn adventure-ready gravel bike built to explore beyond the pavement. Its versatile design handles everything from smooth tarmac to rough forest trails, making it the perfect companion for endless exploration.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: FACT 10r Carbon Fiber Frame"),
                   (id: "FB005", description: "Overview:\nA bombproof freestyle BMX bike engineered for street riding, park sessions, and dirt jumping. Its reinforced construction and responsive geometry make it ideal for riders pushing the limits of what's possible.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: 100% Chromoly Steel Frame"),
                   (id: "FB006", description: "Overview:\nA robust expedition touring bike designed for self-supported adventures and long-distance journeys. Built to carry heavy loads while maintaining comfort and stability across thousands of miles.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: 4130 Chromoly Steel Frame"),
                   (id: "FB007", description: "Overview:\nA professional-grade track racing bike optimized for velodrome competition. Its ultra-stiff carbon construction and aggressive geometry deliver maximum power transfer for explosive sprints and sustained speed.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: TeXtreme High-Modulus Carbon Frame"),
                   (id: "FB008", description: "Overview:\nA practical urban commuter bike designed for daily transportation and casual rides. Its upright riding position, integrated accessories, and low-maintenance design make city cycling effortless and enjoyable.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Taiwan, Manufactured in Taiwan\n* Material: ALUXX Aluminum Alloy Frame"),
                   (id: "FB009", description: "Overview:\nA race-bred cyclocross bike built to dominate muddy courses and technical terrain. Its nimble handling and robust construction excel in the demanding conditions of competitive cross racing.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: BallisTec Hi-MOD Carbon Frame"),
                   (id: "FB010", description: "Overview:\nA powerful electric cargo bike designed to replace car trips and revolutionize urban transportation. Its high-capacity battery and robust motor make hauling kids, groceries, or gear effortless.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Vietnam\n* Material: 6061 Aluminum Frame with Integrated Battery"),
                   
                   // Handlebars
                   (id: "HB001", description: "Overview:\nA classic pursuit-style handlebar favored by urban fixed-gear riders and track cyclists. Its forward-reaching design provides an aggressive riding position while maintaining excellent control in traffic.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Italy, Manufactured in Italy\n* Material: 6061-T6 Aluminum Alloy"),
                   (id: "HB002", description: "Overview:\nA precision-engineered flat bar designed for mountain biking and aggressive trail riding. Its wide stance and subtle backsweep provide optimal control and leverage on technical terrain.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Canada, Manufactured in Canada\n* Material: 7050 Aluminum with Shot-Peened Finish"),
                   (id: "HB003", description: "Overview:\nA professional-grade carbon fiber drop bar offering superior vibration dampening and aerodynamic positioning for road cycling excellence. Its ergonomic shape reduces hand fatigue on long rides while maintaining racing performance.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: High-Modulus Carbon Fiber"),
                   (id: "HB004", description: "Overview:\nA track-specific pursuit handlebar with aggressive geometry, perfect for velodrome racing and time trials. Its wind-tunnel-tested profile minimizes drag while providing stable handling at high speeds.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Italy, Manufactured in Italy\n* Material: Scandium-Enhanced Aluminum Alloy"),
                   (id: "HB005", description: "Overview:\nA wide mountain bike handlebar with 35mm rise, providing enhanced control and leverage for technical trail riding and downhill sections. Its reinforced construction withstands the most demanding riding conditions.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in UK, Manufactured in UK\n* Material: 7-Series Aluminum with Hard Anodized Finish"),
                   (id: "HB006", description: "Overview:\nA specialized flared drop bar designed for gravel riding, featuring wider drops for enhanced stability and multiple hand positions during long adventures. Its unique shape provides comfort without sacrificing control.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: 6066-T6 Aluminum with Vibration-Damping Treatment"),
                   (id: "HB007", description: "Overview:\nAn ergonomic aluminum drop bar with shorter reach and shallow drops, ideal for riders seeking comfort without sacrificing performance. Its modern design suits both competitive and recreational road cycling.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: 7075 Aluminum with Service Course Finish"),
                   
                   // Saddles
                   (id: "SD001", description: "Overview:\nA heritage leather saddle crafted for long-distance comfort and timeless style. Its suspended design and natural materials provide unmatched comfort that improves with age and use.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in UK, Manufactured in UK\n* Material: Premium Leather with Steel Rails"),
                   (id: "SD002", description: "Overview:\nA lightweight racing saddle engineered for competitive cyclists who demand performance. Its pressure-relief channel and carbon-reinforced shell deliver comfort without compromising power transfer.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Italy, Manufactured in Italy\n* Material: Carbon-Reinforced Nylon Shell with K:ium Rails"),
                   (id: "SD003", description: "Overview:\nA professional-grade carbon fiber saddle designed for elite athletes and weight-conscious riders. Its advanced construction provides optimal support while maintaining an incredibly low weight.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Italy, Manufactured in Italy\n* Material: Full Carbon Monocoque Construction"),
                   (id: "SD004", description: "Overview:\nAn anatomically designed saddle specifically engineered for female cyclists. Its wider sit-bone support and strategic cutout provide superior comfort for women's unique anatomy.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Italy\n* Material: Flex-Tuned Nylon Base with Titanium Rails"),
                   (id: "SD005", description: "Overview:\nAn extra-wide comfort saddle with advanced gel padding system for ultra-long tours. Its shock-absorbing design and weatherproof construction ensure comfort across thousands of miles.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Italy, Manufactured in Italy\n* Material: Royalgel™ Padding with Elastomer Suspension"),
                   (id: "SD006", description: "Overview:\nA minimalist track-specific saddle optimized for velodrome racing and fixed-gear performance. Its narrow profile and firm padding support aggressive riding positions during high-intensity efforts.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Italy, Manufactured in Italy\n* Material: Microfiber Cover with Carbon Rails"),
                   (id: "SD007", description: "Overview:\nA durable mountain bike saddle engineered to withstand the rigors of aggressive trail riding. Its reinforced corners and weather-resistant materials excel in harsh off-road conditions.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: Abrasion-Resistant Microfiber with Chromoly Rails"),
                   
                   // Pedals
                   (id: "PD001", description: "Overview:\nClassic wide platform pedals favored by urban cyclists and fixed-gear enthusiasts. Their generous platform and sealed bearings provide reliable performance for daily riding and tricks.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Japan, Manufactured in Japan\n* Material: CNC-Machined Aluminum Body"),
                   (id: "PD002", description: "Overview:\nProfessional road cycling pedals featuring a wide platform and adjustable tension for optimal power transfer. Their lightweight design and precise engagement mechanism meet the demands of competitive cycling.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Japan, Manufactured in Malaysia\n* Material: Carbon Composite Body with Stainless Steel Plate"),
                   (id: "PD003", description: "Overview:\nDual-sided mountain bike pedals with an open design that sheds mud effortlessly. Their four-sided entry and adjustable release tension make them ideal for technical trail riding.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: Forged Chromoly Steel with Brass Cleats"),
                   (id: "PD004", description: "Overview:\nLightweight track-specific pedals with integrated toe clips designed for velodrome racing. Their aerodynamic profile and secure retention system maximize power transfer during explosive efforts.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in France, Manufactured in France\n* Material: Carbon Fiber Body with Titanium Spindle"),
                   (id: "PD005", description: "Overview:\nPremium flat pedals featuring a concave platform and replaceable traction pins for maximum grip. Their thin profile and sealed bearing system excel in demanding freeride and downhill conditions.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Canada, Manufactured in Canada\n* Material: 6061-T6 Aluminum with DU Bushing System"),
                   (id: "PD006", description: "Overview:\nVersatile dual-function pedals offering clipless efficiency on one side and platform convenience on the other. Perfect for touring cyclists who need flexibility in footwear choices.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Japan, Manufactured in Malaysia\n* Material: Aluminum Body with Sealed Bearing Mechanism"),
                   
                   // Seatposts
                   (id: "SP001", description: "Overview:\nA precision-machined aluminum seatpost renowned for its strength and reliability. Its two-bolt clamp design provides infinite angle adjustment while maintaining bombproof security.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: 7000-Series Aluminum with Hard Anodized Finish"),
                   (id: "SP002", description: "Overview:\nAn ultra-lightweight carbon fiber seatpost designed for weight-conscious racers. Its vibration-damping properties and aerodynamic profile enhance both comfort and performance.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: High-Modulus Unidirectional Carbon Fiber"),
                   (id: "SP003", description: "Overview:\nA hydraulic dropper post offering infinite height adjustment on the fly. Its smooth action and reliable performance transform the riding experience on technical terrain.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: 6061-T6 Aluminum with Sealed Hydraulic Cartridge"),
                   (id: "SP004", description: "Overview:\nAn aerodynamically optimized seatpost designed for time trial and triathlon competition. Its truncated airfoil shape reduces drag while maintaining UCI-legal dimensions.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: Wind-Tunnel Tested Carbon Composite"),
                   (id: "SP005", description: "Overview:\nA comfort-focused seatpost featuring an integrated parallelogram suspension system. Its 50mm of travel smooths out rough roads while maintaining efficient pedaling dynamics.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: Forged Aluminum with Elastomer Suspension"),
                   (id: "SP006", description: "Overview:\nA premium titanium seatpost offering the perfect balance of strength, weight, and ride quality. Its natural vibration-damping properties and lifetime durability justify the investment.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: 3Al-2.5V Titanium Alloy"),
                   
                   // Stems
                   (id: "ST001", description: "Overview:\nA versatile adjustable stem allowing riders to fine-tune their handlebar position for optimal comfort and performance. Its robust construction and tool-free adjustment make it ideal for bike fitting.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: 3D-Forged 6061 Aluminum"),
                   
                   // Cranks
                   (id: "CR001", description: "Overview:\nA clean and efficient single-speed crankset designed for urban riding and track cycling. Its stiff construction and narrow Q-factor deliver optimal power transfer for fixed-gear performance.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: Forged 7050 Aluminum with Hard Anodized Finish"),
                   
                   // Wheelsets
                   (id: "WS001", description: "Overview:\nA bombproof wheelset built specifically for the demands of fixed-gear and single-speed riding. Its deep-section rims provide aerodynamic advantage while maintaining the strength needed for urban assault.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: 6061-T6 Aluminum Rims with Sealed Bearing Hubs"),
                   
                   // Frames
                   (id: "FR001", description: "Overview:\nAn Indonesian cycling icon, the Pias Agra frameset represents the pinnacle of local frame building expertise. Developed by Sumvelo, it combines aggressive geometry with versatile mounting options for modern riding.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Indonesia, Manufactured in Indonesia\n* Material: Custom-Butted 4130 Chromoly Steel"),
                   
                   // Tires
                   (id: "TR001", description: "Overview:\nA puncture-resistant tire engineered for city streets and daily commuting. Its reflective sidewalls and reinforced casing provide safety and durability for year-round urban cycling.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Germany, Manufactured in Vietnam\n* Material: SmartGuard Puncture Protection Layer"),
                   (id: "TR002", description: "Overview:\nAn aggressive all-terrain tire designed to excel in diverse trail conditions. Its versatile tread pattern provides confident traction on everything from hardpack to loose terrain.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: Dual-Compound Rubber with EXO Protection"),
        ]
    }
}

// Alternative: Simpler approach without rollback table
struct UpdateProductDescriptionsSimple: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        let updates = Self.getAllProductUpdates()
        var updatedCount = 0
        var alreadyUpdatedCount = 0
        var notFoundCount = 0
        
        // Use database transaction for safety
        try await database.transaction { transaction in
            for update in updates {
                // Fetch the product first
                guard let product = try await Product.find(update.id, on: transaction) else {
                    notFoundCount += 1
                    transaction.logger.warning("Product \(update.id) not found")
                    continue
                }
                
                // Check if already updated
                if product.description == update.description {
                    alreadyUpdatedCount += 1
                    continue
                }
                
                // Update the product
                product.description = update.description
                try await product.save(on: transaction)
                updatedCount += 1
            }
        }
        
        database.logger.info("""
            ✅ Product Description Update Complete
            - Updated: \(updatedCount) products
            - Already updated: \(alreadyUpdatedCount) products  
            - Not found: \(notFoundCount) products
            """)
    }
    
    func revert(on database: Database) async throws {
        database.logger.warning("""
            ⚠️ Cannot revert product descriptions - no rollback data available.
            To restore original descriptions, you'll need to:
            1. Restore from a database backup, or
            2. Run the original seeder with old descriptions
            """)
    }
    
    static func getAllProductUpdates() -> [(id: String, description: String)] {
        return [
            // Same product updates as above
          (
                     id: "FB001",
                     description: """
                     Overview:
                     An iconic high-performance track bike designed for aggressive street riding and competitive criterium racing. Its race-proven geometry delivers sharp, responsive handling for the ultimate fixed-gear experience.

                     Key Specifications:
                     * Model Year: 2025
                     * Origin: Designed in Italy, Manufactured in Taiwan
                     * Material: Columbus Airplane Aluminum Alloy Frame
                     """
                 ),
                 (
                     id: "FB002",
                     description: """
                     Overview:
                     A versatile full-suspension trail bike engineered for confident climbing and capable descending on any terrain. Its modern geometry and premium suspension provide the ultimate all-around mountain biking experience.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in Taiwan
                     * Material: Alpha Platinum Aluminum Frame
                     """
                 ),
                 (
                     id: "FB003",
                     description: """
                     Overview:
                     A cutting-edge aero road bike that combines lightweight construction with wind-cheating performance. Engineered for competitive cyclists who demand speed without compromising comfort on long rides.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in Germany, Manufactured in Germany
                     * Material: Advanced Grade Carbon Fiber Frame
                     """
                 ),
                 (
                     id: "FB004",
                     description: """
                     Overview:
                     An adventure-ready gravel bike built to explore beyond the pavement. Its versatile design handles everything from smooth tarmac to rough forest trails, making it the perfect companion for endless exploration.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in Taiwan
                     * Material: FACT 10r Carbon Fiber Frame
                     """
                 ),
                 (
                     id: "FB005",
                     description: """
                     Overview:
                     A bombproof freestyle BMX bike engineered for street riding, park sessions, and dirt jumping. Its reinforced construction and responsive geometry make it ideal for riders pushing the limits of what's possible.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in Taiwan
                     * Material: 100% Chromoly Steel Frame
                     """
                 ),
                 (
                     id: "FB006",
                     description: """
                     Overview:
                     A robust expedition touring bike designed for self-supported adventures and long-distance journeys. Built to carry heavy loads while maintaining comfort and stability across thousands of miles.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in USA
                     * Material: 4130 Chromoly Steel Frame
                     """
                 ),
                 (
                     id: "FB007",
                     description: """
                     Overview:
                     A professional-grade track racing bike optimized for velodrome competition. Its ultra-stiff carbon construction and aggressive geometry deliver maximum power transfer for explosive sprints and sustained speed.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in USA
                     * Material: TeXtreme High-Modulus Carbon Frame
                     """
                 ),
                 (
                     id: "FB008",
                     description: """
                     Overview:
                     A practical urban commuter bike designed for daily transportation and casual rides. Its upright riding position, integrated accessories, and low-maintenance design make city cycling effortless and enjoyable.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in Taiwan, Manufactured in Taiwan
                     * Material: ALUXX Aluminum Alloy Frame
                     """
                 ),
                 (
                     id: "FB009",
                     description: """
                     Overview:
                     A race-bred cyclocross bike built to dominate muddy courses and technical terrain. Its nimble handling and robust construction excel in the demanding conditions of competitive cross racing.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in USA
                     * Material: BallisTec Hi-MOD Carbon Frame
                     """
                 ),
                 (
                     id: "FB010",
                     description: """
                     Overview:
                     A powerful electric cargo bike designed to replace car trips and revolutionize urban transportation. Its high-capacity battery and robust motor make hauling kids, groceries, or gear effortless.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in Vietnam
                     * Material: 6061 Aluminum Frame with Integrated Battery
                     """
                 ),

                 // Handlebars (7)
                 (
                     id: "HB001",
                     description: """
                     Overview:
                     A classic pursuit-style handlebar favored by urban fixed-gear riders and track cyclists. Its forward-reaching design provides an aggressive riding position while maintaining excellent control in traffic.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in Italy, Manufactured in Italy
                     * Material: 6061-T6 Aluminum Alloy
                     """
                 ),
                 (
                     id: "HB002",
                     description: """
                     Overview:
                     A precision-engineered flat bar designed for mountain biking and aggressive trail riding. Its wide stance and subtle backsweep provide optimal control and leverage on technical terrain.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in Canada, Manufactured in Canada
                     * Material: 7050 Aluminum with Shot-Peened Finish
                     """
                 ),
                 (
                     id: "HB003",
                     description: """
                     Overview:
                     A professional-grade carbon fiber drop bar offering superior vibration dampening and aerodynamic positioning for road cycling excellence. Its ergonomic shape reduces hand fatigue on long rides while maintaining racing performance.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in USA
                     * Material: High-Modulus Carbon Fiber
                     """
                 ),
                 (
                     id: "HB004",
                     description: """
                     Overview:
                     A track-specific pursuit handlebar with aggressive geometry, perfect for velodrome racing and time trials. Its wind-tunnel-tested profile minimizes drag while providing stable handling at high speeds.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in Italy, Manufactured in Italy
                     * Material: Scandium-Enhanced Aluminum Alloy
                     """
                 ),
                 (
                     id: "HB005",
                     description: """
                     Overview:
                     A wide mountain bike handlebar with 35mm rise, providing enhanced control and leverage for technical trail riding and downhill sections. Its reinforced construction withstands the most demanding riding conditions.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in UK, Manufactured in UK
                     * Material: 7-Series Aluminum with Hard Anodized Finish
                     """
                 ),
                 (
                     id: "HB006",
                     description: """
                     Overview:
                     A specialized flared drop bar designed for gravel riding, featuring wider drops for enhanced stability and multiple hand positions during long adventures. Its unique shape provides comfort without sacrificing control.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in Taiwan
                     * Material: 6066-T6 Aluminum with Vibration-Damping Treatment
                     """
                 ),
                 (
                     id: "HB007",
                     description: """
                     Overview:
                     An ergonomic aluminum drop bar with shorter reach and shallow drops, ideal for riders seeking comfort without sacrificing performance. Its modern design suits both competitive and recreational road cycling.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in USA
                     * Material: 7075 Aluminum with Service Course Finish
                     """
                 ),

                 // Saddles (7)
                 (
                     id: "SD001",
                     description: """
                     Overview:
                     A heritage leather saddle crafted for long-distance comfort and timeless style. Its suspended design and natural materials provide unmatched comfort that improves with age and use.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in UK, Manufactured in UK
                     * Material: Premium Leather with Steel Rails
                     """
                 ),
                 (
                     id: "SD002",
                     description: """
                     Overview:
                     A lightweight racing saddle engineered for competitive cyclists who demand performance. Its pressure-relief channel and carbon-reinforced shell deliver comfort without compromising power transfer.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in Italy, Manufactured in Italy
                     * Material: Carbon-Reinforced Nylon Shell with K:ium Rails
                     """
                 ),
                 (
                     id: "SD003",
                     description: """
                     Overview:
                     A professional-grade carbon fiber saddle designed for elite athletes and weight-conscious riders. Its advanced construction provides optimal support while maintaining an incredibly low weight.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in Italy, Manufactured in Italy
                     * Material: Full Carbon Monocoque Construction
                     """
                 ),
                 (
                     id: "SD004",
                     description: """
                     Overview:
                     An anatomically designed saddle specifically engineered for female cyclists. Its wider sit-bone support and strategic cutout provide superior comfort for women's unique anatomy.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in Italy
                     * Material: Flex-Tuned Nylon Base with Titanium Rails
                     """
                 ),
                 (
                     id: "SD005",
                     description: """
                     Overview:
                     An extra-wide comfort saddle with advanced gel padding system for ultra-long tours. Its shock-absorbing design and weatherproof construction ensure comfort across thousands of miles.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in Italy, Manufactured in Italy
                     * Material: Royalgel™ Padding with Elastomer Suspension
                     """
                 ),
                 (
                     id: "SD006",
                     description: """
                     Overview:
                     A minimalist track-specific saddle optimized for velodrome racing and fixed-gear performance. Its narrow profile and firm padding support aggressive riding positions during high-intensity efforts.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in Italy, Manufactured in Italy
                     * Material: Microfiber Cover with Carbon Rails
                     """
                 ),
                 (
                     id: "SD007",
                     description: """
                     Overview:
                     A durable mountain bike saddle engineered to withstand the rigors of aggressive trail riding. Its reinforced corners and weather-resistant materials excel in harsh off-road conditions.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in USA
                     * Material: Abrasion-Resistant Microfiber with Chromoly Rails
                     """
                 ),

                 // Pedals (6)
                 (
                     id: "PD001",
                     description: """
                     Overview:
                     Classic wide platform pedals favored by urban cyclists and fixed-gear enthusiasts. Their generous platform and sealed bearings provide reliable performance for daily riding and tricks.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in Japan, Manufactured in Japan
                     * Material: CNC-Machined Aluminum Body
                     """
                 ),
                 (
                     id: "PD002",
                     description: """
                     Overview:
                     Professional road cycling pedals featuring a wide platform and adjustable tension for optimal power transfer. Their lightweight design and precise engagement mechanism meet the demands of competitive cycling.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in Japan, Manufactured in Malaysia
                     * Material: Carbon Composite Body with Stainless Steel Plate
                     """
                 ),
                 (
                     id: "PD003",
                     description: """
                     Overview:
                     Dual-sided mountain bike pedals with an open design that sheds mud effortlessly. Their four-sided entry and adjustable release tension make them ideal for technical trail riding.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in Taiwan
                     * Material: Forged Chromoly Steel with Brass Cleats
                     """
                 ),
                 (
                     id: "PD004",
                     description: """
                     Overview:
                     Lightweight track-specific pedals with integrated toe clips designed for velodrome racing. Their aerodynamic profile and secure retention system maximize power transfer during explosive efforts.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in France, Manufactured in France
                     * Material: Carbon Fiber Body with Titanium Spindle
                     """
                 ),
                 (
                     id: "PD005",
                     description: """
                     Overview:
                     Premium flat pedals featuring a concave platform and replaceable traction pins for maximum grip. Their thin profile and sealed bearing system excel in demanding freeride and downhill conditions.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in Canada, Manufactured in Canada
                     * Material: 6061-T6 Aluminum with DU Bushing System
                     """
                 ),
                 (
                     id: "PD006",
                     description: """
                     Overview:
                     Versatile dual-function pedals offering clipless efficiency on one side and platform convenience on the other. Perfect for touring cyclists who need flexibility in footwear choices.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in Japan, Manufactured in Malaysia
                     * Material: Aluminum Body with Sealed Bearing Mechanism
                     """
                 ),

                 // Seatposts (6)
                 (
                     id: "SP001",
                     description: """
                     Overview:
                     A precision-machined aluminum seatpost renowned for its strength and reliability. Its two-bolt clamp design provides infinite angle adjustment while maintaining bombproof security.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in USA
                     * Material: 7000-Series Aluminum with Hard Anodized Finish
                     """
                 ),
                 (
                     id: "SP002",
                     description: """
                     Overview:
                     An ultra-lightweight carbon fiber seatpost designed for weight-conscious racers. Its vibration-damping properties and aerodynamic profile enhance both comfort and performance.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in USA
                     * Material: High-Modulus Unidirectional Carbon Fiber
                     """
                 ),
                 (
                     id: "SP003",
                     description: """
                     Overview:
                     A hydraulic dropper post offering infinite height adjustment on the fly. Its smooth action and reliable performance transform the riding experience on technical terrain.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in Taiwan
                     * Material: 6061-T6 Aluminum with Sealed Hydraulic Cartridge
                     """
                 ),
                 (
                     id: "SP004",
                     description: """
                     Overview:
                     An aerodynamically optimized seatpost designed for time trial and triathlon competition. Its truncated airfoil shape reduces drag while maintaining UCI-legal dimensions.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in Taiwan
                     * Material: Wind-Tunnel Tested Carbon Composite
                     """
                 ),
                 (
                     id: "SP005",
                     description: """
                     Overview:
                     A comfort-focused seatpost featuring an integrated parallelogram suspension system. Its 50mm of travel smooths out rough roads while maintaining efficient pedaling dynamics.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in USA
                     * Material: Forged Aluminum with Elastomer Suspension
                     """
                 ),
                 (
                     id: "SP006",
                     description: """
                     Overview:
                     A premium titanium seatpost offering the perfect balance of strength, weight, and ride quality. Its natural vibration-damping properties and lifetime durability justify the investment.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in USA
                     * Material: 3Al-2.5V Titanium Alloy
                     """
                 ),

                 // Stems (1)
                 (
                     id: "ST001",
                     description: """
                     Overview:
                     A versatile adjustable stem allowing riders to fine-tune their handlebar position for optimal comfort and performance. Its robust construction and tool-free adjustment make it ideal for bike fitting.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in Taiwan
                     * Material: 3D-Forged 6061 Aluminum
                     """
                 ),

                 // Cranks (1)
                 (
                     id: "CR001",
                     description: """
                     Overview:
                     A clean and efficient single-speed crankset designed for urban riding and track cycling. Its stiff construction and narrow Q-factor deliver optimal power transfer for fixed-gear performance.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in Taiwan
                     * Material: Forged 7050 Aluminum with Hard Anodized Finish
                     """
                 ),

                 // Wheelsets (1)
                 (
                     id: "WS001",
                     description: """
                     Overview:
                     A bombproof wheelset built specifically for the demands of fixed-gear and single-speed riding. Its deep-section rims provide aerodynamic advantage while maintaining the strength needed for urban assault.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in Taiwan
                     * Material: 6061-T6 Aluminum Rims with Sealed Bearing Hubs
                     """
                 ),

                 // Frames (1)
                 (
                     id: "FR001",
                     description: """
                     Overview:
                     An Indonesian cycling icon, the Pias Agra frameset represents the pinnacle of local frame building expertise. Developed by Sumvelo, it combines aggressive geometry with versatile mounting options for modern riding.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in Indonesia, Manufactured in Indonesia
                     * Material: Custom-Butted 4130 Chromoly Steel
                     """
                 ),

                 // Tires (2)
                 (
                     id: "TR001",
                     description: """
                     Overview:
                     A puncture-resistant tire engineered for city streets and daily commuting. Its reflective sidewalls and reinforced casing provide safety and durability for year-round urban cycling.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in Germany, Manufactured in Vietnam
                     * Material: SmartGuard Puncture Protection Layer
                     """
                 ),
                 (
                     id: "TR002",
                     description: """
                     Overview:
                     An aggressive all-terrain tire designed to excel in diverse trail conditions. Its versatile tread pattern provides confident traction on everything from hardpack to loose terrain.

                     Key Specifications:
                     * Model Year: 2024
                     * Origin: Designed in USA, Manufactured in Taiwan
                     * Material: Dual-Compound Rubber with EXO Protection
                     """
                 )
        ]
    }
}

// Even simpler version using just query updates
struct UpdateProductDescriptionsMinimal: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        let updates = Self.getAllProductUpdates()
        
        for update in updates {
            // Direct database update - most efficient but no rollback
            try await Product.query(on: database)
                .filter(\.$id == update.id)
                .set(\.$description, to: update.description)
                .update()
        }
        
        database.logger.info("✅ Bulk product description update completed")
    }
    
    func revert(on database: Database) async throws {
        database.logger.warning("⚠️ This migration cannot be reverted automatically")
    }
    
    static func getAllProductUpdates() -> [(id: String, description: String)] {
        // Same as above
        return []
    }
}

