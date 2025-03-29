#!/bin/bash

FILE="/Users/ghost/Library/Application Support/CrossOver/Bottles/Steam/system.reg"
BACKUP="$FILE.bak"
PATTERN="\[Software\\\\\\\\CodeWeavers\\\\\\\\CrossOver\\\\\\\\cxoffice\] [0-9]*"

# Crea un backup del file
cp "$FILE" "$BACKUP"
echo "Backup creato: $BACKUP"

# Trova il numero di riga in cui appare il pattern
LINEA=$(grep -n "$PATTERN" "$FILE" | cut -d: -f1)

if [ -n "$LINEA" ]; then
  echo "Trovata corrispondenza alla riga $LINEA."

  # Stampa le righe trovate
  sed -n "${LINEA},$(($LINEA + 4))p" "$FILE"

  read -p "Vuoi cancellare queste righe? (s/n): " RISPOSTA

  if [ "$RISPOSTA" == "s" ]; then
    # Cancella la riga e le 4 successive usando awk
    awk -v linea="$LINEA" 'NR >= linea && NR <= linea + 4 {next} {print}' "$FILE" > temp && mv temp "$FILE"
    echo "Righe cancellate."
  else
    echo "Cancellazione annullata."
  fi
else
  echo "Nessuna corrispondenza trovata."
fi