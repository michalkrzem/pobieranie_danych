from bs4 import BeautifulSoup
import requests
import time


def get_page():
    """Aplikacja pobiera dane meteorologiczne ze strony IGF i zapisuje na dysku nadając
        w nazwie odpowiednią datę"""

    page = requests.get("http://www.igf.fuw.edu.pl/~kmark/stacja/pracownia/Adam.dat")
    html = BeautifulSoup(page.content, 'html.parser')

    date_before = time.localtime()  # pobieramy aktualną datę i pomniejszamy ją o 1 - dane z dnia poprzedniego
    date = date_before.tm_year, date_before.tm_mon, date_before.tm_mday - 1
    heading = "Dzien Miesiac Rok Godzina Minuta Sekunda Calkowite_CNR[mV] Odbite_CNR[mV] Dl_atmosfery_CNR[mV] Dl_ziemi_CNR[mV] Temperatura"

    file = open(str(date).strip('()').replace(', ', '-') + '.csv', 'w')  # tworzymy plik o odpowiedniej nazwie
    file.write(heading + '\n')  # nadajemy nagłówek i wklejamy treść
    file.write(str(html))
    file.close()


get_page()
