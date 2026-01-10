/// Doctor model for dummy doctor data
class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String distance;
  final String phone;
  final String address;
  final double rating;
  final String imageUrl;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.distance,
    required this.phone,
    required this.address,
    this.rating = 4.5,
    this.imageUrl = '',
  });
}
