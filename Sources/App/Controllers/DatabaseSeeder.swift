//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Seeders/DatabaseSeeder.swift
import Vapor
import Fluent
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
    
    // Define product-specific image mappings
       let productImageMap: [String: [String]] = [
        // Full Bikes
        "FB001": [
          "https://i.imgur.com/PGdOUkZ.jpeg",
          "https://i.imgur.com/PGdOUkZ.jpeg",
          "https://i.imgur.com/PGdOUkZ.jpeg",
          "https://i.imgur.com/PGdOUkZ.jpeg",
          "https://i.imgur.com/PGdOUkZ.jpeg"
        ],
        "FB002": [
          "https://i.imgur.com/AC3e5X0.jpeg",
          "https://i.imgur.com/AC3e5X0.jpeg",
          "https://i.imgur.com/AC3e5X0.jpeg",
          "https://i.imgur.com/AC3e5X0.jpeg",
          "https://i.imgur.com/AC3e5X0.jpeg"
        ],
        "FB003": [
          "https://i.imgur.com/YpWHDgc.jpeg",
          "https://i.imgur.com/YpWHDgc.jpeg",
          "https://i.imgur.com/YpWHDgc.jpeg",
          "https://i.imgur.com/YpWHDgc.jpeg",
          "https://i.imgur.com/YpWHDgc.jpeg"
        ],
        "FB004": [
          "https://i.imgur.com/h2baEk5.jpeg",
          "https://i.imgur.com/h2baEk5.jpeg",
          "https://i.imgur.com/h2baEk5.jpeg",
          "https://i.imgur.com/h2baEk5.jpeg",
          "https://i.imgur.com/h2baEk5.jpeg"
        ],
        "FB005": [
          "https://i.imgur.com/flfx0Bt.jpeg",
          "https://i.imgur.com/flfx0Bt.jpeg",
          "https://i.imgur.com/flfx0Bt.jpeg",
          "https://i.imgur.com/flfx0Bt.jpeg",
          "https://i.imgur.com/flfx0Bt.jpeg"
        ],
        "FB006": [
          "https://i.imgur.com/HpRaHJL.jpeg",
          "https://i.imgur.com/HpRaHJL.jpeg",
          "https://i.imgur.com/HpRaHJL.jpeg",
          "https://i.imgur.com/HpRaHJL.jpeg",
          "https://i.imgur.com/HpRaHJL.jpeg"
        ],
        "FB007": [
          "https://i.imgur.com/UL8zzYS.jpeg",
          "https://i.imgur.com/UL8zzYS.jpeg",
          "https://i.imgur.com/UL8zzYS.jpeg",
          "https://i.imgur.com/UL8zzYS.jpeg",
          "https://i.imgur.com/UL8zzYS.jpeg"
        ],
        "FB008": [
          "https://i.imgur.com/Xhb9Ce9.jpeg",
          "https://i.imgur.com/Xhb9Ce9.jpeg",
          "https://i.imgur.com/Xhb9Ce9.jpeg",
          "https://i.imgur.com/Xhb9Ce9.jpeg",
          "https://i.imgur.com/Xhb9Ce9.jpeg"
        ],
        "FB009": [
          "https://i.imgur.com/ewgPzQh.jpeg",
          "https://i.imgur.com/ewgPzQh.jpeg",
          "https://i.imgur.com/ewgPzQh.jpeg",
          "https://i.imgur.com/ewgPzQh.jpeg",
          "https://i.imgur.com/ewgPzQh.jpeg"
        ],
        "FB010": [
          "https://i.imgur.com/iBDRoyM.jpeg",
          "https://i.imgur.com/iBDRoyM.jpeg",
          "https://i.imgur.com/iBDRoyM.jpeg",
          "https://i.imgur.com/iBDRoyM.jpeg",
          "https://i.imgur.com/iBDRoyM.jpeg"
        ],
        
        // Handlebars
        "HB001": [
          "https://i.imgur.com/0y5rNGb.jpeg",
          "https://i.imgur.com/0y5rNGb.jpeg",
          "https://i.imgur.com/0y5rNGb.jpeg",
          "https://i.imgur.com/0y5rNGb.jpeg",
          "https://i.imgur.com/0y5rNGb.jpeg"
        ],
        "HB002": [
          "https://i.imgur.com/4ZzMuwv.jpeg",
          "https://i.imgur.com/4ZzMuwv.jpeg",
          "https://i.imgur.com/4ZzMuwv.jpeg",
          "https://i.imgur.com/4ZzMuwv.jpeg",
          "https://i.imgur.com/4ZzMuwv.jpeg"
        ],
        "HB003": [
          "https://i.imgur.com/Cfj9eut.jpeg",
          "https://i.imgur.com/Cfj9eut.jpeg",
          "https://i.imgur.com/Cfj9eut.jpeg",
          "https://i.imgur.com/Cfj9eut.jpeg",
          "https://i.imgur.com/Cfj9eut.jpeg"
        ],
        "HB004": [
          "https://i.imgur.com/p7UaXb4.jpeg",
          "https://i.imgur.com/p7UaXb4.jpeg",
          "https://i.imgur.com/p7UaXb4.jpeg",
          "https://i.imgur.com/p7UaXb4.jpeg",
          "https://i.imgur.com/p7UaXb4.jpeg"
        ],
        "HB005": [
          "https://i.imgur.com/MnsntUZ.png",
          "https://i.imgur.com/MnsntUZ.png",
          "https://i.imgur.com/MnsntUZ.png",
          "https://i.imgur.com/MnsntUZ.png",
          "https://i.imgur.com/MnsntUZ.png"
        ],
        "HB006": [
          "https://i.imgur.com/tTPwtv3.jpeg",
          "https://i.imgur.com/tTPwtv3.jpeg",
          "https://i.imgur.com/tTPwtv3.jpeg",
          "https://i.imgur.com/tTPwtv3.jpeg",
          "https://i.imgur.com/tTPwtv3.jpeg"
        ],
        "HB007": [
          "https://i.imgur.com/xkZvZWW.jpeg",
          "https://i.imgur.com/xkZvZWW.jpeg",
          "https://i.imgur.com/xkZvZWW.jpeg",
          "https://i.imgur.com/xkZvZWW.jpeg",
          "https://i.imgur.com/xkZvZWW.jpeg"
        ],
        
        // Saddles
        "SD001": [
          "https://i.imgur.com/I1VkV50.png",
          "https://i.imgur.com/I1VkV50.png",
          "https://i.imgur.com/I1VkV50.png",
          "https://i.imgur.com/I1VkV50.png",
          "https://i.imgur.com/I1VkV50.png"
        ],
        "SD002": [
          "https://i.imgur.com/UvlSItW.png",
          "https://i.imgur.com/UvlSItW.png",
          "https://i.imgur.com/UvlSItW.png",
          "https://i.imgur.com/UvlSItW.png",
          "https://i.imgur.com/UvlSItW.png"
        ],
        "SD003": [
          "https://i.imgur.com/vdKwwvY.png",
          "https://i.imgur.com/vdKwwvY.png",
          "https://i.imgur.com/vdKwwvY.png",
          "https://i.imgur.com/vdKwwvY.png",
          "https://i.imgur.com/vdKwwvY.png"
        ],
        "SD004": [
          "https://i.imgur.com/aUfBcdc.jpeg",
          "https://i.imgur.com/aUfBcdc.jpeg",
          "https://i.imgur.com/aUfBcdc.jpeg",
          "https://i.imgur.com/aUfBcdc.jpeg",
          "https://i.imgur.com/aUfBcdc.jpeg"
        ],
        "SD005": [
          "https://i.imgur.com/94uVJbK.jpeg",
          "https://i.imgur.com/94uVJbK.jpeg",
          "https://i.imgur.com/94uVJbK.jpeg",
          "https://i.imgur.com/94uVJbK.jpeg",
          "https://i.imgur.com/94uVJbK.jpeg"
        ],
        "SD006": [
          "https://i.imgur.com/PJFsFLd.jpeg",
          "https://i.imgur.com/PJFsFLd.jpeg",
          "https://i.imgur.com/PJFsFLd.jpeg",
          "https://i.imgur.com/PJFsFLd.jpeg",
          "https://i.imgur.com/PJFsFLd.jpeg"
        ],
        "SD007": [
          "https://i.imgur.com/9vDG2a5.jpeg",
          "https://i.imgur.com/9vDG2a5.jpeg",
          "https://i.imgur.com/9vDG2a5.jpeg",
          "https://i.imgur.com/9vDG2a5.jpeg",
          "https://i.imgur.com/9vDG2a5.jpeg"
        ],
        
        // Pedals
        "PD001": [
          "https://i.imgur.com/bmDiUer.jpeg",
          "https://i.imgur.com/bmDiUer.jpeg",
          "https://i.imgur.com/bmDiUer.jpeg",
          "https://i.imgur.com/bmDiUer.jpeg",
          "https://i.imgur.com/bmDiUer.jpeg"
        ],
        "PD002": [
          "https://i.imgur.com/NaRCs5m.jpeg",
          "https://i.imgur.com/NaRCs5m.jpeg",
          "https://i.imgur.com/NaRCs5m.jpeg",
          "https://i.imgur.com/NaRCs5m.jpeg",
          "https://i.imgur.com/NaRCs5m.jpeg"
        ],
        "PD003": [
          "https://i.imgur.com/QnOjBg5.jpeg",
          "https://i.imgur.com/QnOjBg5.jpeg",
          "https://i.imgur.com/QnOjBg5.jpeg",
          "https://i.imgur.com/QnOjBg5.jpeg",
          "https://i.imgur.com/QnOjBg5.jpeg"
        ],
        "PD004": [
          "https://i.imgur.com/eYevhYK.jpeg",
          "https://i.imgur.com/eYevhYK.jpeg",
          "https://i.imgur.com/eYevhYK.jpeg",
          "https://i.imgur.com/eYevhYK.jpeg",
          "https://i.imgur.com/eYevhYK.jpeg"
        ],
        "PD005": [
          "https://i.imgur.com/vKcWgYc.jpeg",
          "https://i.imgur.com/vKcWgYc.jpeg",
          "https://i.imgur.com/vKcWgYc.jpeg",
          "https://i.imgur.com/vKcWgYc.jpeg",
          "https://i.imgur.com/vKcWgYc.jpeg"
        ],
        "PD006": [
          "https://i.imgur.com/4LwQ7TG.png",
          "https://i.imgur.com/4LwQ7TG.png",
          "https://i.imgur.com/4LwQ7TG.png",
          "https://i.imgur.com/4LwQ7TG.png",
          "https://i.imgur.com/4LwQ7TG.png"
        ],
        
        // Seatposts
        "SP001": [
          "https://i.imgur.com/DZBw1ej.jpeg",
          "https://i.imgur.com/DZBw1ej.jpeg",
          "https://i.imgur.com/DZBw1ej.jpeg",
          "https://i.imgur.com/DZBw1ej.jpeg",
          "https://i.imgur.com/DZBw1ej.jpeg"
        ],
        "SP002": [
          "https://i.imgur.com/OiVAZbC.jpeg",
          "https://i.imgur.com/OiVAZbC.jpeg",
          "https://i.imgur.com/OiVAZbC.jpeg",
          "https://i.imgur.com/OiVAZbC.jpeg",
          "https://i.imgur.com/OiVAZbC.jpeg"
        ],
        "SP003": [
          "https://i.imgur.com/LDkHuMP.jpeg",
          "https://i.imgur.com/LDkHuMP.jpeg",
          "https://i.imgur.com/LDkHuMP.jpeg",
          "https://i.imgur.com/LDkHuMP.jpeg",
          "https://i.imgur.com/LDkHuMP.jpeg"
        ],
        "SP004": [
          "https://i.imgur.com/Stbol3r.png",
          "https://i.imgur.com/Stbol3r.png",
          "https://i.imgur.com/Stbol3r.png",
          "https://i.imgur.com/Stbol3r.png",
          "https://i.imgur.com/Stbol3r.png"
        ],
        "SP005": [
          "https://i.imgur.com/qKPCSu6.jpeg",
          "https://i.imgur.com/qKPCSu6.jpeg",
          "https://i.imgur.com/qKPCSu6.jpeg",
          "https://i.imgur.com/qKPCSu6.jpeg",
          "https://i.imgur.com/qKPCSu6.jpeg"
        ],
        "SP006": [
          "https://i.imgur.com/Rr7vzwJ.jpeg",
          "https://i.imgur.com/Rr7vzwJ.jpeg",
          "https://i.imgur.com/Rr7vzwJ.jpeg",
          "https://i.imgur.com/Rr7vzwJ.jpeg",
          "https://i.imgur.com/Rr7vzwJ.jpeg"
        ],
        
        // Stems
        "ST001": [
          "https://i.imgur.com/adfboov.jpeg",  // Using default stem image
          "https://i.imgur.com/adfboov.jpeg",
          "https://i.imgur.com/adfboov.jpeg",
          "https://i.imgur.com/adfboov.jpeg",
          "https://i.imgur.com/adfboov.jpeg"
        ],
        
        // Cranks
        "CR001": [
          "https://i.imgur.com/U3fyA1h.png",
          "https://i.imgur.com/U3fyA1h.png",
          "https://i.imgur.com/U3fyA1h.png",
          "https://i.imgur.com/U3fyA1h.png",
          "https://i.imgur.com/U3fyA1h.png"
        ],
        
        // Wheelsets
        "WS001": [
          "https://i.imgur.com/659Efkd.jpeg",
          "https://i.imgur.com/659Efkd.jpeg",
          "https://i.imgur.com/659Efkd.jpeg",
          "https://i.imgur.com/659Efkd.jpeg",
          "https://i.imgur.com/659Efkd.jpeg"
        ],
        
        // Frames
        "FR001": [
          "https://i.imgur.com/B6cCToB.png",
          "https://i.imgur.com/B6cCToB.png",
          "https://i.imgur.com/B6cCToB.png",
          "https://i.imgur.com/B6cCToB.png",
          "https://i.imgur.com/B6cCToB.png"
        ],
        
        // Tires
        "TR001": [
          "https://i.imgur.com/BZYQSbJ.png",
          "https://i.imgur.com/BZYQSbJ.png",
          "https://i.imgur.com/BZYQSbJ.png",
          "https://i.imgur.com/BZYQSbJ.png",
          "https://i.imgur.com/BZYQSbJ.png"
        ],
        "TR002": [
          "https://i.imgur.com/yNVPyjr.jpeg",
          "https://i.imgur.com/yNVPyjr.jpeg",
          "https://i.imgur.com/yNVPyjr.jpeg",
          "https://i.imgur.com/yNVPyjr.jpeg",
          "https://i.imgur.com/yNVPyjr.jpeg"
        ]
      ]
      
    // Updated helper function to seed products with specific images
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
        
        // Get product-specific images or fall back to category default
        let imageUrls = productImageMap[id] ?? getDefaultImagesForCategory(product.$category.id)
        
        // Create images for this product
        for (index, imageUrl) in imageUrls.enumerated() {
          let image = ProductImage(
            productId: product.id!,
            imageUrl: imageUrl,
            displayOrder: index
          )
          try await image.save(on: database)
        }
        
        // Add a small delay to prevent database overload
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms
      }
      
      print("✅ \(category): Created \(created) products, skipped \(skipped) existing products")
    }
    
    // Define product data (your existing definitions)
    let fullBikes = [
        Product(
            id: "FB001",
            categoryId: "FB",
            name: "Fixie Bike",
            description: "Overview:\nAn iconic high-performance track bike designed for aggressive street riding and competitive criterium racing. Its race-proven geometry delivers sharp, responsive handling for the ultimate fixed-gear experience.\n\nKey Specifications:\n* Model Year: 2025\n* Origin: Designed in Italy, Manufactured in Taiwan\n* Material: Columbus Airplane Aluminum Alloy Frame",
            brand: "Cinelli Histogram",
            price: 11999850,
            quantity: 30
        ),
        Product(
            id: "FB002",
            categoryId: "FB",
            name: "Mountain Bike",
            description: "Overview:\nA versatile full-suspension trail bike engineered for confident climbing and capable descending on any terrain. Its modern geometry and premium suspension provide the ultimate all-around mountain biking experience.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: Alpha Platinum Aluminum Frame",
            brand: "Trek",
            price: 22499850,
            quantity: 30
        ),
        Product(
            id: "FB003",
            categoryId: "FB",
            name: "Road Bike",
            description: "Overview:\nA cutting-edge aero road bike that combines lightweight construction with wind-cheating performance. Engineered for competitive cyclists who demand speed without compromising comfort on long rides.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Germany, Manufactured in Germany\n* Material: Advanced Grade Carbon Fiber Frame",
            brand: "Canyon",
            price: 28499850,
            quantity: 30
        ),
        Product(
            id: "FB004",
            categoryId: "FB",
            name: "Gravel Bike",
            description: "Overview:\nAn adventure-ready gravel bike built to explore beyond the pavement. Its versatile design handles everything from smooth tarmac to rough forest trails, making it the perfect companion for endless exploration.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: FACT 10r Carbon Fiber Frame",
            brand: "Specialized",
            price: 25999850,
            quantity: 25
        ),
        Product(
            id: "FB005",
            categoryId: "FB",
            name: "BMX Bike",
            description: "Overview:\nA bombproof freestyle BMX bike engineered for street riding, park sessions, and dirt jumping. Its reinforced construction and responsive geometry make it ideal for riders pushing the limits of what's possible.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: 100% Chromoly Steel Frame",
            brand: "GT Bikes",
            price: 8999850,
            quantity: 20
        ),
        Product(
            id: "FB006",
            categoryId: "FB",
            name: "Touring Bike",
            description: "Overview:\nA robust expedition touring bike designed for self-supported adventures and long-distance journeys. Built to carry heavy loads while maintaining comfort and stability across thousands of miles.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: 4130 Chromoly Steel Frame",
            brand: "Surly",
            price: 19999850,
            quantity: 15
        ),
        Product(
            id: "FB007",
            categoryId: "FB",
            name: "Track Bike",
            description: "Overview:\nA professional-grade track racing bike optimized for velodrome competition. Its ultra-stiff carbon construction and aggressive geometry deliver maximum power transfer for explosive sprints and sustained speed.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: TeXtreme High-Modulus Carbon Frame",
            brand: "Felt",
            price: 31999850,
            quantity: 10
        ),
        Product(
            id: "FB008",
            categoryId: "FB",
            name: "City Bike",
            description: "Overview:\nA practical urban commuter bike designed for daily transportation and casual rides. Its upright riding position, integrated accessories, and low-maintenance design make city cycling effortless and enjoyable.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Taiwan, Manufactured in Taiwan\n* Material: ALUXX Aluminum Alloy Frame",
            brand: "Giant",
            price: 15999850,
            quantity: 35
        ),
        Product(
            id: "FB009",
            categoryId: "FB",
            name: "Cyclocross Bike",
            description: "Overview:\nA race-bred cyclocross bike built to dominate muddy courses and technical terrain. Its nimble handling and robust construction excel in the demanding conditions of competitive cross racing.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: BallisTec Hi-MOD Carbon Frame",
            brand: "Cannondale",
            price: 27999850,
            quantity: 18
        ),
        Product(
            id: "FB010",
            categoryId: "FB",
            name: "Electric Bike",
            description: "Overview:\nA powerful electric cargo bike designed to replace car trips and revolutionize urban transportation. Its high-capacity battery and robust motor make hauling kids, groceries, or gear effortless.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Vietnam\n* Material: 6061 Aluminum Frame with Integrated Battery",
            brand: "Rad Power",
            price: 35999850,
            quantity: 22
        )
    ]

    let handlebars = [
        Product(
            id: "HB001",
            categoryId: "HB",
            name: "Bullhorn Handlebar",
            description: "Overview:\nA classic pursuit-style handlebar favored by urban fixed-gear riders and track cyclists. Its forward-reaching design provides an aggressive riding position while maintaining excellent control in traffic.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Italy, Manufactured in Italy\n* Material: 6061-T6 Aluminum Alloy",
            brand: "Cinelli",
            price: 824850,
            quantity: 30
        ),
        Product(
            id: "HB002",
            categoryId: "HB",
            name: "Flat Handlebar",
            description: "Overview:\nA precision-engineered flat bar designed for mountain biking and aggressive trail riding. Its wide stance and subtle backsweep provide optimal control and leverage on technical terrain.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Canada, Manufactured in Canada\n* Material: 7050 Aluminum with Shot-Peened Finish",
            brand: "RaceFace",
            price: 689850,
            quantity: 30
        ),
        Product(
            id: "HB003",
            categoryId: "HB",
            name: "Carbon Drop Bar",
            description: "Overview:\nA professional-grade carbon fiber drop bar offering superior vibration dampening and aerodynamic positioning for road cycling excellence. Its ergonomic shape reduces hand fatigue on long rides while maintaining racing performance.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: High-Modulus Carbon Fiber",
            brand: "ENVE",
            price: 2499850,
            quantity: 15
        ),
        Product(
            id: "HB004",
            categoryId: "HB",
            name: "Pursuit Bar Pro",
            description: "Overview:\nA track-specific pursuit handlebar with aggressive geometry, perfect for velodrome racing and time trials. Its wind-tunnel-tested profile minimizes drag while providing stable handling at high speeds.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Italy, Manufactured in Italy\n* Material: Scandium-Enhanced Aluminum Alloy",
            brand: "Deda Elementi",
            price: 1299850,
            quantity: 20
        ),
        Product(
            id: "HB005",
            categoryId: "HB",
            name: "Riser Bar Elite",
            description: "Overview:\nA wide mountain bike handlebar with 35mm rise, providing enhanced control and leverage for technical trail riding and downhill sections. Its reinforced construction withstands the most demanding riding conditions.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in UK, Manufactured in UK\n* Material: 7-Series Aluminum with Hard Anodized Finish",
            brand: "Renthal",
            price: 949850,
            quantity: 25
        ),
        Product(
            id: "HB006",
            categoryId: "HB",
            name: "Gravel Adventure Bar",
            description: "Overview:\nA specialized flared drop bar designed for gravel riding, featuring wider drops for enhanced stability and multiple hand positions during long adventures. Its unique shape provides comfort without sacrificing control.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: 6066-T6 Aluminum with Vibration-Damping Treatment",
            brand: "Salsa",
            price: 1099850,
            quantity: 20
        ),
        Product(
            id: "HB007",
            categoryId: "HB",
            name: "Compact Drop Bar",
            description: "Overview:\nAn ergonomic aluminum drop bar with shorter reach and shallow drops, ideal for riders seeking comfort without sacrificing performance. Its modern design suits both competitive and recreational road cycling.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: 7075 Aluminum with Service Course Finish",
            brand: "Zipp",
            price: 799850,
            quantity: 30
        )
    ]

    let saddles = [
        Product(
            id: "SD001",
            categoryId: "SD",
            name: "Comfort Saddle",
            description: "Overview:\nA heritage leather saddle crafted for long-distance comfort and timeless style. Its suspended design and natural materials provide unmatched comfort that improves with age and use.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in UK, Manufactured in UK\n* Material: Premium Leather with Steel Rails",
            brand: "Brooks",
            price: 599850,
            quantity: 30
        ),
        Product(
            id: "SD002",
            categoryId: "SD",
            name: "Racing Saddle",
            description: "Overview:\nA lightweight racing saddle engineered for competitive cyclists who demand performance. Its pressure-relief channel and carbon-reinforced shell deliver comfort without compromising power transfer.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Italy, Manufactured in Italy\n* Material: Carbon-Reinforced Nylon Shell with K:ium Rails",
            brand: "Fizik",
            price: 1199850,
            quantity: 30
        ),
        Product(
            id: "SD003",
            categoryId: "SD",
            name: "Carbon Pro Saddle",
            description: "Overview:\nA professional-grade carbon fiber saddle designed for elite athletes and weight-conscious riders. Its advanced construction provides optimal support while maintaining an incredibly low weight.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Italy, Manufactured in Italy\n* Material: Full Carbon Monocoque Construction",
            brand: "Selle Italia",
            price: 1899850,
            quantity: 20
        ),
        Product(
            id: "SD004",
            categoryId: "SD",
            name: "Women's Ergonomic Saddle",
            description: "Overview:\nAn anatomically designed saddle specifically engineered for female cyclists. Its wider sit-bone support and strategic cutout provide superior comfort for women's unique anatomy.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Italy\n* Material: Flex-Tuned Nylon Base with Titanium Rails",
            brand: "Terry",
            price: 899850,
            quantity: 25
        ),
        Product(
            id: "SD005",
            categoryId: "SD",
            name: "Touring Saddle Pro",
            description: "Overview:\nAn extra-wide comfort saddle with advanced gel padding system for ultra-long tours. Its shock-absorbing design and weatherproof construction ensure comfort across thousands of miles.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Italy, Manufactured in Italy\n* Material: Royalgel™ Padding with Elastomer Suspension",
            brand: "Selle Royal",
            price: 749850,
            quantity: 30
        ),
        Product(
            id: "SD006",
            categoryId: "SD",
            name: "Track Racing Saddle",
            description: "Overview:\nA minimalist track-specific saddle optimized for velodrome racing and fixed-gear performance. Its narrow profile and firm padding support aggressive riding positions during high-intensity efforts.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Italy, Manufactured in Italy\n* Material: Microfiber Cover with Carbon Rails",
            brand: "Prologo",
            price: 1299850,
            quantity: 15
        ),
        Product(
            id: "SD007",
            categoryId: "SD",
            name: "MTB All-Terrain Saddle",
            description: "Overview:\nA durable mountain bike saddle engineered to withstand the rigors of aggressive trail riding. Its reinforced corners and weather-resistant materials excel in harsh off-road conditions.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: Abrasion-Resistant Microfiber with Chromoly Rails",
            brand: "WTB",
            price: 849850,
            quantity: 25
        )
    ]

    let pedals = [
        Product(
            id: "PD001",
            categoryId: "PD",
            name: "RX-1",
            description: "Overview:\nClassic wide platform pedals favored by urban cyclists and fixed-gear enthusiasts. Their generous platform and sealed bearings provide reliable performance for daily riding and tricks.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Japan, Manufactured in Japan\n* Material: CNC-Machined Aluminum Body",
            brand: "MKS",
            price: 449850,
            quantity: 30
        ),
        Product(
            id: "PD002",
            categoryId: "PD",
            name: "Clipless Road Pedal",
            description: "Overview:\nProfessional road cycling pedals featuring a wide platform and adjustable tension for optimal power transfer. Their lightweight design and precise engagement mechanism meet the demands of competitive cycling.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Japan, Manufactured in Malaysia\n* Material: Carbon Composite Body with Stainless Steel Plate",
            brand: "Shimano",
            price: 1249850,
            quantity: 25
        ),
        Product(
            id: "PD003",
            categoryId: "PD",
            name: "MTB SPD Pedal",
            description: "Overview:\nDual-sided mountain bike pedals with an open design that sheds mud effortlessly. Their four-sided entry and adjustable release tension make them ideal for technical trail riding.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: Forged Chromoly Steel with Brass Cleats",
            brand: "Crank Brothers",
            price: 899850,
            quantity: 20
        ),
        Product(
            id: "PD004",
            categoryId: "PD",
            name: "Track Racing Pedal",
            description: "Overview:\nLightweight track-specific pedals with integrated toe clips designed for velodrome racing. Their aerodynamic profile and secure retention system maximize power transfer during explosive efforts.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in France, Manufactured in France\n* Material: Carbon Fiber Body with Titanium Spindle",
            brand: "Look",
            price: 749850,
            quantity: 15
        ),
        Product(
            id: "PD005",
            categoryId: "PD",
            name: "Platform Pedal Pro",
            description: "Overview:\nPremium flat pedals featuring a concave platform and replaceable traction pins for maximum grip. Their thin profile and sealed bearing system excel in demanding freeride and downhill conditions.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Canada, Manufactured in Canada\n* Material: 6061-T6 Aluminum with DU Bushing System",
            brand: "Race Face",
            price: 599850,
            quantity: 30
        ),
        Product(
            id: "PD006",
            categoryId: "PD",
            name: "Touring Combo Pedal",
            description: "Overview:\nVersatile dual-function pedals offering clipless efficiency on one side and platform convenience on the other. Perfect for touring cyclists who need flexibility in footwear choices.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Japan, Manufactured in Malaysia\n* Material: Aluminum Body with Sealed Bearing Mechanism",
            brand: "Shimano",
            price: 849850,
            quantity: 25
        )
    ]

    let seatposts = [
        Product(
            id: "SP001",
            categoryId: "SP",
            name: "Aluminum Seatpost",
            description: "Overview:\nA precision-machined aluminum seatpost renowned for its strength and reliability. Its two-bolt clamp design provides infinite angle adjustment while maintaining bombproof security.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: 7000-Series Aluminum with Hard Anodized Finish",
            brand: "Thomson",
            price: 524850,
            quantity: 30
        ),
        Product(
            id: "SP002",
            categoryId: "SP",
            name: "Carbon Elite Seatpost",
            description: "Overview:\nAn ultra-lightweight carbon fiber seatpost designed for weight-conscious racers. Its vibration-damping properties and aerodynamic profile enhance both comfort and performance.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: High-Modulus Unidirectional Carbon Fiber",
            brand: "ENVE",
            price: 1299850,
            quantity: 20
        ),
        Product(
            id: "SP003",
            categoryId: "SP",
            name: "Dropper Seatpost",
            description: "Overview:\nA hydraulic dropper post offering infinite height adjustment on the fly. Its smooth action and reliable performance transform the riding experience on technical terrain.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: 6061-T6 Aluminum with Sealed Hydraulic Cartridge",
            brand: "RockShox",
            price: 1899850,
            quantity: 25
        ),
        Product(
            id: "SP004",
            categoryId: "SP",
            name: "Aero Carbon Seatpost",
            description: "Overview:\nAn aerodynamically optimized seatpost designed for time trial and triathlon competition. Its truncated airfoil shape reduces drag while maintaining UCI-legal dimensions.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: Wind-Tunnel Tested Carbon Composite",
            brand: "Profile Design",
            price: 1499850,
            quantity: 15
        ),
        Product(
            id: "SP005",
            categoryId: "SP",
            name: "Suspension Seatpost",
            description: "Overview:\nA comfort-focused seatpost featuring an integrated parallelogram suspension system. Its 50mm of travel smooths out rough roads while maintaining efficient pedaling dynamics.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: Forged Aluminum with Elastomer Suspension",
            brand: "Cane Creek",
            price: 899850,
            quantity: 20
        ),
        Product(
            id: "SP006",
            categoryId: "SP",
            name: "Titanium Seatpost",
            description: "Overview:\nA premium titanium seatpost offering the perfect balance of strength, weight, and ride quality. Its natural vibration-damping properties and lifetime durability justify the investment.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in USA\n* Material: 3Al-2.5V Titanium Alloy",
            brand: "Moots",
            price: 1699850,
            quantity: 10
        )
    ]

    let stems = [
        Product(
            id: "ST001",
            categoryId: "ST",
            name: "Adjustable Stem",
            description: "Overview:\nA versatile adjustable stem allowing riders to fine-tune their handlebar position for optimal comfort and performance. Its robust construction and tool-free adjustment make it ideal for bike fitting.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: 3D-Forged 6061 Aluminum",
            brand: "Ritchey",
            price: 749850,
            quantity: 30
        )
    ]

    let cranks = [
        Product(
            id: "CR001",
            categoryId: "CR",
            name: "Single Speed Crankset",
            description: "Overview:\nA clean and efficient single-speed crankset designed for urban riding and track cycling. Its stiff construction and narrow Q-factor deliver optimal power transfer for fixed-gear performance.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: Forged 7050 Aluminum with Hard Anodized Finish",
            brand: "SRAM",
            price: 1349850,
            quantity: 30
        )
    ]

    let wheelsets = [
        Product(
            id: "WS001",
            categoryId: "WS",
            name: "Fixed Gear Wheelset",
            description: "Overview:\nA bombproof wheelset built specifically for the demands of fixed-gear and single-speed riding. Its deep-section rims provide aerodynamic advantage while maintaining the strength needed for urban assault.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: 6061-T6 Aluminum Rims with Sealed Bearing Hubs",
            brand: "H Plus Son",
            price: 2999850,
            quantity: 30
        )
    ]

    let frames = [
        Product(
            id: "FR001",
            categoryId: "FR",
            name: "Pias Agra",
            description: "Overview:\nAn Indonesian cycling icon, the Pias Agra frameset represents the pinnacle of local frame building expertise. Developed by Sumvelo, it combines aggressive geometry with versatile mounting options for modern riding.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Indonesia, Manufactured in Indonesia\n* Material: Custom-Butted 4130 Chromoly Steel",
            brand: "Sumvelo",
            price: 4499850,
            quantity: 30
        )
    ]

    let tires = [
        Product(
            id: "TR001",
            categoryId: "TR",
            name: "Urban Commuter Tire",
            description: "Overview:\nA puncture-resistant tire engineered for city streets and daily commuting. Its reflective sidewalls and reinforced casing provide safety and durability for year-round urban cycling.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in Germany, Manufactured in Vietnam\n* Material: SmartGuard Puncture Protection Layer",
            brand: "Schwalbe",
            price: 599850,
            quantity: 30
        ),
        Product(
            id: "TR002",
            categoryId: "TR",
            name: "Mountain Bike Tire",
            description: "Overview:\nAn aggressive all-terrain tire designed to excel in diverse trail conditions. Its versatile tread pattern provides confident traction on everything from hardpack to loose terrain.\n\nKey Specifications:\n* Model Year: 2024\n* Origin: Designed in USA, Manufactured in Taiwan\n* Material: Dual-Compound Rubber with EXO Protection",
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
  
  // Fallback function for any products without specific images
  private func getDefaultImagesForCategory(_ categoryId: String) -> [String] {
    let defaultImage = getImageUrlForCategory(categoryId)
    return Array(repeating: defaultImage, count: 5)
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
