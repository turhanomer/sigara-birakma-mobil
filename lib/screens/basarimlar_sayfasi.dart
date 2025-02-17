import 'package:flutter/material.dart';
import '../models/kullanici_verileri.dart';
import '../veritabani.dart';

class BasarimlarSayfasi extends StatefulWidget {
  final int kullaniciId;

  const BasarimlarSayfasi({
    Key? key,
    required this.kullaniciId,
  }) : super(key: key);

  @override
  State<BasarimlarSayfasi> createState() => _BasarimlarSayfasiState();
}

class _BasarimlarSayfasiState extends State<BasarimlarSayfasi> {
  final Veritabani _veritabani = Veritabani();
  KullaniciVerileri? _kullaniciVerileri;
  Duration _gecenSure = Duration.zero;
  int _icilemeyenSigara = 0;
  double _birikilenPara = 0;

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  void _verileriYukle() async {
    final veriler =
        await _veritabani.kullaniciVerileriGetir(widget.kullaniciId);
    if (veriler != null) {
      setState(() {
        _kullaniciVerileri = veriler;
        _istatistikleriGuncelle();
      });
    }
  }

  void _istatistikleriGuncelle() {
    if (_kullaniciVerileri == null) return;

    _gecenSure = DateTime.now().difference(_kullaniciVerileri!.birakisTarihi);

    double gunlukMaliyet = (_kullaniciVerileri!.paketFiyati /
            _kullaniciVerileri!.paketSigaraSayisi) *
        _kullaniciVerileri!.gunlukIcilenSigara;
    _birikilenPara = (gunlukMaliyet * _gecenSure.inDays);

    _icilemeyenSigara =
        (_gecenSure.inDays * _kullaniciVerileri!.gunlukIcilenSigara).floor();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> basarimlar = [
      {
        'icon': Icons.timer,
        'title': 'Kararlı (1/6)',
        'description': 'Tebrikler, sigarayı bırakma kararı aldın.',
        'unlocked': true,
        'category': 'Kararlı'
      },
      {
        'icon': Icons.timer,
        'title': 'Kararlı (2/6)',
        'description': '1 Gündür sigara içmedin',
        'unlocked': _gecenSure.inDays >= 1,
        'category': 'Kararlı'
      },
      {
        'icon': Icons.timer,
        'title': 'Kararlı (3/6)',
        'description': '1 Haftadır sigara içmedin',
        'unlocked': _gecenSure.inDays >= 7,
        'category': 'Kararlı'
      },
      {
        'icon': Icons.timer,
        'title': 'Kararlı (4/6)',
        'description': '1 Aydır sigara içmedin',
        'unlocked': _gecenSure.inDays >= 30,
        'category': 'Kararlı'
      },
      {
        'icon': Icons.timer,
        'title': 'Kararlı (5/6)',
        'description': '6 Aydır sigara içmedin',
        'unlocked': _gecenSure.inDays >= 180,
        'category': 'Kararlı'
      },
      {
        'icon': Icons.timer,
        'title': 'Kararlı (6/6)',
        'description': '1 Yıldır sigara içmedin',
        'unlocked': _gecenSure.inDays >= 365,
        'category': 'Kararlı'
      },
      {
        'icon': Icons.smoke_free,
        'title': 'Sigaraya Hayır (1/5)',
        'description': '100 adet sigara içmedin',
        'unlocked': _icilemeyenSigara >= 100,
        'category': 'Sigaraya Hayır'
      },
      {
        'icon': Icons.smoke_free,
        'title': 'Sigaraya Hayır (2/5)',
        'description': '500 adet sigara içmedin',
        'unlocked': _icilemeyenSigara >= 500,
        'category': 'Sigaraya Hayır'
      },
      {
        'icon': Icons.smoke_free,
        'title': 'Sigaraya Hayır (3/5)',
        'description': '1000 adet sigara içmedin',
        'unlocked': _icilemeyenSigara >= 1000,
        'category': 'Sigaraya Hayır'
      },
      {
        'icon': Icons.smoke_free,
        'title': 'Sigaraya Hayır (4/5)',
        'description': '1500 adet sigara içmedin',
        'unlocked': _icilemeyenSigara >= 1500,
        'category': 'Sigaraya Hayır'
      },
      {
        'icon': Icons.smoke_free,
        'title': 'Sigaraya Hayır (5/5)',
        'description': '2000 adet sigara içmedin',
        'unlocked': _icilemeyenSigara >= 2000,
        'category': 'Sigaraya Hayır'
      },
      {
        'icon': Icons.currency_lira,
        'title': 'Tasarruflu (1/5)',
        'description': '100 TL kurtardın',
        'unlocked': _birikilenPara >= 100,
        'category': 'Tasarruflu'
      },
      {
        'icon': Icons.currency_lira,
        'title': 'Tasarruflu (2/5)',
        'description': '500 TL kurtardın',
        'unlocked': _birikilenPara >= 500,
        'category': 'Tasarruflu'
      },
      {
        'icon': Icons.currency_lira,
        'title': 'Tasarruflu (3/5)',
        'description': '1000 TL kurtardın',
        'unlocked': _birikilenPara >= 1000,
        'category': 'Tasarruflu'
      },
      {
        'icon': Icons.currency_lira,
        'title': 'Tasarruflu (4/5)',
        'description': '5000 TL kurtardın',
        'unlocked': _birikilenPara >= 5000,
        'category': 'Tasarruflu'
      },
      {
        'icon': Icons.currency_lira,
        'title': 'Tasarruflu (5/5)',
        'description': '10000 TL kurtardın',
        'unlocked': _birikilenPara >= 10000,
        'category': 'Tasarruflu'
      },
    ];

    final Map<String, List<Map<String, dynamic>>> groupedBasarimlar = {};
    for (var basarim in basarimlar) {
      final category = basarim['category'] as String;
      if (!groupedBasarimlar.containsKey(category)) {
        groupedBasarimlar[category] = [];
      }
      groupedBasarimlar[category]!.add(basarim);
    }

    if (_kullaniciVerileri == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6A88E5),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groupedBasarimlar.length,
        itemBuilder: (context, categoryIndex) {
          final category = groupedBasarimlar.keys.elementAt(categoryIndex);
          final categoryBasarimlar = groupedBasarimlar[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A88E5),
                  ),
                ),
              ),
              ...categoryBasarimlar.map((basarim) => Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: basarim['unlocked']
                              ? Colors.amber.shade100
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          basarim['icon'] as IconData,
                          color:
                              basarim['unlocked'] ? Colors.amber : Colors.grey,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        basarim['title'] as String,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              basarim['unlocked'] ? Colors.black : Colors.grey,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          basarim['description'] as String,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: basarim['unlocked']
                                ? Colors.black87
                                : Colors.grey,
                          ),
                        ),
                      ),
                      trailing: basarim['unlocked']
                          ? const Icon(Icons.check_circle,
                              color: Colors.green, size: 28)
                          : const Icon(Icons.lock,
                              color: Colors.grey, size: 28),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
