cd minetest-at-school/build/android

make

# android ndk path: /home/leonardo/android-ndk-r16b
# android sdk path: /home/leonardo/android-sdk-linux

# NOTA: per compilare la versione 5.0 di minetest bisogna modificare il file
# build/android/src/main/java/net.minetest.minetest/MinetestAssetCopy.java
# rimuovere la keyword static alla linea 88.
#
# SBAGLIATO:	private static class copyAssetTask extends AsyncTask<String, Integer, String> {
# GIUSTO:	private class copyAssetTask extends AsyncTask<String, Integer, String> {

make release

jarsigner -verbose -digestalg SHA1 -keystore keystore-minetest-new.jks build/outputs/apk/release/Minetest-release-unsigned.apk minetest-wiscom
(le password richieste sono "pwd4guidoni")

~/android-sdk-linux/build-tools/29.0.2/zipalign -v 4 build/outputs/apk/release/Minetest-release-unsigned.apk build/outputs/apk/release/Minetest-release.apk

# PER INSTALLARE SUL DISPOSITIVO (APK debug o release)
make install_debug
make install_release

# PER ABILITARE L'INSTALLAZIONE DEL FILE apk SUL DISPOSITIVO ANDROID
lsusb
-prendere nota dei valori idVendor e idProduct: esempio 
Bus 002 Device 005: ID 18d1:4ee7 Google Inc. -> idVendor = 18d1, idProduct = 4ee7

sudo nano /etc/udev/rules.d/51-android.rules
    SUBSYSTEM=="usb", ATTR{idVendor}=="<idVendor restituito da lsusb>", ATTR{idProduct}=="<idProduct restituito da lsusb>", MODE="0666", GROUP="plugdev"

sudo udevadm control --reload-rules
# STACCARE E RIATTACCARE IL DISPOSITIVO

# PER VISUALIZZARE I LOG DI DEBUG DELL'APPLICAZIONE
avviare Android Studio
File > Profile or debug APK
    selezionare APK di debug in /home/leonardo/minetest-at-school/minetest/build/android/build/outputs/apk/debug
Per visualizzare i log cliccare in basso a sinistra su "6: Logcat"
    (se il pulsante "6: Logcat" non c'è, View > Tool Window Bars)

# PER RIGENERARE LE CHIAVI CONTENUTE IN UN KEYSTORE DI CUI NON SI CONOSCE LA PASSWORD
# SCARICARE IL FILE
# https://codeload.github.com/gist/4631307/zip/69682386bcc3a35349193830843e3d5f8a687f7d
# ESTRARRE L'ARCHIVIO NELLA CARTELLA CONTENENTE IL KEYSTORE
javac ChangePassword.java
java ChangePassword oldkeystore.jks newkeystore.jks
# INSERIRE UNA PASSWORD
# PER CREARE UN NUOVO CERTIFICATO NEL NUOVO KEYSTORE APPENA CREATO
keytool -genkey -v -keystore newkeystore.jks -alias <NOME APPLICAZIONE> -keyalg RSA -keysize 2048 -validity 10000
# IL <NOME APPLICAZIONE> DEVE ESSERE LO STESSO DATO ALLA FINE DEL COMANDO jarsigner (in questo caso minetest-wiscom)
