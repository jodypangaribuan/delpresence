class MahasiswaInfo {
  final int dimId;
  final int userId;
  final String userName;
  final String nim;
  final String nama;
  final String email;
  final int prodiId;
  final String prodiName;
  final String fakultas;
  final int angkatan;
  final String status;
  final String asrama;

  MahasiswaInfo({
    required this.dimId,
    required this.userId,
    required this.userName,
    required this.nim,
    required this.nama,
    required this.email,
    required this.prodiId,
    required this.prodiName,
    required this.fakultas,
    required this.angkatan,
    required this.status,
    required this.asrama,
  });

  factory MahasiswaInfo.fromJson(Map<String, dynamic> json) {
    return MahasiswaInfo(
      dimId: json['dim_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? '',
      nim: json['nim'] ?? '',
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      prodiId: json['prodi_id'] ?? 0,
      prodiName: json['prodi_name'] ?? '',
      fakultas: json['fakultas'] ?? '',
      angkatan: json['angkatan'] ?? 0,
      status: json['status'] ?? '',
      asrama: json['asrama'] ?? '',
    );
  }
}

class MahasiswaDetail {
  final String nim;
  final String nama;
  final String email;
  final String tempatLahir;
  final String tglLahir;
  final String jenisKelamin;
  final String alamat;
  final String hp;
  final String prodi;
  final String fakultas;
  final int sem;
  final int semTa;
  final String ta;
  final int tahunMasuk;
  final String kelas;
  final String dosenWali;
  final String asrama;
  final String namaAyah;
  final String namaIbu;
  final String noHpAyah;
  final String noHpIbu;

  MahasiswaDetail({
    required this.nim,
    required this.nama,
    required this.email,
    required this.tempatLahir,
    required this.tglLahir,
    required this.jenisKelamin,
    required this.alamat,
    required this.hp,
    required this.prodi,
    required this.fakultas,
    required this.sem,
    required this.semTa,
    required this.ta,
    required this.tahunMasuk,
    required this.kelas,
    required this.dosenWali,
    required this.asrama,
    required this.namaAyah,
    required this.namaIbu,
    required this.noHpAyah,
    required this.noHpIbu,
  });

  factory MahasiswaDetail.fromJson(Map<String, dynamic> json) {
    return MahasiswaDetail(
      nim: json['nim'] ?? '',
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      tempatLahir: json['tempat_lahir'] ?? '',
      tglLahir: json['tgl_lahir'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      alamat: json['alamat'] ?? '',
      hp: json['hp'] ?? '',
      prodi: json['prodi'] ?? '',
      fakultas: json['fakultas'] ?? '',
      sem: json['sem'] ?? 0,
      semTa: json['sem_ta'] ?? 0,
      ta: json['ta'] ?? '',
      tahunMasuk: json['tahun_masuk'] ?? 0,
      kelas: json['kelas'] ?? '',
      dosenWali: json['dosen_wali'] ?? '',
      asrama: json['asrama'] ?? '',
      namaAyah: json['nama_ayah'] ?? '',
      namaIbu: json['nama_ibu'] ?? '',
      noHpAyah: json['no_hp_ayah'] ?? '',
      noHpIbu: json['no_hp_ibu'] ?? '',
    );
  }
}

class MahasiswaComplete {
  final MahasiswaInfo basicInfo;
  final MahasiswaDetail details;

  MahasiswaComplete({
    required this.basicInfo,
    required this.details,
  });

  factory MahasiswaComplete.fromJson(Map<String, dynamic> json) {
    return MahasiswaComplete(
      basicInfo: MahasiswaInfo.fromJson(json['basic_info']),
      details: MahasiswaDetail.fromJson(json['details']),
    );
  }
}
