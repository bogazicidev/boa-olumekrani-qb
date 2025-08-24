# BOA-DeathScreen

![Image](https://github.com/user-attachments/assets/fe660d17-1334-400a-aa3b-64f9fc67f81e)

FiveM sunucuları için geliştirilmiş gelişmiş ölüm ekranı sistemi. Bu script, oyuncuların ölüm durumlarını yönetmek ve gerçekçi bir ölüm deneyimi sunmak için tasarlanmıştır.

## 🌟 Özellikler

### ✅ Temel Özellikler
- **Otomatik Ölüm Tespiti** - Her ölüm türü için otomatik tespit
- **Güvenilir Deathscreen** - Her koşulda çalışan ölüm ekranı
- **Erken Revival Koruması** - 10 saniye boyunca erken canlanmayı engeller
- **Manuel Revival Sistemi** - Buton ile manuel canlanma
- **Acil Durum Çağrısı** - Ambulans oyuncularına bildirim sistemi

### 🎯 Ölüm Tespiti
- **Yüksekten Düşme** → "Yüksekten Düşerek Öldün"
- **Kendini Öldürme** → "Sen"
- **Oyuncu Tarafından Öldürülme** → "Oyuncu İsmi"
- **Araç Kazası** → "Araç Kazasında Öldün"
- **Zombi Saldırısı** → "Zombi Tarafından Öldürüldün"
- **Bilinmeyen Sebepler** → "Bilinmeyen Sebeple Öldün"

### 🎮 Kullanıcı Arayüzü
- **Modern Tasarım** - Şık ve kullanıcı dostu arayüz
- **Countdown Timer** - 5 dakikalık kan kaybı sayacı
- **İki Buton Sistemi**:
  - **"AMBULANS BEKLE"** - Manuel canlanma
  - **"ACİL DURUM ÇAĞIR"** - Ambulans çağrısı
- **Gerçek Zamanlı Güncelleme** - Killer ismi ve silah bilgisi

## 📋 Gereksinimler

### Framework
- **QBX Core** (QBCore tabanlı)

### Bağımlılıklar
- FiveM Server
- QBX Framework

## 🚀 Kurulum

### 1. Dosya Yapısı
```
boa-olumekrani-qb/
├── client/
│   └── main.lua
├── server/
│   └── main.lua
├── html/
│   ├── index.html
│   ├── script.js
│   └── style.css
├── fxmanifest.lua
└── README.md
```

### 2. Kurulum Adımları
1. **Scripti indirin** ve `resources` klasörüne yerleştirin
2. **Server.cfg** dosyasına `ensure BOA-Olum` ekleyin
3. **Sunucuyu yeniden başlatın**

### 3. QBX Entegrasyonu
Script otomatik olarak QBX Core ile entegre olur. Ek yapılandırma gerekmez.

## ⚙️ Yapılandırma

### Timer Ayarları
```lua
-- client/main.lua
deathTimer = 300 -- 5 dakika (saniye cinsinden)
```

### Revival Koruması
```lua
-- client/main.lua
if timeSinceDeath < 10000 then -- 10 saniye koruma
    return
end
```

### Ambulans Mesleği
```lua
-- server/main.lua
if v.PlayerData.job.name == "ambulance" and v.PlayerData.job.onduty then
    -- Ambulans oyuncularına bildirim
end
```

## 🎮 Kullanım

### Oyuncu Tarafı
1. **Ölüm** - Oyuncu öldüğünde otomatik olarak deathscreen açılır
2. **Countdown** - 5 dakikalık kan kaybı sayacı başlar
3. **Seçenekler**:
   - **"AMBULANS BEKLE"** - Direkt canlanma
   - **"ACİL DURUM ÇAĞIR"** - Ambulans çağrısı (60 saniye cooldown)

### Ambulans Tarafı
- **Bildirim** - Ölü oyuncudan acil durum çağrısı alır
- **Blip** - Oyuncunun konumuna blip eklenir
- **Ses** - Bildirim sesi çalar

## 🔧 Teknik Detaylar

### Weapon Hash Tespiti
Script aşağıdaki weapon hash'lerini destekler:
- `-842959696` - Yüksekten düşme / Kendini öldürme
- `-1569615261` - Yüksekten düşme
- `-1951375401` - Yüksekten düşme
- `-102973651` - Yumruk / Düşme
- `-853065399` - Kan kaybı

### Güvenlik Sistemi
- **Ana Tespit** - İlk ölüm tespit sistemi
- **Güvenlik Kontrolü** - Ana sistem kaçırırsa devreye girer
- **Manuel Revival Koruması** - 5 saniye bekleme süresi

### Event Sistemi
```lua
-- Client Events
'BOA-DeathScreen:Client:PlayerDied'
'BOA-DeathScreen:Client:PlayerRevived'
'BOA-DeathScreen:Client:SetKillerName'

-- Server Events
'BOA-DeathScreen:Server:PlayerDied'
'BOA-DeathScreen:Server:PlayerAcceptedDeath'
'BOA-DeathScreen:Server:PlayerCalledEmergency'
'BOA-DeathScreen:Server:GetKillerName'
```

## 🐛 Sorun Giderme

### Yaygın Sorunlar
1. **Deathscreen Açılmıyor**
   - QBX Core'un yüklü olduğundan emin olun
   - Console'da hata mesajı kontrol edin

2. **Killer İsmi Görünmüyor**
   - Oyuncunun karakter bilgilerinin doğru olduğunu kontrol edin
   - Server-client bağlantısını kontrol edin

3. **Butonlar Çalışmıyor**
   - HTML dosyalarının doğru yüklendiğini kontrol edin
   - NUI focus ayarlarını kontrol edin

## 📝 Changelog

### v1.0.0
- ✅ İlk sürüm
- ✅ Temel ölüm tespit sistemi
- ✅ Deathscreen UI
- ✅ Manuel revival sistemi
- ✅ Acil durum çağrısı
- ✅ Güvenlik kontrolü
- ✅ Weapon hash tespiti
- ✅ QBX entegrasyonu

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Commit yapın (`git commit -m 'Add some AmazingFeature'`)
4. Push yapın (`git push origin feature/AmazingFeature`)
5. Pull Request açın

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın.

## 👨‍💻 Geliştirici

**BOA Development Team**

## 📞 Destek

- **Discord**: https://discord.gg/WqfsGWbEwu
- **İnstagram**: https://www.instagram.com/bogazicirp

---

**Not**: Bu script FiveM sunucuları için geliştirilmiştir ve QBX Framework ile uyumludur.



