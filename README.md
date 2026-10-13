# KPSS Pusula
Türkçe KPSS çalışma takip uygulaması. Yeşil–krem tema, açılır menü, kişisel ana sayfa, konu tamamlama, plan, tekrar, yanlış defteri ve deneme analizi.

## Kurulumu tamamla
1. Supabase projesi: `vagfshaglubndiyhhxuk`. SQL Editor içinde `supabase/schema.sql` dosyasını çalıştır.
2. Project Settings → API Keys bölümündeki **publishable key** değerini `public/config.js` içindeki `publishableKey` alanına yaz. Legacy `anon` anahtarı da desteklenir. **service_role**, `sb_secret_` veya veritabanı şifresi kullanma.
3. Authentication → Email: e-posta doğrulamasını açık tut; şifre alt sınırını 12 karakter yap. Üretim için kendi SMTP sağlayıcını ayarla; Supabase varsayılan e-postaları yalnızca deneme amaçlıdır.
4. GitHub Settings → Pages → Source: **GitHub Actions** seç. Actions içindeki `Publish KPSS Pusula` işini çalıştır. Kod aktarılmış olması sitenin yayımlandığı anlamına gelmez; başarılı işin URL'sini kullan.
5. Supabase Authentication → URL Configuration: Site URL'yi yayınlanan adres yap. Redirect URLs listesine tam olarak `https://canayzin.github.io/kpss-pusula/index.html` ve `https://canayzin.github.io/kpss-pusula/account.html?mode=reset` adreslerini ekle; farklı yayın adresi kullanırsan bunları değiştir.
6. Kayıt, doğrulama e-postası, giriş, şifre sıfırlama ve çıkışı iki test hesabıyla dene. Bir hesap diğerinin verisini görememeli. SQL kuralları olmadan üyeliği kullanıma açma.

## Üyelik
E-posta/şifre Supabase Auth tarafından yönetilir. Telefon kayıt ekranında zorunlu profil alanıdır; `phone_number` metadata alanında tutulur. **SMS doğrulaması etkin değildir** ve arayüz bunu açıkça söyler. Telefonu kimlik veya yetki kanıtı olarak kullanma. SMS doğrulaması ayrı sağlayıcı ve kurulum gerektirir.

## Veriler
Her kullanıcının tek JSON çalışma kaydı vardır. Veritabanı RLS kuralları yalnızca sahibi tarafından okunmasına/yazılmasına izin verir. Sürüm kontrolü, iki cihazdan aynı anda eski verilerin birbirini sessizce ezmesini engeller. Çevrimdışı değişiklikler hesaba özel yerel bir taslakta korunur; çakışmada önce yedek indirilir. Şifre uygulama kayıtlarına veya kodlara yazılmaz.

Eski ChatGPT Site tarayıcı kayıtlarını taşımak için önce eski siteden JSON yedeği indir; yeni hesaba girdikten sonra Hedefler & ayarlar bölümünden yedeği yükle. İki farklı web adresi tarayıcı depolamasını paylaşmaz. Eski Sites projesi ve özel erişimi bu depo tarafından değiştirilmez.

## Test
`node --test tests/core.test.cjs tests/ui.test.cjs`
DOM testleri gerçek tarayıcı görsel testi değildir. Supabase anahtarı ve SQL kurulumu henüz sağlanmadan canlı üyelik uçtan uca doğrulanamaz.
