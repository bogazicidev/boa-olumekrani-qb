Config = {}

-- Language Settings
Config.Language = "tr" -- Available: "tr", "en", "pt-br", "ru", "es", "fr", "de", "it", "pl", "ar"

-- Language Texts
Config.Languages = {
    ["tr"] = {
        ["ui_coming_soon"] = "COK YAKINDA",
        ["ui_bleeding_out"] = "KAN KAYBINDAN OLECEKSIN",
        ["ui_ambulance_wait"] = "AMBULANS BEKLE",
        ["ui_call_emergency"] = "ACIL DURUM CAGIR",
        ["ui_killed_by"] = "TARAFINDAN OLDURULDU",
        ["ui_cooldown_message"] = "Hastaneye bildirim gitti! Tekrar bildirim icin %s saniye bekleyin!",
        ["death_unknown"] = "Bilinmeyen Sebep",
        ["death_self"] = "Kendini Öldürdü",
        ["death_fall"] = "Yüksekten Düştü",
        ["death_detecting"] = "Tespit Ediliyor...",
        ["death_unknown_player"] = "Bilinmeyen Oyuncu",
        ["death_vehicle"] = "Araç Kazası",
        ["death_zombie"] = "Zombi Tarafından Öldürüldü",
        ["death_unknown_killer"] = "Bilinmeyen Saldırgan",
        ["notify_emergency_blip"] = "Acil Durum - Oyuncu %s",
        ["notify_emergency_alert"] = "Oyuncu %s acil tıbbi yardıma ihtiyaç duyuyor!",
        ["notify_emergency_received"] = "Acil durum çağrısı alındı! Bir oyuncu tıbbi yardıma ihtiyaç duyuyor!",
        ["notify_emergency_sent"] = "Acil servisler bilgilendirildi!",
        ["notify_emergency_cooldown"] = "Hastaneye bildirim gitti! Tekrar bildirim için 1 dakika bekleyin!",
        ["notify_bleed_out"] = "Kan kaybından öldünüz!"
    },
    
    ["en"] = {
        ["ui_coming_soon"] = "COMING SOON",
        ["ui_bleeding_out"] = "YOU WILL DIE FROM BLOOD LOSS",
        ["ui_ambulance_wait"] = "WAIT FOR AMBULANCE",
        ["ui_call_emergency"] = "CALL EMERGENCY",
        ["ui_killed_by"] = "KILLED BY",
        ["ui_cooldown_message"] = "Emergency services notified! Wait %s seconds to call again!",
        ["death_unknown"] = "Unknown Cause",
        ["death_self"] = "Suicide",
        ["death_fall"] = "Fall Damage",
        ["death_detecting"] = "Detecting...",
        ["death_unknown_player"] = "Unknown Player",
        ["death_vehicle"] = "Vehicle Accident",
        ["death_zombie"] = "Killed by Zombie",
        ["death_unknown_killer"] = "Unknown Attacker",
        ["notify_emergency_blip"] = "Emergency - Player %s",
        ["notify_emergency_alert"] = "Player %s needs emergency medical attention!",
        ["notify_emergency_received"] = "Emergency call received! A player needs medical attention!",
        ["notify_emergency_sent"] = "Emergency services notified!",
        ["notify_emergency_cooldown"] = "Hospital notified! Wait 1 minute to call again!",
        ["notify_bleed_out"] = "You have bled out and died!"
    },
    
    ["pt-br"] = {
        ["ui_coming_soon"] = "EM BREVE",
        ["ui_bleeding_out"] = "VOCÊ MORRERÁ POR PERDA DE SANGUE",
        ["ui_ambulance_wait"] = "AGUARDAR AMBULÂNCIA",
        ["ui_call_emergency"] = "CHAMAR EMERGÊNCIA",
        ["ui_killed_by"] = "MORTO POR",
        ["ui_cooldown_message"] = "Serviços de emergência notificados! Aguarde %s segundos para chamar novamente!",
        ["death_unknown"] = "Causa Desconhecida",
        ["death_self"] = "Suicídio",
        ["death_fall"] = "Dano por Queda",
        ["death_detecting"] = "Detectando...",
        ["death_unknown_player"] = "Jogador Desconhecido",
        ["death_vehicle"] = "Acidente de Veículo",
        ["death_zombie"] = "Morto por Zumbi",
        ["death_unknown_killer"] = "Atacante Desconhecido",
        ["notify_emergency_blip"] = "Emergência - Jogador %s",
        ["notify_emergency_alert"] = "Jogador %s precisa de atenção médica de emergência!",
        ["notify_emergency_received"] = "Chamada de emergência recebida! Um jogador precisa de atenção médica!",
        ["notify_emergency_sent"] = "Serviços de emergência notificados!",
        ["notify_emergency_cooldown"] = "Hospital notificado! Aguarde 1 minuto para chamar novamente!",
        ["notify_bleed_out"] = "Você sangrou até a morte!"
    },
    
    ["es"] = {
        ["ui_coming_soon"] = "PROXIMAMENTE",
        ["ui_bleeding_out"] = "MORIRAS POR PERDIDA DE SANGRE",
        ["ui_ambulance_wait"] = "ESPERAR AMBULANCIA",
        ["ui_call_emergency"] = "LLAMAR EMERGENCIA",
        ["ui_killed_by"] = "ASESINADO POR",
        ["ui_cooldown_message"] = "Servicios de emergencia notificados! Espera %s segundos para llamar de nuevo!",
        ["death_unknown"] = "Causa Desconocida",
        ["death_self"] = "Suicidio",
        ["death_fall"] = "Daño por Caída",
        ["death_detecting"] = "Detectando...",
        ["death_unknown_player"] = "Jugador Desconocido",
        ["death_vehicle"] = "Accidente de Vehículo",
        ["death_zombie"] = "Muerto por Zombi",
        ["death_unknown_killer"] = "Atacante Desconocido",
        ["notify_emergency_blip"] = "Emergencia - Jugador %s",
        ["notify_emergency_alert"] = "¡El jugador %s necesita atención médica de emergencia!",
        ["notify_emergency_received"] = "¡Llamada de emergencia recibida! ¡Un jugador necesita atención médica!",
        ["notify_emergency_sent"] = "¡Servicios de emergencia notificados!",
        ["notify_emergency_cooldown"] = "¡Hospital notificado! ¡Espera 1 minuto para llamar de nuevo!",
        ["notify_bleed_out"] = "¡Has sangrado hasta morir!"
    },
    
    ["fr"] = {
        ["ui_coming_soon"] = "BIENTÔT DISPONIBLE",
        ["ui_bleeding_out"] = "VOUS ALLEZ MOURIR DE PERTE DE SANG",
        ["ui_ambulance_wait"] = "ATTENDRE L'AMBULANCE",
        ["ui_call_emergency"] = "APPELER LES URGENCES",
        ["ui_killed_by"] = "TUÉ PAR",
        ["ui_cooldown_message"] = "Services d'urgence notifiés! Attendez %s secondes pour rappeler!",
        ["death_unknown"] = "Cause Inconnue",
        ["death_self"] = "Suicide",
        ["death_fall"] = "Dégâts de Chute",
        ["death_detecting"] = "Détection...",
        ["death_unknown_player"] = "Joueur Inconnu",
        ["death_vehicle"] = "Accident de Véhicule",
        ["death_zombie"] = "Tué par Zombie",
        ["death_unknown_killer"] = "Attaquant Inconnu",
        ["notify_emergency_blip"] = "Urgence - Joueur %s",
        ["notify_emergency_alert"] = "Le joueur %s a besoin d'une attention médicale d'urgence!",
        ["notify_emergency_received"] = "Appel d'urgence reçu! Un joueur a besoin d'une attention médicale!",
        ["notify_emergency_sent"] = "Services d'urgence notifiés!",
        ["notify_emergency_cooldown"] = "Hôpital notifié! Attendez 1 minute pour rappeler!",
        ["notify_bleed_out"] = "Vous avez saigné à mort!"
    },
    
    ["de"] = {
        ["ui_coming_soon"] = "Demnächst verfügbar",
        ["ui_bleeding_out"] = "Sie werden an Blutverlust sterben",
        ["ui_ambulance_wait"] = "Auf Krankenwagen warten",
        ["ui_call_emergency"] = "Notruf anrufen",
        ["ui_killed_by"] = "Getötet von",
        ["ui_cooldown_message"] = "Notdienste benachrichtigt! Warten Sie %s Sekunden, um erneut anzurufen!",
        ["death_unknown"] = "Unbekannte Ursache",
        ["death_self"] = "Selbstmord",
        ["death_fall"] = "Sturzschaden",
        ["death_detecting"] = "Erkennung...",
        ["death_unknown_player"] = "Unbekannter Spieler",
        ["death_vehicle"] = "Fahrzeugunfall",
        ["death_zombie"] = "Von Zombie getötet",
        ["death_unknown_killer"] = "Unbekannter Angreifer",
        ["notify_emergency_blip"] = "Notfall - Spieler %s",
        ["notify_emergency_alert"] = "Spieler %s benötigt medizinische Notfallversorgung!",
        ["notify_emergency_received"] = "Notruf erhalten! Ein Spieler benötigt medizinische Hilfe!",
        ["notify_emergency_sent"] = "Notdienste benachrichtigt!",
        ["notify_emergency_cooldown"] = "Krankenhaus benachrichtigt! Warten Sie 1 Minute, um erneut anzurufen!",
        ["notify_bleed_out"] = "Sie sind verblutet!"
    },
    
    ["ru"] = {
        ["ui_coming_soon"] = "СКОРО",
        ["ui_bleeding_out"] = "ВЫ УМРЕТЕ ОТ ПОТЕРИ КРОВИ",
        ["ui_ambulance_wait"] = "ЖДАТЬ СКОРУЮ ПОМОЩЬ",
        ["ui_call_emergency"] = "ВЫЗВАТЬ СКОРУЮ",
        ["ui_killed_by"] = "УБИТ",
        ["ui_cooldown_message"] = "Экстренные службы уведомлены! Подождите %s секунд, чтобы позвонить снова!",
        ["death_unknown"] = "Неизвестная причина",
        ["death_self"] = "Самоубийство",
        ["death_fall"] = "Урон от падения",
        ["death_detecting"] = "Обнаружение...",
        ["death_unknown_player"] = "Неизвестный игрок",
        ["death_vehicle"] = "Дорожная авария",
        ["death_zombie"] = "Убит зомби",
        ["death_unknown_killer"] = "Неизвестный нападающий",
        ["notify_emergency_blip"] = "Экстренная ситуация - Игрок %s",
        ["notify_emergency_alert"] = "Игрок %s нуждается в экстренной медицинской помощи!",
        ["notify_emergency_received"] = "Получен экстренный вызов! Игрок нуждается в медицинской помощи!",
        ["notify_emergency_sent"] = "Экстренные службы уведомлены!",
        ["notify_emergency_cooldown"] = "Больница уведомлена! Подождите 1 минуту, чтобы позвонить снова!",
        ["notify_bleed_out"] = "Вы истекли кровью!"
    },
    
    ["it"] = {
        ["ui_coming_soon"] = "PROSSIMAMENTE",
        ["ui_bleeding_out"] = "MORIRAI PER PERDITA DI SANGUE",
        ["ui_ambulance_wait"] = "ASPETTARE AMBULANZA",
        ["ui_call_emergency"] = "CHIAMARE EMERGENZA",
        ["ui_killed_by"] = "UCCISO DA",
        ["ui_cooldown_message"] = "Servizi di emergenza notificati! Aspetta %s secondi per richiamare!",
        ["death_unknown"] = "Causa Sconosciuta",
        ["death_self"] = "Suicidio",
        ["death_fall"] = "Danno da Caduta",
        ["death_detecting"] = "Rilevamento...",
        ["death_unknown_player"] = "Giocatore Sconosciuto",
        ["death_vehicle"] = "Incidente Stradale",
        ["death_zombie"] = "Ucciso da Zombie",
        ["death_unknown_killer"] = "Attaccante Sconosciuto",
        ["notify_emergency_blip"] = "Emergenza - Giocatore %s",
        ["notify_emergency_alert"] = "Il giocatore %s ha bisogno di attenzione medica di emergenza!",
        ["notify_emergency_received"] = "Chiamata di emergenza ricevuta! Un giocatore ha bisogno di attenzione medica!",
        ["notify_emergency_sent"] = "Servizi di emergenza notificati!",
        ["notify_emergency_cooldown"] = "Ospedale notificato! Aspetta 1 minuto per richiamare!",
        ["notify_bleed_out"] = "Sei morto dissanguato!"
    },
    
    ["pl"] = {
        ["ui_coming_soon"] = "WKRÓTCE",
        ["ui_bleeding_out"] = "UMRZESZ Z UTRATY KRWI",
        ["ui_ambulance_wait"] = "CZEKAJ NA KARETKĘ",
        ["ui_call_emergency"] = "ZADZWOŃ PO POGOTOWIE",
        ["ui_killed_by"] = "ZABITY PRZEZ",
        ["ui_cooldown_message"] = "Służby ratunkowe powiadomione! Poczekaj %s sekund, aby zadzwonić ponownie!",
        ["death_unknown"] = "Nieznana przyczyna",
        ["death_self"] = "Samobójstwo",
        ["death_fall"] = "Obrażenia od upadku",
        ["death_detecting"] = "Wykrywanie...",
        ["death_unknown_player"] = "Nieznany gracz",
        ["death_vehicle"] = "Wypadek samochodowy",
        ["death_zombie"] = "Zabity przez zombie",
        ["death_unknown_killer"] = "Nieznany napastnik",
        ["notify_emergency_blip"] = "Nagły wypadek - Gracz %s",
        ["notify_emergency_alert"] = "Gracz %s potrzebuje natychmiastowej pomocy medycznej!",
        ["notify_emergency_received"] = "Otrzymano wezwanie alarmowe! Gracz potrzebuje pomocy medycznej!",
        ["notify_emergency_sent"] = "Służby ratunkowe powiadomione!",
        ["notify_emergency_cooldown"] = "Szpital powiadomiony! Poczekaj 1 minutę, aby zadzwonić ponownie!",
        ["notify_bleed_out"] = "Wykrwawiłeś się na śmierć!"
    },
    
    ["ar"] = {
        ["ui_coming_soon"] = "قريباً",
        ["ui_bleeding_out"] = "ستموت من فقدان الدم",
        ["ui_ambulance_wait"] = "انتظر الإسعاف",
        ["ui_call_emergency"] = "اتصل بالطوارئ",
        ["ui_killed_by"] = "قتل بواسطة",
        ["ui_cooldown_message"] = "تم إخطار خدمات الطوارئ! انتظر %s ثانية للاتصال مرة أخرى!",
        ["death_unknown"] = "سبب غير معروف",
        ["death_self"] = "انتحار",
        ["death_fall"] = "أضرار السقوط",
        ["death_detecting"] = "جاري الكشف...",
        ["death_unknown_player"] = "لاعب غير معروف",
        ["death_vehicle"] = "حادث مركبة",
        ["death_zombie"] = "قتل بواسطة زومبي",
        ["death_unknown_killer"] = "مهاجم غير معروف",
        ["notify_emergency_blip"] = "طوارئ - لاعب %s",
        ["notify_emergency_alert"] = "اللاعب %s يحتاج إلى رعاية طبية طارئة!",
        ["notify_emergency_received"] = "تم استلام مكالمة طوارئ! لاعب يحتاج إلى رعاية طبية!",
        ["notify_emergency_sent"] = "تم إخطار خدمات الطوارئ!",
        ["notify_emergency_cooldown"] = "تم إخطار المستشفى! انتظر دقيقة واحدة للاتصال مرة أخرى!",
        ["notify_bleed_out"] = "لقد نزفت حتى الموت!"
    }
}

-- Function to get localized text
function Config.GetText(key, ...)
    local text = Config.Languages[Config.Language][key]
    if not text then
        return "TEXT_NOT_FOUND: " .. key
    end
    
    if select('#', ...) > 0 then
        return string.format(text, ...)
    end
    
    return text
end


