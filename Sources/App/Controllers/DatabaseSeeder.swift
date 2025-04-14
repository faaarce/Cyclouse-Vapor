//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Seeders/DatabaseSeeder.swift
import Vapor
import Fluent

struct DatabaseSeeder: AsyncMigration {
  func prepare(on database: Database) async throws {
    print("📝 Starting database seeding...")
    
    // Check if categories already exist to avoid duplicates
    let existingCategoryCount = try await ProductCategory.query(on: database).count()
    if existingCategoryCount == 0 {
      // Create product categories
      let categories = [
        ProductCategory(id: "FB", name: "Full Bike"),
        ProductCategory(id: "SD", name: "Saddle"),
        ProductCategory(id: "HB", name: "Handlebar"),
        ProductCategory(id: "PD", name: "Pedal"),
        ProductCategory(id: "SP", name: "Seatpost"),
        ProductCategory(id: "ST", name: "Stem"),
        ProductCategory(id: "CR", name: "Crank"),
        ProductCategory(id: "WS", name: "Wheelset"),
        ProductCategory(id: "FR", name: "Frame"),
        ProductCategory(id: "TR", name: "Tires")
      ]
      
      for category in categories {
        try await category.save(on: database)
      }
      print("✅ Categories created: \(categories.count)")
    } else {
      print("ℹ️ Categories already exist, skipping creation")
    }
    
    // Get existing products to avoid duplicates
    let existingProducts = try await Product.query(on: database).all()
    let existingProductIds = Set(existingProducts.compactMap { $0.id })
    print("ℹ️ Found \(existingProductIds.count) existing products")
    
    // Helper function to seed products and their images by category
    func seedProducts(_ products: [Product], category: String) async throws {
      print("📝 Seeding \(category) products...")
      
      var created = 0
      var skipped = 0
      
      for product in products {
        // Skip if already exists
        guard let id = product.id, !existingProductIds.contains(id) else {
          skipped += 1
          continue
        }
        
        // Save the product
        try await product.save(on: database)
        created += 1
        
        // Get appropriate image URL
        let imageUrl = getImageUrlForCategory(product.$category.id)
        
        // Create 5 images for this product immediately
        for i in 0..<5 {
          let image = ProductImage(
            productId: product.id!,
            imageUrl: imageUrl,
            displayOrder: i
          )
          try await image.save(on: database)
        }
        
        // Add a small delay to prevent database overload
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms
      }
      
      print("✅ \(category): Created \(created) products, skipped \(skipped) existing products")
    }
    
    // Define product data (your existing definitions)
    let fullBikes = [Product(
      id: "FB001",
      categoryId: "FB",
      name: "Fixie Bike",
      description: "Sleek and minimalist fixed-gear bike for urban riding.",
      brand: "Cinelli Histogram",
      price: 11999850,
      quantity: 30
    ),
                     Product(
                      id: "FB002",
                      categoryId: "FB",
                      name: "Mountain Bike",
                      description: "Full-suspension mountain bike for all terrains.",
                      brand: "Trek",
                      price: 22499850,
                      quantity: 30
                     ),
                     Product(
                      id: "FB003",
                      categoryId: "FB",
                      name: "Road Bike",
                      description: "Lightweight road bike built for speed and endurance.",
                      brand: "Canyon",
                      price: 28499850,
                      quantity: 30
                     ),
                     Product(
                      id: "FB004",
                      categoryId: "FB",
                      name: "Gravel Bike",
                      description: "Versatile bike designed for both road and light off-road riding.",
                      brand: "Specialized",
                      price: 25999850,
                      quantity: 25
                     ),
                     Product(
                      id: "FB005",
                      categoryId: "FB",
                      name: "BMX Bike",
                      description: "Sturdy bike built for tricks and street riding.",
                      brand: "GT Bikes",
                      price: 8999850,
                      quantity: 20
                     ),
                     Product(
                      id: "FB006",
                      categoryId: "FB",
                      name: "Touring Bike",
                      description: "Long-distance bike designed for comfort and cargo capacity.",
                      brand: "Surly",
                      price: 19999850,
                      quantity: 15
                     ),
                     Product(
                      id: "FB007",
                      categoryId: "FB",
                      name: "Track Bike",
                      description: "High-performance bike designed for velodrome racing.",
                      brand: "Felt",
                      price: 31999850,
                      quantity: 10
                     ),
                     Product(
                      id: "FB008",
                      categoryId: "FB",
                      name: "City Bike",
                      description: "Comfortable bike with upright riding position for urban commuting.",
                      brand: "Giant",
                      price: 15999850,
                      quantity: 35
                     ),
                     Product(
                      id: "FB009",
                      categoryId: "FB",
                      name: "Cyclocross Bike",
                      description: "Race-oriented bike designed for mixed-terrain cycling.",
                      brand: "Cannondale",
                      price: 27999850,
                      quantity: 18
                     ),
                     Product(
                      id: "FB010",
                      categoryId: "FB",
                      name: "Electric Bike",
                      description: "Pedal-assist bike for effortless urban commuting.",
                      brand: "Rad Power",
                      price: 35999850,
                      quantity: 22
                     )]
    let handlebars = [Product(
      id: "HB001",
      categoryId: "HB",
      name: "Bullhorn Handlebar",
      description: "Aerodynamic handlebar popular for fixie bikes.",
      brand: "Cinelli",
      price: 824850,
      quantity: 30
    ),
                      Product(
                        id: "HB002",
                        categoryId: "HB",
                        name: "Flat Handlebar",
                        description: "Flat bar for precision handling and control.",
                        brand: "RaceFace",
                        price: 689850,
                        quantity: 30
                      ),
                      Product(
                        id: "HB003",
                        categoryId: "HB",
                        name: "Carbon Drop Bar",
                        description: "Professional-grade carbon fiber drop bar offering superior vibration dampening and aerodynamic positioning for road cycling excellence.",
                        brand: "ENVE",
                        price: 2499850,
                        quantity: 15
                      ),
                      Product(
                        id: "HB004",
                        categoryId: "HB",
                        name: "Pursuit Bar Pro",
                        description: "Track-specific pursuit handlebar with aggressive geometry, perfect for velodrome racing and time trials with optimized aerodynamic profile.",
                        brand: "Deda Elementi",
                        price: 1299850,
                        quantity: 20
                      ),
                      Product(
                        id: "HB005",
                        categoryId: "HB",
                        name: "Riser Bar Elite",
                        description: "Wide mountain bike handlebar with 35mm rise, providing enhanced control and leverage for technical trail riding and downhill sections.",
                        brand: "Renthal",
                        price: 949850,
                        quantity: 25
                      ),
                      Product(
                        id: "HB006",
                        categoryId: "HB",
                        name: "Gravel Adventure Bar",
                        description: "Specialized flared drop bar designed for gravel riding, featuring wider drops for enhanced stability and multiple hand positions during long adventures.",
                        brand: "Salsa",
                        price: 1099850,
                        quantity: 20
                      ),
                      Product(
                        id: "HB007",
                        categoryId: "HB",
                        name: "Compact Drop Bar",
                        description: "Ergonomic aluminum drop bar with shorter reach and shallow drops, ideal for riders seeking comfort without sacrificing performance.",
                        brand: "Zipp",
                        price: 799850,
                        quantity: 30
                      )]
    
    let saddles = [
      Product(
        id: "SD001",
        categoryId: "SD",
        name: "Comfort Saddle",
        description: "Padded seat for long-distance comfort.",
        brand: "Brooks",
        price: 599850,
        quantity: 30
      ),
      Product(
        id: "SD002",
        categoryId: "SD",
        name: "Racing Saddle",
        description: "Lightweight saddle optimized for speed.",
        brand: "Fizik",
        price: 1199850,
        quantity: 30
      ),
      Product(
        id: "SD003",
        categoryId: "SD",
        name: "Carbon Pro Saddle",
        description: "Professional-grade carbon fiber saddle for competitive cycling.",
        brand: "Selle Italia",
        price: 1899850,
        quantity: 20
      ),
      Product(
        id: "SD004",
        categoryId: "SD",
        name: "Women's Ergonomic Saddle",
        description: "Anatomically designed saddle specifically for female cyclists.",
        brand: "Terry",
        price: 899850,
        quantity: 25
      ),
      Product(
        id: "SD005",
        categoryId: "SD",
        name: "Touring Saddle Pro",
        description: "Extra-wide comfort saddle with gel padding for long tours.",
        brand: "Selle Royal",
        price: 749850,
        quantity: 30
      ),
      Product(
        id: "SD006",
        categoryId: "SD",
        name: "Track Racing Saddle",
        description: "Minimalist design for velodrome and track racing.",
        brand: "Prologo",
        price: 1299850,
        quantity: 15
      ),
      Product(
        id: "SD007",
        categoryId: "SD",
        name: "MTB All-Terrain Saddle",
        description: "Durable saddle designed for rough mountain bike trails.",
        brand: "WTB",
        price: 849850,
        quantity: 25
      )
    ]
    
    
    // --- PEDALS ---
    let pedals = [
      Product(
        id: "PD001",
        categoryId: "PD",
        name: "RX-1",
        description: "Wide, flat pedals for casual riding and fixies.",
        brand: "Mks",
        price: 449850,
        quantity: 30
      ),
      Product(
        id: "PD002",
        categoryId: "PD",
        name: "Clipless Road Pedal",
        description: "Professional road cycling pedals with precise engagement mechanism.",
        brand: "Shimano",
        price: 1249850,
        quantity: 25
      ),
      Product(
        id: "PD003",
        categoryId: "PD",
        name: "MTB SPD Pedal",
        description: "Dual-sided mountain bike pedals with reliable mud-shedding design.",
        brand: "Crank Brothers",
        price: 899850,
        quantity: 20
      ),
      Product(
        id: "PD004",
        categoryId: "PD",
        name: "Track Racing Pedal",
        description: "Lightweight pedals with integrated toe clips for track cycling.",
        brand: "Look",
        price: 749850,
        quantity: 15
      ),
      Product(
        id: "PD005",
        categoryId: "PD",
        name: "Platform Pedal Pro",
        description: "Premium flat pedals with replaceable pins for maximum grip.",
        brand: "Race Face",
        price: 599850,
        quantity: 30
      ),
      Product(
        id: "PD006",
        categoryId: "PD",
        name: "Touring Combo Pedal",
        description: "Versatile pedal with platform on one side and SPD on the other.",
        brand: "Shimano",
        price: 849850,
        quantity: 25
      )
    ]
    
    // --- SEATPOSTS ---
    let seatposts = [
      Product(
        id: "SP001",
        categoryId: "SP",
        name: "Aluminum Seatpost",
        description: "Lightweight and durable seatpost for various bike types.",
        brand: "Thomson",
        price: 524850,
        quantity: 30
      ),
      Product(
        id: "SP002",
        categoryId: "SP",
        name: "Carbon Elite Seatpost",
        description: "Ultra-lightweight carbon fiber seatpost for racing bikes.",
        brand: "ENVE",
        price: 1299850,
        quantity: 20
      ),
      Product(
        id: "SP003",
        categoryId: "SP",
        name: "Dropper Seatpost",
        description: "Hydraulic dropper post for mountain bikes with remote lever.",
        brand: "RockShox",
        price: 1899850,
        quantity: 25
      ),
      Product(
        id: "SP004",
        categoryId: "SP",
        name: "Aero Carbon Seatpost",
        description: "Aerodynamically optimized seatpost for time trial bikes.",
        brand: "Profile Design",
        price: 1499850,
        quantity: 15
      ),
      Product(
        id: "SP005",
        categoryId: "SP",
        name: "Suspension Seatpost",
        description: "Comfort-focused seatpost with built-in suspension mechanism.",
        brand: "Cane Creek",
        price: 899850,
        quantity: 20
      ),
      Product(
        id: "SP006",
        categoryId: "SP",
        name: "Titanium Seatpost",
        description: "Premium titanium seatpost offering durability and light weight.",
        brand: "Moots",
        price: 1699850,
        quantity: 10
      )
    ]
    
    // --- STEMS ---
    let stems = [
      Product(
        id: "ST001",
        categoryId: "ST",
        name: "Adjustable Stem",
        description: "Versatile stem for fine-tuning handlebar position.",
        brand: "Ritchey",
        price: 749850,
        quantity: 30
      )
    ]
    
    // --- CRANKS ---
    let cranks = [
      Product(
        id: "CR001",
        categoryId: "CR",
        name: "Single Speed Crankset",
        description: "Simplified crankset for fixie and single speed bikes.",
        brand: "SRAM",
        price: 1349850,
        quantity: 30
      )
    ]
    
    // --- WHEELSETS ---
    let wheelsets = [
      Product(
        id: "WS001",
        categoryId: "WS",
        name: "Fixed Gear Wheelset",
        description: "Durable wheelset for fixed gear and single speed bikes.",
        brand: "H Plus Son",
        price: 2999850,
        quantity: 30
      )
    ]
    
    // --- FRAMES ---
    let frames = [
      Product(
        id: "FR001",
        categoryId: "FR",
        name: "Pias Agra",
        description: "Indonesian local famous frameset developed by sumvelo.",
        brand: "Surly",
        price: 4499850,
        quantity: 30
      )
    ]
    
    // --- TIRES ---
    let tires = [
      Product(
        id: "TR001",
        categoryId: "TR",
        name: "Urban Commuter Tire",
        description: "Durable tire with puncture protection for city riding.",
        brand: "Schwalbe",
        price: 599850,
        quantity: 30
      ),
      Product(
        id: "TR002",
        categoryId: "TR",
        name: "Mountain Bike Tire",
        description: "Durable tire designed for off-road cycling.",
        brand: "Maxxis",
        price: 449850,
        quantity: 30
      )
    ]
    
    // Seed each category independently
    try await seedProducts(fullBikes, category: "Full Bikes")
    try await seedProducts(handlebars, category: "Handlebars")
    try await seedProducts(saddles, category: "Saddles")
    try await seedProducts(pedals, category: "Pedals")
    try await seedProducts(seatposts, category: "Seatposts")
    try await seedProducts(stems, category: "Stems")
    try await seedProducts(cranks, category: "Cranks")
    try await seedProducts(wheelsets, category: "Wheelsets")
    try await seedProducts(frames, category: "Frames")
    try await seedProducts(tires, category: "Tires")
    
    print("✅ Database seeding completed successfully")
  }
  
  // Helper function to get appropriate image URL based on category
  private func getImageUrlForCategory(_ categoryId: String) -> String {
    switch categoryId {
    case "FB": return "https://i.imgur.com/DXv1ptr.jpeg" // Full Bike
    case "HB": return "https://i.imgur.com/DXv1ptr.jpeg" // Handlebar
    case "SD": return "https://i.imgur.com/DXv1ptr.jpeg" // Saddle
    case "PD": return "https://i.imgur.com/VbpNW4V.jpeg" // Pedal
    case "SP": return "https://i.imgur.com/Ur38Csn.png"  // Seatpost
    case "ST": return "https://i.imgur.com/adfboov.jpeg" // Stem
    case "CR": return "https://i.imgur.com/QGnNKW8.jpeg" // Crank
    case "WS": return "https://i.imgur.com/008fAHZ.png"  // Wheelset
    case "FR": return "https://i.imgur.com/dEvGyQ9.jpeg" // Frame
    case "TR": return "https://i.imgur.com/EYsAjpr.jpeg" // Tires
    default:   return "https://i.imgur.com/DXv1ptr.jpeg" // Default
    }
  }
  
  func revert(on database: Database) async throws {
    try await ProductImage.query(on: database).delete()
    try await Product.query(on: database).delete()
    try await ProductCategory.query(on: database).delete()
    print("✅ Database seeding reverted")
  }
}
