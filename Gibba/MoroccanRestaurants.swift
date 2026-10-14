//
//  MoroccanRestaurants.swift
//  Gibba
//
//  Generated seed data – 15 Moroccan restaurants (extendable to 30)
//

import Foundation

public let moroccanRestaurants: [Restaurant] = [

  // 1 — Marrakech
  Restaurant(
    id: "1",
    name: "Riad Tajine Authentique",
    image: "",
    rating: 4.9,
    deliveryTime: "20-30 min",
    deliveryFee: 15,
    cuisine: "Traditional Moroccan",
    description: "Family recipes passed down through generations in the heart of Marrakech medina",
    menu: [
      MenuItem(
        id: "1-1",
        name: "Tajine Chicken with Preserved Lemons & Olives",
        description: "Free-range chicken slow-cooked with preserved lemons, olives, fresh ginger, and saffron",
        price: 95,
        image: "",
        category: "Tajines",
        isPopular: true,
        ingredients: ["Chicken","Preserved lemons","Olives","Saffron","Ginger","Herbs"],
        calories: 520
      ),
      MenuItem(
        id: "1-2",
        name: "Lamb Tajine with Apricots & Almonds",
        description: "Atlas lamb with dried apricots, toasted almonds, cinnamon and honey glaze",
        price: 125,
        image: "",
        category: "Tajines",
        isSpicy: true,
        ingredients: ["Lamb","Apricots","Almonds","Cinnamon","Honey"],
        calories: 680
      ),
      MenuItem(
        id: "1-3",
        name: "Royal Couscous (Seven Vegetables)",
        description: "Hand-rolled couscous, seasonal vegetables, chickpeas, rich ras el hanout broth",
        price: 85,
        image: "",
        category: "Couscous",
        isVegetarian: true,
        isPopular: true,
        ingredients: ["Couscous","Vegetables","Chickpeas","Ras el hanout"],
        calories: 450
      )
    ],
    isOpen: true,
    distance: "1.2 km",
    offers: ["20% off first order","Free mint tea with tajine"],
    specialty: "Authentic Tajines",
    priceRange: "$$"
  ),

  // 2 — Casablanca
  Restaurant(
    id: "2",
    name: "Casablanca Modern Bistro",
    image: "",
    rating: 4.7,
    deliveryTime: "25-35 min",
    deliveryFee: 20,
    cuisine: "Modern Moroccan",
    description: "Contemporary plates inspired by the Atlantic coast and classic Moroccan flavors",
    menu: [
      MenuItem(
        id: "2-1",
        name: "Deconstructed Beef Tajine",
        description: "Seared premium beef, apricot purée, almond dust, saffron jus",
        price: 180,
        image: "",
        category: "Modern Tajines",
        isPopular: true,
        ingredients: ["Beef","Apricot","Almond","Saffron"],
        calories: 620
      ),
      MenuItem(
        id: "2-2",
        name: "Truffle Couscous Risotto",
        description: "Pearl couscous cooked risotto-style with black truffle and wild mushrooms",
        price: 150,
        image: "",
        category: "Fusion",
        isVegetarian: true,
        ingredients: ["Pearl couscous","Black truffle","Mushrooms","Parmesan"],
        calories: 480
      ),
      MenuItem(
        id: "2-3",
        name: "Chermoula Salmon",
        description: "Atlantic salmon with chermoula crust, pomegranate reduction",
        price: 165,
        image: "",
        category: "Seafood",
        ingredients: ["Salmon","Chermoula","Pomegranate","Quinoa"],
        calories: 550
      )
    ],
    isOpen: true,
    distance: "2.1 km",
    offers: ["Buy 2 get 1 free on appetizers"],
    specialty: "Fusion Cuisine",
    priceRange: "$$$"
  ),

  // 3 — Marrakech
  Restaurant(
    id: "3",
    name: "Tangia Marrakchia",
    image: "",
    rating: 4.8,
    deliveryTime: "25-35 min",
    deliveryFee: 15,
    cuisine: "Marrakchi Specialty",
    description: "Slow-cooked clay-pot tangia and medina classics",
    menu: [
      MenuItem(
        id: "3-1",
        name: "Tangia de Boeuf",
        description: "Beef cooked overnight with preserved lemon, cumin and saffron",
        price: 115,
        image: "",
        category: "Tangia",
        isPopular: true,
        ingredients: ["Beef","Preserved lemon","Cumin","Saffron"],
        calories: 640
      ),
      MenuItem(
        id: "3-2",
        name: "Harira Soup",
        description: "Tomato-lentil soup with chickpeas and herbs",
        price: 40,
        image: "",
        category: "Soups",
        ingredients: ["Tomato","Lentils","Chickpeas","Coriander"],
        calories: 260
      ),
      MenuItem(
        id: "3-3",
        name: "Briouat Trio",
        description: "Crisp pastry cigars filled with cheese, kefta and vegetables",
        price: 55,
        image: "",
        category: "Appetizers",
        ingredients: ["Phyllo","Cheese","Beef","Vegetables"],
        calories: 420
      )
    ],
    isOpen: true,
    distance: "1.6 km",
    offers: ["Free briouat with orders over 150 MAD"],
    specialty: "Tangia",
    priceRange: "$$"
  ),

  // 4 — Fes
  Restaurant(
    id: "4",
    name: "Medersa Pastilla House",
    image: "",
    rating: 4.6,
    deliveryTime: "20-30 min",
    deliveryFee: 12,
    cuisine: "Fassi Traditional",
    description: "Pastilla specialists and Fes classics",
    menu: [
      MenuItem(
        id: "4-1",
        name: "Pastilla au Pigeon",
        description: "Phyllo pastry with spiced pigeon, almonds and cinnamon sugar",
        price: 120,
        image: "",
        category: "Pastilla",
        isPopular: true,
        ingredients: ["Pigeon","Almonds","Cinnamon","Phyllo"],
        calories: 510
      ),
      MenuItem(
        id: "4-2",
        name: "Seffa Medfouna",
        description: "Sweet-savoury vermicelli with raisins, almonds and cinnamon",
        price: 85,
        image: "",
        category: "Fassi Specials",
        isVegetarian: true,
        ingredients: ["Vermicelli","Almonds","Raisins","Cinnamon"],
        calories: 560
      ),
      MenuItem(
        id: "4-3",
        name: "Harira Fassi",
        description: "Rich harira with lentils, chickpeas and lamb stock",
        price: 45,
        image: "",
        category: "Soups",
        ingredients: ["Lentils","Chickpeas","Lamb stock","Tomato"],
        calories: 300
      )
    ],
    isOpen: true,
    distance: "2.4 km",
    offers: ["-10% on Fassi combo"],
    specialty: "Pastilla",
    priceRange: "$$"
  ),

  // 5 — Essaouira
  Restaurant(
    id: "5",
    name: "Essaouira Fish Market",
    image: "",
    rating: 4.5,
    deliveryTime: "35-45 min",
    deliveryFee: 25,
    cuisine: "Moroccan Seafood",
    description: "Fresh catch from the Atlantic coast prepared with traditional flavors",
    menu: [
      MenuItem(
        id: "5-1",
        name: "Grilled Sea Bass with Chermoula",
        description: "Whole sea bass grilled over charcoal with preserved lemon",
        price: 195,
        image: "",
        category: "Grilled Fish",
        isPopular: true,
        ingredients: ["Sea bass","Chermoula","Preserved lemon","Olives","Argan oil"],
        calories: 420
      ),
      MenuItem(
        id: "5-2",
        name: "Sardines à la Chermoula",
        description: "Stuffed sardine fillets with herbed chermoula, baked",
        price: 85,
        image: "",
        category: "Seafood",
        ingredients: ["Sardines","Parsley","Coriander","Garlic","Paprika"],
        calories: 360
      )
    ],
    isOpen: true,
    distance: "4.1 km",
    offers: ["Catch of the day special"],
    specialty: "Atlantic Seafood",
    priceRange: "$$$"
  ),

  // 6 — Rabat
  Restaurant(
    id: "6",
    name: "Rabat Royal Mechoui",
    image: "",
    rating: 4.7,
    deliveryTime: "30-40 min",
    deliveryFee: 18,
    cuisine: "Royal Moroccan",
    description: "Slow-roasted mechoui and royal table classics",
    menu: [
      MenuItem(
        id: "6-1",
        name: "Mechoui Shoulder",
        description: "Slow-roasted lamb shoulder with cumin salt and herbs",
        price: 170,
        image: "",
        category: "Grill",
        isPopular: true,
        ingredients: ["Lamb","Cumin","Butter","Herbs"],
        calories: 690
      ),
      MenuItem(
        id: "6-2",
        name: "Zaalouk & Taktouka",
        description: "Smoky eggplant salad and pepper tomato salad duo",
        price: 55,
        image: "",
        category: "Salads",
        isVegetarian: true,
        ingredients: ["Eggplant","Tomato","Peppers","Garlic"],
        calories: 210
      )
    ],
    isOpen: true,
    distance: "3.0 km",
    offers: ["Family platter -15%"],
    specialty: "Mechoui",
    priceRange: "$$"
  ),

  // 7 — Chefchaouen
  Restaurant(
    id: "7",
    name: "Blue City Couscous",
    image: "",
    rating: 4.6,
    deliveryTime: "20-30 min",
    deliveryFee: 10,
    cuisine: "Rif & Northern",
    description: "Couscous variations and mountain herbs from the Rif",
    menu: [
      MenuItem(
        id: "7-1",
        name: "Couscous Btafaya",
        description: "Couscous with caramelized onions and raisins",
        price: 80,
        image: "",
        category: "Couscous",
        isVegetarian: true,
        isPopular: true,
        ingredients: ["Couscous","Onion","Raisins","Cinnamon"],
        calories: 520
      ),
      MenuItem(
        id: "7-2",
        name: "Kefta Tagine with Eggs",
        description: "Spiced beef meatballs simmered in tomato sauce, finished with eggs",
        price: 95,
        image: "",
        category: "Tajines",
        ingredients: ["Beef","Tomato","Paprika","Cumin","Eggs"],
        calories: 590
      )
    ],
    isOpen: true,
    distance: "1.4 km",
    offers: ["Free mint tea on Fridays"],
    specialty: "Couscous Btafaya",
    priceRange: "$$"
  ),

  // 8 — Agadir
  Restaurant(
    id: "8",
    name: "Agadir Grill & Seafood",
    image: "",
    rating: 4.5,
    deliveryTime: "25-35 min",
    deliveryFee: 14,
    cuisine: "Coastal Grill",
    description: "Argan coast seafood and charcoal grills",
    menu: [
      MenuItem(
        id: "8-1",
        name: "Mixed Seafood Brochettes",
        description: "Charcoal-grilled prawns, calamari and fish skewers",
        price: 155,
        image: "",
        category: "Grill",
        isPopular: true,
        ingredients: ["Prawns","Calamari","Fish","Lemon","Herbs"],
        calories: 580
      ),
      MenuItem(
        id: "8-2",
        name: "Bissara",
        description: "Velvety fava bean purée with olive oil and cumin",
        price: 35,
        image: "",
        category: "Soups",
        isVegetarian: true,
        ingredients: ["Fava beans","Olive oil","Cumin","Garlic"],
        calories: 300
      )
    ],
    isOpen: true,
    distance: "2.9 km",
    offers: ["Seafood box -10%"],
    specialty: "Brochettes de Mer",
    priceRange: "$$"
  ),

  // 9 — Meknes
  Restaurant(
    id: "9",
    name: "Meknes Dar Rfissa",
    image: "",
    rating: 4.6,
    deliveryTime: "25-35 min",
    deliveryFee: 12,
    cuisine: "Imperial City Cuisine",
    description: "Hearty Rfissa and imperial city comfort dishes",
    menu: [
      MenuItem(
        id: "9-1",
        name: "Rfissa",
        description: "Chicken and lentils over shredded msemen with fenugreek broth",
        price: 110,
        image: "",
        category: "Specialties",
        isPopular: true,
        ingredients: ["Chicken","Lentils","Fenugreek","Msemen"],
        calories: 720
      ),
      MenuItem(
        id: "9-2",
        name: "Maakouda Sandwich",
        description: "Crispy potato fritters in khobz with harissa and herbs",
        price: 45,
        image: "",
        category: "Street Food",
        isVegetarian: true,
        ingredients: ["Potato","Flour","Harissa","Herbs"],
        calories: 520
      )
    ],
    isOpen: true,
    distance: "1.7 km",
    offers: ["Student deal"],
    specialty: "Rfissa",
    priceRange: "$$"
  ),

  // 10 — Tangier
  Restaurant(
    id: "10",
    name: "Tangier Port Kitchen",
    image: "",
    rating: 4.5,
    deliveryTime: "20-30 min",
    deliveryFee: 10,
    cuisine: "Northern Seafood",
    description: "Street‑by‑sea favorites near the strait",
    menu: [
      MenuItem(
        id: "10-1",
        name: "Calamari Chermoula",
        description: "Tender calamari grilled with garlic, parsley, paprika and lemon",
        price: 120,
        image: "",
        category: "Seafood",
        isPopular: true,
        ingredients: ["Calamari","Parsley","Garlic","Paprika","Lemon"],
        calories: 410
      ),
      MenuItem(
        id: "10-2",
        name: "Hout Quari (Fried Fish Mix)",
        description: "Crispy local fish selection with charmoula dip",
        price: 130,
        image: "",
        category: "Fry",
        ingredients: ["Mixed fish","Flour","Oil","Lemon"],
        calories: 680
      )
    ],
    isOpen: true,
    distance: "2.2 km",
    offers: ["Free lemonade with seafood platter"],
    specialty: "Calamari Chermoula",
    priceRange: "$$"
  ),

  // 11 — Ouarzazate
  Restaurant(
    id: "11",
    name: "Kasbah Spice Kitchen",
    image: "",
    rating: 4.6,
    deliveryTime: "30-40 min",
    deliveryFee: 18,
    cuisine: "Saharan",
    description: "Dates, almonds and oasis spices from the south",
    menu: [
      MenuItem(
        id: "11-1",
        name: "Lamb with Prunes & Almonds",
        description: "Sweet-savoury lamb tajine with prunes and toasted almonds",
        price: 130,
        image: "",
        category: "Tajines",
        isPopular: true,
        ingredients: ["Lamb","Prunes","Almonds","Cinnamon"],
        calories: 690
      ),
      MenuItem(
        id: "11-2",
        name: "Berber Omelette",
        description: "Tomato, pepper and onion shakshuka baked in a clay dish",
        price: 60,
        image: "",
        category: "Berber",
        isVegetarian: true,
        ingredients: ["Eggs","Tomato","Pepper","Onion"],
        calories: 420
      )
    ],
    isOpen: true,
    distance: "3.6 km",
    offers: ["Oasis set menu -10%"],
    specialty: "Lamb & Prunes",
    priceRange: "$$"
  ),

  // 12 — Fes
  Restaurant(
    id: "12",
    name: "Dar Talaa Gourmand",
    image: "",
    rating: 4.8,
    deliveryTime: "25-35 min",
    deliveryFee: 16,
    cuisine: "Fassi Gourmet",
    description: "Elevated Fassi cuisine with seasonal market produce",
    menu: [
      MenuItem(
        id: "12-1",
        name: "Pastilla au Lait (Milk Pastilla)",
        description: "Sweet milk pudding pastilla with almonds and cinnamon",
        price: 70,
        image: "",
        category: "Desserts",
        isVegetarian: true,
        isPopular: true,
        ingredients: ["Milk cream","Phyllo","Almonds","Cinnamon"],
        calories: 380
      ),
      MenuItem(
        id: "12-2",
        name: "Trid with Chicken",
        description: "Shredded pastry layered with chicken and broth",
        price: 115,
        image: "",
        category: "Fassi Specials",
        ingredients: ["Msemen","Chicken","Onion","Fenugreek"],
        calories: 730
      )
    ],
    isOpen: true,
    distance: "2.0 km",
    offers: ["Dessert on the house (orders 160+ MAD)"],
    specialty: "Milk Pastilla",
    priceRange: "$$"
  ),

  // 13 — Casablanca
  Restaurant(
    id: "13",
    name: "Corniche Street Eats",
    image: "",
    rating: 4.4,
    deliveryTime: "15-25 min",
    deliveryFee: 8,
    cuisine: "Moroccan Street Food",
    description: "Quick bites by the sea—maakouda, bocadillos, kefta",
    menu: [
      MenuItem(
        id: "13-1",
        name: "Kefta Sandwich",
        description: "Grilled spiced kefta, tomato-onion salsa, harissa mayo",
        price: 55,
        image: "",
        category: "Sandwiches",
        isSpicy: true, isPopular: true,
        ingredients: ["Beef","Cumin","Paprika","Harissa"],
        calories: 610
      ),
      MenuItem(
        id: "13-2",
        name: "Sfenj Duo",
        description: "Fresh Moroccan doughnuts (plain & sugar)",
        price: 20,
        image: "",
        category: "Snacks",
        isVegetarian: true,
        ingredients: ["Flour","Yeast","Sugar","Oil"],
        calories: 420
      )
    ],
    isOpen: true,
    distance: "0.9 km",
    offers: ["Free sfenj after 6pm with any sandwich"],
    specialty: "Kefta Sandwich",
    priceRange: "$"
  ),

  // 14 — Marrakech
  Restaurant(
    id: "14",
    name: "Jemaa Flavors",
    image: "",
    rating: 4.5,
    deliveryTime: "20-30 min",
    deliveryFee: 10,
    cuisine: "Souk Classics",
    description: "Skewers, tanjia and market salads from the square",
    menu: [
      MenuItem(
        id: "14-1",
        name: "Mixed Brochettes",
        description: "Chicken, kefta and lamb skewers with charmoula",
        price: 95,
        image: "",
        category: "Grill",
        isPopular: true,
        ingredients: ["Chicken","Beef","Lamb","Garlic","Paprika"],
        calories: 640
      ),
      MenuItem(
        id: "14-2",
        name: "Taktouka",
        description: "Charred green pepper and tomato salad with olive oil",
        price: 35,
        image: "",
        category: "Salads",
        isVegetarian: true,
        ingredients: ["Peppers","Tomato","Garlic","Olive oil"],
        calories: 180
      )
    ],
    isOpen: true,
    distance: "1.0 km",
    offers: ["Combo grill + salad -12%"],
    specialty: "Brochettes",
    priceRange: "$$"
  ),

  // 15 — Rabat
  Restaurant(
    id: "15",
    name: "Andalus Court",
    image: "",
    rating: 4.7,
    deliveryTime: "25-35 min",
    deliveryFee: 14,
    cuisine: "Andalusian-Moroccan",
    description: "Elegant Andalusi influence—pomegranate glazes and orange blossom",
    menu: [
      MenuItem(
        id: "15-1",
        name: "Royal Mechoui Shoulder",
        description: "Slow-roasted lamb shoulder with pomegranate glaze",
        price: 160,
        image: "",
        category: "Royal Dishes",
        isPopular: true,
        ingredients: ["Lamb","Pomegranate","Spices","Orange blossom"],
        calories: 700
      ),
      MenuItem(
        id: "15-2",
        name: "Orange Blossom Flan",
        description: "Silky flan scented with fleur d’oranger",
        price: 45,
        image: "",
        category: "Desserts",
        isVegetarian: true,
        ingredients: ["Milk","Eggs","Sugar","Orange blossom"],
        calories: 320
      )
    ],
    isOpen: true,
    distance: "2.5 km",
    offers: ["Dessert half off with any main"],
    specialty: "Royal Mechoui",
    priceRange: "$$$"
  )
]
