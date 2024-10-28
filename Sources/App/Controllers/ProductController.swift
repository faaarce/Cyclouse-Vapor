//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 29/09/24.
//

import Vapor


struct ProductController {
  
  static let productData: ProductResponse = {
    
    let categories = [
      Category(
        categoryName: "Full Bike",
        products: [
          Product(
            id: "FB001",
            name: "Fixie Bike",
            description: "Sleek and minimalist fixed-gear bike for urban riding.",
            images: [
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
            ],
            price: 11999850,
            brand: "Cinelli Histogram",
            quantity: 30
          ),
          Product(
            id: "FB002",
            name: "Mountain Bike",
            description: "Full-suspension mountain bike for all terrains.",
            images: [
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
            ],
            price: 22499850,
            brand: "Trek",
            quantity: 30
          ),
          Product(
            id: "FB003",
            name: "Road Bike",
            description: "Lightweight road bike built for speed and endurance.",
            images: [
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
            ],
            price: 28499850,
            brand: "Canyon",
            quantity: 30
          )
        ]
      ),
      Category(
        categoryName: "Handlebar",
        products: [
          Product(
            id: "HB001",
            name: "Bullhorn Handlebar",
            description: "Aerodynamic handlebar popular for fixie bikes.",
            images: [
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
            ],
            price: 824850,
            brand: "Cinelli",
            quantity: 30
          ),
          Product(
            id: "HB002",
            name: "Flat Handlebar",
            description: "Flat bar for precision handling and control.",
            images: [
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
            ],
            price: 689850,
            brand: "RaceFace",
            quantity: 30
          )
        ]
      ),
      Category(
        categoryName: "Saddle",
        products: [
          Product(
            id: "SD001",
            name: "Comfort Saddle",
            description: "Padded seat for long-distance comfort.",
            images: [
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
            ],
            price: 599850,
            brand: "Brooks",
            quantity: 30
          ),
          Product(
            id: "SD002",
            name: "Racing Saddle",
            description: "Lightweight saddle optimized for speed.",
            images: [
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
              "https://i.imgur.com/DXv1ptr.jpeg",
            ],
            price: 1199850,
            brand: "Fizik",
            quantity: 30
          )
        ]
      ),
      Category(
        categoryName: "Pedal",
        products: [
          Product(
            id: "PD001",
            name: "RX-1",
            description: "Wide, flat pedals for casual riding and fixies.",
            images: [
              "https://i.imgur.com/VbpNW4V.jpeg",
              "https://i.imgur.com/VbpNW4V.jpeg",
              "https://i.imgur.com/VbpNW4V.jpeg",
              "https://i.imgur.com/VbpNW4V.jpeg",
              "https://i.imgur.com/VbpNW4V.jpeg"
            ],
            price: 449850,
            brand: "Mks",
            quantity: 30
          )
        ]
      ),
      Category(
        categoryName: "Seatpost",
        products: [
          Product(
            id: "SP001",
            name: "Aluminum Seatpost",
            description: "Lightweight and durable seatpost for various bike types.",
            images: [
              "https://i.imgur.com/Ur38Csn.png",
              "https://i.imgur.com/Ur38Csn.png",
              "https://i.imgur.com/Ur38Csn.png",
              "https://i.imgur.com/Ur38Csn.png",
              "https://i.imgur.com/Ur38Csn.png",
            ],
            price: 524850,
            brand: "Thomson",
            quantity: 30
          )
        ]
      ),
      Category(
        categoryName: "Stem",
        products: [
          Product(
            id: "ST001",
            name: "Adjustable Stem",
            description: "Versatile stem for fine-tuning handlebar position.",
            images: [
              "https://i.imgur.com/adfboov.jpeg",
              "https://i.imgur.com/adfboov.jpeg",
              "https://i.imgur.com/adfboov.jpeg",
              "https://i.imgur.com/adfboov.jpeg",
              "https://i.imgur.com/adfboov.jpeg",
            ],
            price: 749850,
            brand: "Ritchey",
            quantity: 30
          )
        ]
      ),
      Category(
        categoryName: "Crank",
        products: [
          Product(
            id: "CR001",
            name: "Single Speed Crankset",
            description: "Simplified crankset for fixie and single speed bikes.",
            images: [
              "https://i.imgur.com/QGnNKW8.jpeg",
              "https://i.imgur.com/QGnNKW8.jpeg",
              "https://i.imgur.com/QGnNKW8.jpeg",
              "https://i.imgur.com/QGnNKW8.jpeg",
              "https://i.imgur.com/QGnNKW8.jpeg"
            ],
            price: 1349850,
            brand: "SRAM",
            quantity: 30
          )
        ]
      ),
      Category(
        categoryName: "Wheelset",
        products: [
          Product(
            id: "WS001",
            name: "Fixed Gear Wheelset",
            description: "Durable wheelset for fixed gear and single speed bikes.",
            images: [
              "https://i.imgur.com/008fAHZ.png",
              "https://i.imgur.com/008fAHZ.png",
              "https://i.imgur.com/008fAHZ.png",
              "https://i.imgur.com/008fAHZ.png",
              "https://i.imgur.com/008fAHZ.png"
            ],
            price: 2999850,
            brand: "H Plus Son",
            quantity: 30
          )
        ]
      ),
      Category(
        categoryName: "Frame",
        products: [
          Product(
            id: "FR001",
            name: "Pias Agra",
            description: "Indonesian local famous frameset developed by sumvelo.",
            images: [
              "https://i.imgur.com/dEvGyQ9.jpeg",
              "https://i.imgur.com/dEvGyQ9.jpeg",
              "https://i.imgur.com/dEvGyQ9.jpeg",
              "https://i.imgur.com/dEvGyQ9.jpeg",
              "https://i.imgur.com/dEvGyQ9.jpeg"
            ],
            price: 4499850,
            brand: "Surly",
            quantity: 30
          )
        ]
      ),
      Category(
        categoryName: "Tires",
        products: [
          Product(
            id: "TR001",
            name: "Urban Commuter Tire",
            description: "Durable tire with puncture protection for city riding.",
            images: [
              "https://i.imgur.com/EYsAjpr.jpeg",
              "https://i.imgur.com/EYsAjpr.jpeg",
              "https://i.imgur.com/EYsAjpr.jpeg",
              "https://i.imgur.com/EYsAjpr.jpeg",
              "https://i.imgur.com/EYsAjpr.jpeg"
            ],
            price: 599850,
            brand: "Schwalbe",
            quantity: 30
          ),
          Product(
            id: "TR002",
            name: "Mountain Bike Tire",
            description: "Durable tire designed for off-road cycling.",
            images: [
              "https://i.imgur.com/XbZsv6T.jpeg",
              "https://i.imgur.com/XbZsv6T.jpeg",
              "https://i.imgur.com/XbZsv6T.jpeg",
              "https://i.imgur.com/XbZsv6T.jpeg",
              "https://i.imgur.com/XbZsv6T.jpeg"
            ],
            price: 449850,
            brand: "Maxxis",
            quantity: 30
          )
        ]
      ),
    ]
    
    
    
    return ProductResponse(message: "Data fetched successfully", success: true, bikes: Bikes(categories: categories))
    
  }()
  
  static func getProducts(_ req: Request) throws -> ProductResponse {
    return productData
  }
  
  static func getProductById(_ req: Request) throws -> Product {
    guard let productId = req.parameters.get("id") else {
      throw Abort(.badRequest, reason: "Product ID is required")
    }
    
    for category in productData.bikes.categories {
      if let product = category.products.first(where: { $0.id == productId }) {
        return product
      }
    }
    
    throw Abort(.notFound, reason: "Product not found")
  }
  
}
