import 'product.dart';

class Cafe {
  final String id;
  final String name;
  final String nameEn;
  final String category;
  final String location;
  double rating;
  int reviewsCount;
  final bool isOpen;
  final String distance;
  final int requiredOrdersForReward;
  final String activeOffer;
  final String activeOfferDetails;
  final String phone;
  final String? image;
  final String? logo;
  final List<String> gallery; // Compressed atmosphere & interior photos
  final List<Product> menu;

  Cafe({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.category,
    required this.location,
    required this.rating,
    required this.reviewsCount,
    required this.isOpen,
    required this.distance,
    this.requiredOrdersForReward = 6,
    required this.activeOffer,
    required this.activeOfferDetails,
    required this.phone,
    this.image,
    this.logo,
    this.gallery = const [],
    required this.menu,
  });

  Cafe copyWith({
    String? id,
    String? name,
    String? nameEn,
    String? category,
    String? location,
    double? rating,
    int? reviewsCount,
    bool? isOpen,
    String? distance,
    int? requiredOrdersForReward,
    String? activeOffer,
    String? activeOfferDetails,
    String? phone,
    String? image,
    String? logo,
    List<String>? gallery,
    List<Product>? menu,
  }) {
    return Cafe(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      category: category ?? this.category,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      isOpen: isOpen ?? this.isOpen,
      distance: distance ?? this.distance,
      requiredOrdersForReward: requiredOrdersForReward ?? this.requiredOrdersForReward,
      activeOffer: activeOffer ?? this.activeOffer,
      activeOfferDetails: activeOfferDetails ?? this.activeOfferDetails,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      logo: logo ?? this.logo,
      gallery: gallery ?? this.gallery,
      menu: menu ?? this.menu,
    );
  }
}
