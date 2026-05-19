# DPMA_lab_1

Celem ćwiczenia jest zbadanie własności filtracji dopasowanej na sygnale typu LFM.

## Dostępne funkcje:

getConfig() - pobiera stałe fizyczne i konfigurację (np. częstotliwość próbkowania)

crandn(n) - funkcja generująca zespolone zmienne losowe o rozkładzie gaussowskim (domyślnie ich wariancja to sqrt(2)),
n - rozmiar wygenerowanego ciągu

getChirp(f_low, f_high, duration) - funkcja generująca zespolony sygnał typu LFM.
f_low - dolna częstotliwość sygnału [Hz]
f_high - górna częstotliwość sygnału [Hz]
duration - czas trwania sygnału [s]
Wygenerowany sygnał posiada wariancję=1.

## Zadania do realizacji

1. Generowanie sygnału i jego podstawowe własności
Wygeneruj sygnał LMF o długości 10ms. Zakres częsotliwości dobierz w taki sposób aby na rysunku w dziedzinie czasu (wystarczy część rzeczywista) widoczny był wzrost częstotliwości.
Wykreśl jego przebieg w dziedzinie czasu oraz widmo (oba rysunki proszę umieścić w sprawozdaniu).

2. Korelacja sygnału przy obecności szumu
Wygeneruj zaszumiony sygnał LFM (LFM + szum) w taki sposób aby stosunek sygnału do szumu wynosił SNR=-60dB=10*log10(varLFM/varNoise).
Proszę pamiętać że domyślnie generowana wariancja szumu przez funkcję crandn() wynosi sqrt(2).
Za pomocą funkcji xcorr() (funkcja należy do pakietu signal, który należy uprzednio załadować poleceniem pkg load signal) skoreluj oryginalny sygnał LFM (o wariancji równej 1) z odebranym zaszumionym sygnałem.
Wykreśl moduł uzyskanego przebiegu.
Zbadaj wysokość maksimum uzyskanego przebiegu dla 4 różnych czasów trwania.
Jaka jest zależność między czasem trwania (lub liczbą próbek) a maksimum funkcji korelacji?
W sprawozdaniu umieść przebieg czasowy zaszumionego sygnału LFM oraz przebieg funkcji korelacji.
Przedstaw zależność między ekstremum a czasem trwania.

3. Zależność szerokości listka głównego od od pasma sygnału.
Wygeneruj sygnał LFM o czasie trwania 10 ms i częstotliwościach od 500 Hz do 1500 Hz.
Skoreluj sygnał sam z sobą, narysuj moduł uzyskanego przebiegu.
Napisz funkcje automatycznie określającą 3dB szerokość listka głównego.
Sprawdź szerokość listka głównego dla 3 różnych zakresów częstotliwości.
Skomentuj uzyskane wyniki.
W sprawozdaniu umieść listing funkcji liczącej szerokość 3dB listka głównego.
Skomentuj uzyskane wyniki.

4. Korelacja w przypadku występowania kilku źródeł sygnału
Przyjmijmy że w polu obserwacji radaru znajdują się 4 obiekty na odległościach D=[500 800 1300 2000] [m].
Oblicz jakie będzie opóźnienie między sygnałem nadanym a odebranym dla każdego z obiektów (wartość c jest w funkcji getConfig).
Równanie: t=2*d/c
Wygeneruj symulację sygnału odebranego - załóż że poziom każdego z odebranych sygnałów wynosi -80dB, a opóźnienia wynikające z czasu propagacji zaokrąglij do pełnej liczby próbek.
Wykonaj korelację z sygnałem nadanym (LFM bez opóźnień).
Wykreśl profil odległościowy (korelację, zamień jednak oś X w taki sposób aby była wyskalowana w metrach).
Jakie minimalne pasmo musi mieć sygnał aby możliwe było rozróżnienie sąsiednich obiektów?
Jaki musi być czas trwania sygnału aby ekstremum korelacji było wyrażenie wyższe niż poziom szumu?
W sprawozdaniu umieść wykres profilu odległościowego wraz z parametrami użytego sygnału LFM.
Skomentuj wyniki.






