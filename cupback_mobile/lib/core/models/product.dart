class ProductOption {
  final String name;
  final String nameEn;
  final double extraPrice;

  const ProductOption({
    required this.name,
    required this.nameEn,
    this.extraPrice = 0.0,
  });
}

class Product {
  final String id;
  final String cafeId;
  final String name;
  final String nameEn;
  final String description;
  final double price;
  final String category;
  final String? image;
  final int stamps;
  final String calories;
  final String prepTime;
  final bool isAvailable;
  final List<ProductOption> sizeOptions;
  final List<ProductOption> addOnOptions;
  final List<String> sweetnessOptions;

  const Product({
    required this.id,
    required this.cafeId,
    required this.name,
    required this.nameEn,
    required this.description,
    required this.price,
    required this.category,
    this.image,
    this.stamps = 1,
    this.calories = '140 kcal',
    this.prepTime = '5-8 دقائق',
    this.isAvailable = true,
    this.sizeOptions = const [
      ProductOption(name: 'سنجل (Single)', nameEn: 'Single', extraPrice: 0.0),
      ProductOption(name: 'دبل شوت (Double Shot)', nameEn: 'Double Shot', extraPrice: 15.0),
      ProductOption(name: 'حجم كبير (Large Size)', nameEn: 'Large Size', extraPrice: 25.0),
    ],
    this.addOnOptions = const [
      ProductOption(name: 'زيادة ثلج', nameEn: 'Extra Ice', extraPrice: 0.0),
      ProductOption(name: 'ثلج خفيف', nameEn: 'Less Ice', extraPrice: 0.0),
      ProductOption(name: 'شوت إسبريسو إضافي', nameEn: 'Extra Espresso Shot', extraPrice: 15.0),
      ProductOption(name: 'حليب شوفان بديل', nameEn: 'Oat Milk Alternative', extraPrice: 20.0),
      ProductOption(name: 'صوص كراميل أو شوكولاتة', nameEn: 'Caramel/Choco Drizzle', extraPrice: 10.0),
      ProductOption(name: 'نكهة فانيليا فرنسية', nameEn: 'Vanilla Syrup', extraPrice: 10.0),
    ],
    this.sweetnessOptions = const [
      'سكر مظبوط (Normal)',
      'سكر خفيف (Less Sweet)',
      'بدون سكر (No Sugar)',
      'سكر زيادة (Extra Sweet)',
    ],
  });

  Product copyWith({
    String? id,
    String? cafeId,
    String? name,
    String? nameEn,
    String? description,
    double? price,
    String? category,
    String? image,
    int? stamps,
    String? calories,
    String? prepTime,
    bool? isAvailable,
    List<ProductOption>? sizeOptions,
    List<ProductOption>? addOnOptions,
    List<String>? sweetnessOptions,
  }) {
    return Product(
      id: id ?? this.id,
      cafeId: cafeId ?? this.cafeId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      image: image ?? this.image,
      stamps: stamps ?? this.stamps,
      calories: calories ?? this.calories,
      prepTime: prepTime ?? this.prepTime,
      isAvailable: isAvailable ?? this.isAvailable,
      sizeOptions: sizeOptions ?? this.sizeOptions,
      addOnOptions: addOnOptions ?? this.addOnOptions,
      sweetnessOptions: sweetnessOptions ?? this.sweetnessOptions,
    );
  }
}
