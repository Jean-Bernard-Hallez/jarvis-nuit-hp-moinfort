# /bin/bash
# Objectif parler doucement dès que je me couche
# parler fort à partir d'une certaine heure et dès que je me lève...
test_parle_fort() {

il_est_exactement=`date +%H`;

if [[ `echo "$il_est_exactement" | cut -c1` == "0" ]]; then 
il_est_exactement=`echo "$il_est_exactement" | cut -c2-`
fi


if [[ `echo "$OKPARLE_APARTIRDE" | cut -c1` == "0" ]]; then 
OKPARLE_APARTIRDE=`echo "$OKPARLE_APARTIRDE" | cut -c2-`
fi

if [[ `echo "$PASDEBRUIT_APARTIRDE" | cut -c1` == "0" ]]; then 
PASDEBRUIT_APARTIRDE=`echo "$PASDEBRUIT_APARTIRDE" | cut -c2-`
fi

if [[ "$etat_M_A_Validation" == "" ]]; then
etat_M_A_Validation="ON"
fi
 
if [[ "$il_est_exactement" -ge "$OKPARLE_APARTIRDE"  ]] && [[ "$il_est_exactement" -le "$PASDEBRUIT_APARTIRDE" ]]; then
	if [[ "$etat_M_A_Validation" == "ON" ]]; then 
	amixer -c $ALSAMIXERCARTEVOLUME -M set $ALSAMIXERNOMVOLUME 100% /dev/null 2>&1	
		if [[ "$AFFICHAGE_ETAT_APARTIRDE" == "ON" ]]; then
		jv_info "je suis dans la plage horaire ou je dois parler fort..."; 
		fi
	fi
else
	amixer -c $ALSAMIXERCARTEVOLUME -M set $ALSAMIXERNOMVOLUME $VOLUME_MIN_APARTIRDE /dev/null 2>&1	
	if [[ "$AFFICHAGE_ETAT_APARTIRDE" == "ON" ]]; then
	jv_info "je suis dans la plage horaire ou je dois parler doucement..."; 
	fi	

fi
}

onestleve_parlefoert_ON () {
if [[ "$il_est_exactement" -ge "$OKPARLE_APARTIRDE"  ]] && [[ "$il_est_exactement" -le "$PASDEBRUIT_APARTIRDE" ]]; then # les heure ou je peux parler fort
onestleve_WGET
fi
}

onestleve_WGET () {
if [[ "$DOMOTICZ_ADRESSE_APARTIRDE" != "" ]]; then
	if [[ "$AFFICHAGE_ETAT_APARTIRDE" == "ON" ]]; then
	jv_info "Wget Domoticz en cours.... "
	fi
	etat_M_A_Chemin="essaijb.txt"
	wget -q http://$DOMOTICZ_ADRESSE_APARTIRDE"/json.htm?type=devices&plan=18" -O $etat_M_A_Chemin
	etat_M_A_ligne=`grep -n "$DOMOTICZ_CAPTEUR_APARTIRDE" essaijb.txt | cut -d: -f1`  # je récupère le numéro de la ligne concerné
	etat_M_A_ligne=$(( $etat_M_A_ligne + 7 ))
	etat_M_A=$(sed -n "$etat_M_A_ligne p" $etat_M_A_Chemin)

		if [[ "$AFFICHAGE_ETAT_APARTIRDE" == "ON" ]]; then
		jv_info "$etat_M_A"
		fi
		if [[ "$etat_M_A" =~ "On" ]]; then 
			if [[ "$AFFICHAGE_ETAT_APARTIRDE" == "ON" ]]; then
			jv_info "Retour Domoticz = réveillé je peux parler fort"; 
			fi
		etat_M_A_Validation="ON"
		else
			if [[ "$AFFICHAGE_ETAT_APARTIRDE" == "ON" ]]; then
			jv_info "Retour Domoticz = Je suis encore endormi..." 
			fi
		etat_M_A_Validation="OFF"
		fi
	
else
	if [[ "$AFFICHAGE_ETAT_APARTIRDE" == "ON" ]]; then
	jv_info "Pas de Capteur Domoticz d'enregistrée" 
	fi

fi
}

jv_pg_ct_onestleve() {
onestleve_WGET
if [[ "$DOMOTICZ_ADRESSE_APARTIRDE" != "" ]]; then
	if [[ "$etat_M_A" =~ "On" ]]; then
	say "Le Capteur"
	say "$DOMOTICZ_CAPTEUR_APARTIRDE"
	say "est sur $etat_M_A_Validation"
	say "Il a donc bien détecté que vous étiez lever"
	fi
	
	if [[ "$etat_M_A" =~ "Off" ]]; then
	say "Le Capteur $DOMOTICZ_CAPTEUR_APARTIRDE"
	say "est sur $etat_M_A_Validation"
	say "Il a donc détecté que vous étiez encore coucher."
	fi
else
say "plage horaire volume maximum"
say "programmée entre $OKPARLE_APARTIRDE heure et $PASDEBRUIT_APARTIRDE heure"
fi

if [[ "$il_est_exactement" -ge "$OKPARLE_APARTIRDE"  ]] && [[ "$il_est_exactement" -le "$PASDEBRUIT_APARTIRDE" ]]; then
	if [[ "$etat_M_A" =~ "On" ]]; then
	say "Le volume est reglé à 100%"	
	else
	say "Le volume est reglé à $VOLUME_MIN_APARTIRDE"	
	fi
else
say "Vous n'êtes pas encore dans la plage horaire du Volume maximal..."
fi
}
