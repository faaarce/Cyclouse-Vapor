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
          ),
          Product(
                     id: "FB004",
                     name: "Gravel Bike",
                     description: "Versatile bike designed for both road and light off-road riding.",
                     images: Array(repeating: "https://i.imgur.com/DXv1ptr.jpeg", count: 5),
                     price: 25999850,
                     brand: "Specialized",
                     quantity: 25
                   ),
                   Product(
                     id: "FB005",
                     name: "BMX Bike",
                     description: "Sturdy bike built for tricks and street riding.",
                     images: Array(repeating: "https://i.imgur.com/DXv1ptr.jpeg", count: 5),
                     price: 8999850,
                     brand: "GT Bikes",
                     quantity: 20
                   ),
                   Product(
                     id: "FB006",
                     name: "Touring Bike",
                     description: "Long-distance bike designed for comfort and cargo capacity.",
                     images: Array(repeating: "https://i.imgur.com/DXv1ptr.jpeg", count: 5),
                     price: 19999850,
                     brand: "Surly",
                     quantity: 15
                   ),
                   Product(
                     id: "FB007",
                     name: "Track Bike",
                     description: "High-performance bike designed for velodrome racing.",
                     images: Array(repeating: "https://i.imgur.com/DXv1ptr.jpeg", count: 5),
                     price: 31999850,
                     brand: "Felt",
                     quantity: 10
                   ),
                   Product(
                     id: "FB008",
                     name: "City Bike",
                     description: "Comfortable bike with upright riding position for urban commuting.",
                     images: Array(repeating: "https://i.imgur.com/DXv1ptr.jpeg", count: 5),
                     price: 15999850,
                     brand: "Giant",
                     quantity: 35
                   ),
                   Product(
                     id: "FB009",
                     name: "Cyclocross Bike",
                     description: "Race-oriented bike designed for mixed-terrain cycling.",
                     images: Array(repeating: "https://i.imgur.com/DXv1ptr.jpeg", count: 5),
                     price: 27999850,
                     brand: "Cannondale",
                     quantity: 18
                   ),
                   Product(
                     id: "FB010",
                     name: "Electric Bike",
                     description: "Pedal-assist bike for effortless urban commuting.",
                     images: Array(repeating: "https://i.imgur.com/DXv1ptr.jpeg", count: 5),
                     price: 35999850,
                     brand: "Rad Power",
                     quantity: 22
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
          ),
          Product(
                id: "HB003",
                name: "Carbon Drop Bar",
                description: "Professional-grade carbon fiber drop bar offering superior vibration dampening and aerodynamic positioning for road cycling excellence.",
                images: [
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                ],
                price: 2499850,
                brand: "ENVE",
                quantity: 15
              ),
              Product(
                id: "HB004",
                name: "Pursuit Bar Pro",
                description: "Track-specific pursuit handlebar with aggressive geometry, perfect for velodrome racing and time trials with optimized aerodynamic profile.",
                images: [
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                ],
                price: 1299850,
                brand: "Deda Elementi",
                quantity: 20
              ),
              Product(
                id: "HB005",
                name: "Riser Bar Elite",
                description: "Wide mountain bike handlebar with 35mm rise, providing enhanced control and leverage for technical trail riding and downhill sections.",
                images: [
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                ],
                price: 949850,
                brand: "Renthal",
                quantity: 25
              ),
              Product(
                id: "HB006",
                name: "Gravel Adventure Bar",
                description: "Specialized flared drop bar designed for gravel riding, featuring wider drops for enhanced stability and multiple hand positions during long adventures.",
                images: [
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                ],
                price: 1099850,
                brand: "Salsa",
                quantity: 20
              ),
              Product(
                id: "HB007",
                name: "Compact Drop Bar",
                description: "Ergonomic aluminum drop bar with shorter reach and shallow drops, ideal for riders seeking comfort without sacrificing performance.",
                images: [
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                  "https://i.imgur.com/DXv1ptr.jpeg",
                ],
                price: 799850,
                brand: "Zipp",
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
          ),
          Product(
                id: "SD003",
                name: "Carbon Pro Saddle",
                description: "Professional-grade carbon fiber saddle for competitive cycling.",
                images: Array(repeating: "https://i.imgur.com/DXv1ptr.jpeg", count: 5),
                price: 1899850,
                brand: "Selle Italia",
                quantity: 20
              ),
              Product(
                id: "SD004",
                name: "Women's Ergonomic Saddle",
                description: "Anatomically designed saddle specifically for female cyclists.",
                images: Array(repeating: "https://i.imgur.com/DXv1ptr.jpeg", count: 5),
                price: 899850,
                brand: "Terry",
                quantity: 25
              ),
              Product(
                id: "SD005",
                name: "Touring Saddle Pro",
                description: "Extra-wide comfort saddle with gel padding for long tours.",
                images: Array(repeating: "https://i.imgur.com/DXv1ptr.jpeg", count: 5),
                price: 749850,
                brand: "Selle Royal",
                quantity: 30
              ),
              Product(
                id: "SD006",
                name: "Track Racing Saddle",
                description: "Minimalist design for velodrome and track racing.",
                images: Array(repeating: "https://i.imgur.com/DXv1ptr.jpeg", count: 5),
                price: 1299850,
                brand: "Prologo",
                quantity: 15
              ),
              Product(
                id: "SD007",
                name: "MTB All-Terrain Saddle",
                description: "Durable saddle designed for rough mountain bike trails.",
                images: Array(repeating: "https://i.imgur.com/DXv1ptr.jpeg", count: 5),
                price: 849850,
                brand: "WTB",
                quantity: 25
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
          ),
          Product(
             id: "PD002",
             name: "Clipless Road Pedal",
             description: "Professional road cycling pedals with precise engagement mechanism.",
             images: Array(repeating: "https://i.imgur.com/VbpNW4V.jpeg", count: 5),
             price: 1249850,
             brand: "Shimano",
             quantity: 25
           ),
           Product(
             id: "PD003",
             name: "MTB SPD Pedal",
             description: "Dual-sided mountain bike pedals with reliable mud-shedding design.",
             images: Array(repeating: "https://i.imgur.com/VbpNW4V.jpeg", count: 5),
             price: 899850,
             brand: "Crank Brothers",
             quantity: 20
           ),
           Product(
             id: "PD004",
             name: "Track Racing Pedal",
             description: "Lightweight pedals with integrated toe clips for track cycling.",
             images: Array(repeating: "https://i.imgur.com/VbpNW4V.jpeg", count: 5),
             price: 749850,
             brand: "Look",
             quantity: 15
           ),
           Product(
             id: "PD005",
             name: "Platform Pedal Pro",
             description: "Premium flat pedals with replaceable pins for maximum grip.",
             images: Array(repeating: "https://i.imgur.com/VbpNW4V.jpeg", count: 5),
             price: 599850,
             brand: "Race Face",
             quantity: 30
           ),
           Product(
             id: "PD006",
             name: "Touring Combo Pedal",
             description: "Versatile pedal with platform on one side and SPD on the other.",
             images: Array(repeating: "https://i.imgur.com/VbpNW4V.jpeg", count: 5),
             price: 849850,
             brand: "Shimano",
             quantity: 25
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
          ),
          Product(
                id: "SP002",
                name: "Carbon Elite Seatpost",
                description: "Ultra-lightweight carbon fiber seatpost for racing bikes.",
                images: Array(repeating: "https://i.imgur.com/Ur38Csn.png", count: 5),
                price: 1299850,
                brand: "ENVE",
                quantity: 20
              ),
              Product(
                id: "SP003",
                name: "Dropper Seatpost",
                description: "Hydraulic dropper post for mountain bikes with remote lever.",
                images: Array(repeating: "https://i.imgur.com/Ur38Csn.png", count: 5),
                price: 1899850,
                brand: "RockShox",
                quantity: 25
              ),
              Product(
                id: "SP004",
                name: "Aero Carbon Seatpost",
                description: "Aerodynamically optimized seatpost for time trial bikes.",
                images: Array(repeating: "https://i.imgur.com/Ur38Csn.png", count: 5),
                price: 1499850,
                brand: "Profile Design",
                quantity: 15
              ),
              Product(
                id: "SP005",
                name: "Suspension Seatpost",
                description: "Comfort-focused seatpost with built-in suspension mechanism.",
                images: Array(repeating: "https://i.imgur.com/Ur38Csn.png", count: 5),
                price: 899850,
                brand: "Cane Creek",
                quantity: 20
              ),
              Product(
                id: "SP006",
                name: "Titanium Seatpost",
                description: "Premium titanium seatpost offering durability and light weight.",
                images: Array(repeating: "https://i.imgur.com/Ur38Csn.png", count: 5),
                price: 1699850,
                brand: "Moots",
                quantity: 10
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
