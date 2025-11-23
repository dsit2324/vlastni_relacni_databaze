# IT3 PVY - Vlastní relační databáze

Tento projekt obsahuje návrh relační databáze pro karetní hru inspirovanou Clash Royale.
Cílem je zaznamenávat hráče, jejich karty, bitvy, arény a klany.
Databáze je navržena tak, aby byla přehledná, normalizovaná a podporovala základní mechaniky hry.

<img width="1464" height="784" alt="image" src="https://github.com/user-attachments/assets/f8129038-9547-403e-9e8d-0b2264b3567c" />

- Databáze modeluje herní prostředí, kde:
- hráči mají svou identitu, statistiky a náležitost ke klanu či aréně,
- každý hráč může vlastnit neomezený počet karet — a každou kartu na určité úrovni,
- systém zaznamenává bitvy, jejich účastníky, vítěze i dobu trvání,
- arény definují herní postup hráče podle počtu jeho výher,
- klany sdružují hráče do skupin.
- Každá tabulka zajišťuje jeden „kousek“ herního světa.


1. Tabulka players – Hráči
Tabulka představuje hráče ve hře, jejich statistiky, zařazení a historii účtu.


Co tabulka dělá?
- Ukládá všechna klíčová data každého hráče.
- Uchovává jeho název, statistiky, připojení ke klanu i aréně.
- Slouží jako centrální entita, od které se odkazují bitvy i vlastněné karty.


2. Tabulka cards – Herní karty
Reprezentuje všechny dostupné karty, které mohou mít hráči ve svých balíčcích.


Co tabulka dělá?
- Ukládá každý typ karty dostupný ve hře.
- Definuje její popis, cenu elixíru, vzácnost i typ (jednotka, kouzlo, budova).
- Slouží jako základ pro inventář hráčů.


3. Tabulka players_cards – Inventář hráčů (N:N vztah)
Toto je spojovací tabulka, která mapuje, který hráč vlastní kterou kartu a na jaké úrovni.

Co tabulka dělá?
- umožňuje každému hráči mít neomezený počet karet.
- u každé karty ukládá její úroveň,
- zajišťuje klasický many-to-many vztah mezi hráči a kartami.


4. Tabulka battles – Bitvy mezi hráči
Reprezentuje záznam skutečné bitvy ve hře.


Co tabulka dělá?
- ukládá každou bitvu,
- obsahuje oba soupeře, vítěze, trvání i čas,
- umožňuje vytvářet statistiky hráčů i herní historie


5. Tabulka arenas – Herní arény
Definuje „úrovně“ hráče — tedy v jaké aréně se nachází podle počtu výher.


Co tabulka dělá?
- udává hranice výher, podle kterých je hráč v určité aréně,
- každá aréna má své minimální a maximální požadavky na výhry,
- hráč může být pouze v jedné aréně (M:1 vztah).


6. Tabulka clans – Klany
Reprezentuje herní klany — skupiny hráčů.


Co tabulka dělá? 
- uchovává seznam všech klanů ve hře,
- každý hráč může být členem právě jednoho klanu,
- umožňuje klanové statistiky, žebříčky a spolupráci.


Jak tabulky spolupracují


players → battles
Každá bitva má 2 hráče + vítěze.

players → players_cards → cards
Umožňuje vlastnictví a úrovně karet.

players → clans
Přiřazuje hráče do klanu.

players → arenas
Definuje aktuální úroveň hráče.

Tím vzniká komplexní a funkční herní ekosystém.


Odkaz na DBDiagram: https://dbdiagram.io/d/clash-royale-690dc82f6735e11170b7a70f

