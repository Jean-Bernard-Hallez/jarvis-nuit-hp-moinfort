# Ce plugin fonctionne avec Domoticz... un capteur me dit si je suis debout ou pas... je l'utilise afin de réveiller Jarvis avec le Volumme à 60% au lieu de 100%

# Configuration Carte Audio "aplay -l" pour la trouver... 
ALSAMIXERCARTEVOLUME=0 # Numéro de la carte Audio
ALSAMIXERNOMVOLUME=PCM # Nom de la carte Audio

# Plage horaire du volume à 100% Début
OKPARLE_APARTIRDE="08"

# Plage horaire du volume à 100% Fin
PASDEBRUIT_APARTIRDE="21"

# Volume minumum la nuit... en pourcentage
VOLUME_MIN_APARTIRDE="60%" 

# Adresse Domoticz laisser "" au 2 variable ci dessous si vous n'avez pas de capteur...
DOMOTICZ_CAPTEUR_APARTIRDE="Reveil OK on est lever"
DOMOTICZ_ADRESSE_APARTIRDE="192.168.0.1:9090"

# On=fait des echos bleu du plugin OFF=cache les echos bleu
AFFICHAGE_ETAT_APARTIRDE="OFF" 

