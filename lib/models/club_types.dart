class ClubType {
  final String id;
  final String name;
  final double shaftLengthM;

  const ClubType({
    required this.id,
    required this.name,
    required this.shaftLengthM,
  });
}

/// Standard golf club shaft lengths (average, men's standard).
/// Source: typical OEM specs across major manufacturers.
const clubTypes = [
  ClubType(id: 'driver', name: 'Driver', shaftLengthM: 1.156),       // 45.5"
  ClubType(id: '3_wood', name: '3 Wood', shaftLengthM: 1.092),       // 43"
  ClubType(id: '5_wood', name: '5 Wood', shaftLengthM: 1.067),       // 42"
  ClubType(id: '3_hybrid', name: '3 Hybrid', shaftLengthM: 1.016),   // 40"
  ClubType(id: '4_hybrid', name: '4 Hybrid', shaftLengthM: 0.991),   // 39"
  ClubType(id: '5_iron', name: '5 Iron', shaftLengthM: 0.965),       // 38"
  ClubType(id: '6_iron', name: '6 Iron', shaftLengthM: 0.953),       // 37.5"
  ClubType(id: '7_iron', name: '7 Iron', shaftLengthM: 0.940),       // 37"
  ClubType(id: '8_iron', name: '8 Iron', shaftLengthM: 0.927),       // 36.5"
  ClubType(id: '9_iron', name: '9 Iron', shaftLengthM: 0.914),       // 36"
  ClubType(id: 'pw', name: 'Pitching Wedge', shaftLengthM: 0.902),   // 35.5"
  ClubType(id: 'sw', name: 'Sand Wedge', shaftLengthM: 0.895),       // 35.25"
  ClubType(id: 'lw', name: 'Lob Wedge', shaftLengthM: 0.889),       // 35"
  ClubType(id: 'putter', name: 'Putter', shaftLengthM: 0.864),       // 34"
];

ClubType? getClubTypeById(String? id) {
  if (id == null || id.isEmpty) return null;
  return clubTypes.cast<ClubType?>().firstWhere(
    (c) => c!.id == id,
    orElse: () => null,
  );
}
