

class StaffMember {
  final String id;
  final String name;
  final String title; // Unvanı (örn: Kuaför, Manikürcü)
  final String? imageUrl; // Profil fotoğrafı URL'si
  final String phoneNumber;
  final String email;
  final String? specialization; // Uzmanlık alanı (örn: Saç Kesimi, Cilt Bakımı)
  final List<String> workingDays; // Çalıştığı günler (örn: ['Pazartesi', 'Salı'])
  final String? bio; // Kısa biyografi veya açıklama

  StaffMember({
    required this.id,
    required this.name,
    required this.title,
    this.imageUrl,
    required this.phoneNumber,
    required this.email,
    this.specialization,
    required this.workingDays,
    this.bio,
  });
}