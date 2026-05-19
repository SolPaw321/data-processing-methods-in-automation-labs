# DPMA_lab_2

Celem ćwiczenia jest zbadanie własności układów formowania wiązek.

## Dostępne funkcje:

a(PhiDeg,ArrayPattern,ArrayTaper=[]) - funkcja generująca zespoloną odpowiedź szyku antenowego (w postaci wektora wektora sygnałów o rozmiarze odpowiadającym wielkości anteny).
PhiDeg - kąt z którego/na który odbierany jest sygnał [deg]
ArrayPattern - ułożenie elementów odbiorczych w szyku liniowym. Definiuje się jako położenie elementów na osi, gdzie odległość między nimi wynosząca 1 odpowiada d=0.5*lambda
Przykład: ArrayPattern=[0 1 2 3] oznacza 4-elementowy liniowy szyk antenowy z elementami rozmieszczonymi w równomiernych odstępach d.
ArrayTaper - (opcjonalnie) wektor wag używanych do formowania wiązek. Musi być tej samej długości co ArrayPattern.

crandn(n) - funkcja generująca zespolone zmienne losowe o rozkładzie gaussowskim (domyślnie ich wariancja to sqrt(2)),
n - rozmiar wygenerowanego ciągu

Wymagane funkcje systemowe (okna wagowe):
- hamming
- hanning
- blackman
- nuttallwin

## Zadania do realizacji

1. Uzyskanie charakterystyki kierunkowej anteny
Wygeneruj wektor a0 odpowiedzi antenowej (złożonej z 8 równoodległych elementów) na dowolnym, wybranym przez siebie kącie.
Przy pomocy równania y(phi)=a(phi)*a0'; uzyskaj wzór kierunkowości anteny.
Narysuj wykres modułu powyższej funkcji, oś x należy wyskalować z stopniach.
Dla odpowiedniej dokładności przyjmij rozdzielczość 0.01 deg.
Wykreśl taki sam wykres przy obecności więcej niż jednego obiektu (suma wektorów odpowiedzi anteny z różnych kątów).
Oś pionowa powinna być wyskalowana w dB.

2. Poziom listków bocznych oraz 3-db szerokość wiązki.
Napisz własne funkcje pobierające zespolony wektor wzmocnienia (beamPattern - y z poprzedniego zadania) oraz kąty odpowiadające indeksom (angleVec).
Pierwsza z funkcji (get3dbBeamwidth(beamPattern, angleVec)) powinna zwracać 3db szerokość charakterystyki (w stopniach).
Druga z funkcji (getSidelobeLevel(beamPattern, angleVec)) powinna pobierać takie same argumenty jak w poprzednim przypadku, a zwracać maksymalny poziom listka bocznego (w skali liniowej) oraz jego odległość od środka wiązki.

3. Wykreśl charakterystyki oraz zbadaj poziom listków bocznych dla szyku antenowego złożonego z M1=4; M2=8; M3=16; M4=128 elementów odbiorczych.
W tej symulacji obiekt powinien znaleźć się na kącie phi_0=0 [deg] (dla zachowania symetrii).
Wypisz w tabeli szerokości wiązki oraz poziom listków bocznych.
Skomentuj który z szyków antenowych lepiej sprawdzi się w przypadku obserwacji dwóch obiektów przy niedużej separacji kątowej między nimi.

4. Zbadaj wpływ okien wagowych na uzyskane charakterystyki.
W tej symulacji obiekt powinien znaleźć się na kącie phi_0=0 [deg] (dla zachowania symetrii)
Ja jednym wykresie umieść rysunki charakterystyk antenowych z wykorzystaniem okien:
- hamming'a (hamming)
- hanning'a (hanning)
- blackman'a (blackman)
- nuttal'a (nuttallwin)
Utwórz tabelę z szerokościami głównej wiązki oraz poziomem listków bocznych.
