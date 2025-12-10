#!/bin/bash
if [[ -z "$CRON_TZ" && "$TERM" != "dumb" ]]; then
    echo "⛔ El script no puede ejecutarse manualmente."
	sleep 3
    exit 1
fi


PlaylistM3u="/roms2/music/playlist.m3u"
RUTA_MUSICA="/roms2/music"

LOCK_FILE="/tmp/Botones.lock"

JOYSTICK_DEVICES=("/dev/input/event2")


# --- Limpieza previa de instancias antiguas ---
echo "[INFO] Esperando limpieza de instancias previas..."

# Intenta matar evtest y sleeps anteriores del mismo script
sudo killall -q evtest 2>/dev/null
sudo killall -q sleep 2>/dev/null

# Espera hasta que no queden procesos evtest activos
for i in {1..10}; do
    if pgrep -x evtest >/dev/null; then
        echo "Esperando que evtest termine... ($i)"
        sleep 1
    else
        break
    fi
done

# Pequeña pausa extra para asegurar que /dev/input/eventX esté estable
sleep 1

echo "[INFO] Sistema limpio, iniciando monitoreo..."

#Damos permisos de escritura para establecer la velocidad tope del CPU
sudo chmod 777 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq


if [ "$(whoami)" != "ark" ]; then
    echo "Este script debe ejecutarse como el usuario 'ark'."
    exit 1
fi

# Define la contraseña del usuario "ark" si es necesario
password="ark"

echo "$password" | su - ark -c "sleep 86400 & "

#Bucle infinito para mantener la sesión activa
while true; do
echo 'By @Kemazon'
sleep 86400  # Espera un día (86400 segundos) antes de volver a comprobar
done & 

(
    for dev in "${JOYSTICK_DEVICES[@]}"; do
        if [[ -e "$dev" ]]; then
            stdbuf -oL evtest "$dev" &
        else
            echo "Dispositivo no encontrado: $dev"
        fi
    done
    wait
) | while read -r line; do
    # Ahora sí, este while recibirá TODAS las líneas de todos los evtest

	#Boton Siguiente (Audifonos)
    if [[ $line == *"NEXTSONG), value 1"* ]]; then
        touch /tmp/btnNxt
    elif [[ $line == *"NEXTSONG), value 0"* ]]; then
		rm /tmp/btnNxt
    fi
	
	#Boton Atras (Audifonos)
    if [[ $line == *"PREVIOUSSONG), value 1"* ]]; then
        touch /tmp/btnPrv
    elif [[ $line == *"PREVIOUSSONG), value 0"* ]]; then
		rm /tmp/btnPrv
    fi
	
	#Boton Pausa (Audifonos)
    if [[ $line == *"KEY_PAUSECD), value 1"* ]]; then
        touch /tmp/btnPauseCD
    elif [[ $line == *"KEY_PAUSECD), value 0"* ]]; then
		rm /tmp/btnPauseCD
    fi
	
	#Boton Play (Audifonos)
    if [[ $line == *"KEY_PLAYCD), value 1"* ]]; then
        touch /tmp/btnPlayCD
    elif [[ $line == *"KEY_PLAYCD), value 0"* ]]; then
		rm /tmp/btnPlayCD
    fi
	
	#Boton FN
    if [[ $line == *"BTN_TRIGGER_HAPPY5), value 1"* ]]; then
        touch /tmp/btnFn
    elif [[ $line == *"BTN_TRIGGER_HAPPY5), value 0"* ]]; then
        rm /tmp/btnFn
    fi
    
	#Boton Start
    if [[ $line == *"BTN_TRIGGER_HAPPY2), value 1"* ]]; then
        touch /tmp/btnStart
    elif [[ $line == *"BTN_TRIGGER_HAPPY2), value 0"* ]]; then
        rm /tmp/btnStart
    fi
    
	#Boton Select
    if [[ $line == *"BTN_TRIGGER_HAPPY1), value 1"* ]]; then
        touch /tmp/btnSelect
    elif [[ $line == *"BTN_TRIGGER_HAPPY1), value 0"* ]]; then
        rm /tmp/btnSelect
    fi
	
	#Pad Izquierda
	if [[ $line == *"(BTN_DPAD_LEFT), value 1"* ]]; then
        touch /tmp/btnPadIzq
    elif [[ $line == *"(BTN_DPAD_LEFT), value 0"* ]]; then
        rm /tmp/btnPadIzq
    fi
    
	#Pad derecha
    if [[ $line == *"BTN_DPAD_RIGHT), value 1"* ]]; then
        touch /tmp/btnPadDer
    elif [[ $line == *"BTN_DPAD_RIGHT), value 0"* ]]; then
        rm /tmp/btnPadDer
    fi
    
	#Boton Stick 1
    if [[ $line == *"BTN_TRIGGER_HAPPY3), value 1"* ]]; then
        touch /tmp/btnStick1
    elif [[ $line == *"BTN_TRIGGER_HAPPY3), value 0"* ]]; then
        rm /tmp/btnStick1
    fi
	
	#Boton L1	
	if [[ $line == *"(BTN_TL), value 1"* ]]; then
        touch /tmp/btnL1
    elif [[ $line == *"(BTN_TL), value 0"* ]]; then
        rm /tmp/btnL1
    fi
		
	#Boton L2
    if [[ $line == *"(BTN_TL2), value 1"* ]]; then
        touch /tmp/btnL2
    elif [[ $line == *"(BTN_TL2), value 0"* ]]; then
        rm /tmp/btnL2
    fi
	
	#Boton R1
	if [[ $line == *"(BTN_TR), value 1"* ]]; then
        touch /tmp/btnR1
    elif [[ $line == *"(BTN_TR), value 0"* ]]; then
        rm /tmp/btnR1
    fi
	
	#Boton R2
    if [[ $line == *"(BTN_TR2), value 1"* ]]; then
        touch /tmp/btnR2
    elif [[ $line == *"(BTN_TR2), value 0"* ]]; then
        rm /tmp/btnR2
    fi
	
	#Pad Arriba
	if [[ $line == *"(BTN_DPAD_UP), value 1"* ]]; then
        touch /tmp/btnPadUp
    elif [[ $line == *"(BTN_DPAD_UP), value 0"* ]]; then
        rm /tmp/btnPadUp
    fi
	
	#Pad Abajo
	if [[ $line == *"(BTN_DPAD_DOWN), value 1"* ]]; then
        touch /tmp/btnPadDown
    elif [[ $line == *"(BTN_DPAD_DOWN), value 0"* ]]; then
        rm /tmp/btnPadDown
    fi
	
	#Boton X
	if [[ $line == *"(BTN_NORTH), value 1"* ]]; then
        touch /tmp/btnX
    elif [[ $line == *"(BTN_NORTH), value 0"* ]]; then
        rm /tmp/btnX
    fi
	
	#Boton B
	if [[ $line == *"(BTN_SOUTH), value 1"* ]]; then
        touch /tmp/btnB
    elif [[ $line == *"(BTN_SOUTH), value 0"* ]]; then
        rm /tmp/btnB
    fi
	
	#Boton Y
	if [[ $line == *"(BTN_WEST), value 1"* ]]; then
        touch /tmp/btnY
    elif [[ $line == *"(BTN_WEST), value 0"* ]]; then
        rm /tmp/btnY
    fi	
	
	#Boton A
	if [[ $line == *"(BTN_EAST), value 1"* ]]; then
        touch /tmp/btnA
    elif [[ $line == *"(BTN_EAST), value 0"* ]]; then
        rm /tmp/btnA
    fi
	
	#Stick 2 Arriba
	if [[ $line == *"(ABS_RY), value -1800"* ]]; then
        touch /tmp/btnS2Arriba
    elif [[ $line == *"(ABS_RY), value 0"* ]]; then
        rm /tmp/btnS2Arriba
    fi
	
	#Stick 2 Abajo
    if [[ $line == *"(ABS_RY), value 1800"* ]]; then
        touch /tmp/btnS2Abajo
	elif [[ $line == *"(ABS_RY), value 0"* ]]; then
        rm /tmp/btnS2Abajo
    fi
	
	#Stick 2 Izquierda
	if [[ $line == *"(ABS_RX), value -1800"* ]]; then
        touch /tmp/btnS2Izq
    #elif [[ $line == *"(ABS_RX), value 0"* ]]; then
     #   rm /tmp/btnS2Izq
    fi

	#Stick 2 Derecha
	if [[ $line == *"(ABS_RX), value 1800"* ]]; then
        touch /tmp/btnS2Der
    #elif [[ $line == *"(ABS_RX), value 0"* ]]; then
     #   rm /tmp/btnS2Der
    fi
	
	#Boton Stick 2 
	if [[ $line == *"(BTN_TRIGGER_HAPPY4), value 1"* ]]; then
        touch /tmp/btnStick2
    #elif [[ $line == *"(BTN_TRIGGER_HAPPY4), value 0"* ]]; then
     #   rm /tmp/btnStick2
    fi
	
	#Stick 1 Arriba
	if [[ $line == *"(ABS_Y), value -1800"* ]]; then
        touch /tmp/btnS1Arriba
    elif [[ $line == *"(ABS_Y), value 0"* ]]; then
        rm /tmp/btnS1Arriba
    fi
	
	#Stick 1 Abajo
    if [[ $line == *"(ABS_Y), value 1800"* ]]; then
        touch /tmp/btnS1Abajo
	elif [[ $line == *"(ABS_Y), value 0"* ]]; then
        rm /tmp/btnS1Abajo
    fi


#echo '{ "command": ["get_property", "filtered-metadata"] }' | socat - /tmp/mpvsocket
# Ejecutar acciones, según los botones usados

	#Mostrar OSC (MPV)
    if [ ! -e /tmp/btnFn ] && [ -e /tmp/btnX ] && ( pgrep -f "Musica_Play_Player.sh" >/dev/null || pgrep -f "IPTV.sh" >/dev/null || pgrep -f "movies.sh" >/dev/null ); then
		echo '{ "command": ["keypress", "m"] }' | socat - /tmp/mpvsocket
		rm -f /tmp/btnX
	fi
	
	
	#Subir Volumen
    if [ ! -e /tmp/btnFn ] && [ -e /tmp/btnPadUp ] && pgrep -f "Musica_Play_Player.sh" >/dev/null; then
		echo '{ "command": ["keypress", "*"] }' | socat - /tmp/mpvsocket
		rm -f /tmp/btnPadUp
	fi
	
	#Bajar Volumen
    if [ ! -e /tmp/btnFn ] && [ -e /tmp/btnPadDown ] && pgrep -f "Musica_Play_Player.sh" >/dev/null; then
		echo '{ "command": ["keypress", "/"] }' | socat - /tmp/mpvsocket
		rm -f /tmp/btnPadDown
	fi

	#Aumentar CPU 1008000 1200000 1248000 1296000 1512000
	#interactive conservative ondemand userspace powersave performance schedutil
	freq_actual=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq)
	if [ -e /tmp/btnFn ] && [ -e /tmp/btnS1Arriba ]; then
		if [ "$freq_actual" -eq 1008000 ]; then
			echo 1200000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
			echo "Cambio a 1200000"
			rm -f /tmp/btnS1Arriba
		elif [ "$freq_actual" -eq 1200000 ]; then
			echo 1248000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
			echo "Cambio a 1248000"
			rm -f /tmp/btnS1Arriba
		elif [ "$freq_actual" -eq 1248000 ]; then
			echo 1296000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
			echo "Cambio a 1296000"
			rm -f /tmp/btnS1Arriba
		elif [ "$freq_actual" -eq 1296000 ]; then
			echo 1512000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
			echo "Cambio a 1512000"
			rm -f /tmp/btnS1Arriba
		fi
    fi
	
	#Reducir CPU 1008000 1200000 1248000 1296000 1512000	
	freq_actual=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq)
	if [ -e /tmp/btnFn ] && [ -e /tmp/btnS1Abajo ]; then
		if [ "$freq_actual" -eq 1512000 ]; then
			echo 1296000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
			echo "Cambio a 1296000"
			rm -f /tmp/btnS1Abajo
		elif [ "$freq_actual" -eq 1296000 ]; then
			echo 1248000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
			echo "Cambio a 1248000"
			rm -f /tmp/btnS1Abajo
		elif [ "$freq_actual" -eq 1248000 ]; then
			echo 1200000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
			echo "Cambio a 1296000"
			rm -f /tmp/btnS1Abajo
		elif [ "$freq_actual" -eq 1200000 ]; then
			echo 1008000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
			echo "Cambio a 1008000"
			rm -f /tmp/btnS1Abajo
		fi
    fi
	
	
	
	#PLAY/PAUSE (Audifonos)
    if [ -e /tmp/btnPlayCD ] || [ -e /tmp/btnPauseCD ]; then
		if pgrep -f "mpv" > /dev/null && ! pgrep -f "Musica_Play_Player.sh" > /dev/null && ! pgrep -f "IPTV.sh" > /dev/null; then
		echo 'cycle pause' | socat - /tmp/mpvsocket
		rm -f /tmp/btnPlayCD
		rm -f /tmp/btnPauseCD
		elif [ -e /tmp/btnPauseCD ] && pgrep -f "mpv" > /dev/null && ( pgrep -f "Musica_Play_Player.sh" > /dev/null || pgrep -f "IPTV.sh" > /dev/null ); then
		echo 'cycle pause' | socat - /tmp/mpvsocket
		rm -f /tmp/btnPauseCD
		fi
    fi
	
	#PLAY/PAUSE (MPV)
    if [ -e /tmp/btnFn ] && [ -e /tmp/btnStart ]; then
		if pgrep -f "mpv" > /dev/null; then
			echo 'cycle pause' | socat - /tmp/mpvsocket
			rm -f /tmp/btnStart
		fi
	fi
	
	#Anterior (Audifonos)
    if test -e /tmp/btnPrv; then
		if pgrep -f "mpv" > /dev/null || pgrep -f "Musica_Play_Player.sh" > /dev/null || pgrep -f "IPTV.sh" > /dev/null; then
		#echo 'playlist-prev' | socat - /tmp/mpvsocket
		#echo '{ "command": ["keypress", "prev"] }' | socat - /tmp/mpvsocket
		echo '{ "command": ["playlist-prev"] }' | socat - /tmp/mpvsocket
        rm -f /tmp/btnPrv
		fi
    fi
	
	#Siguiente (Audifonos)
    if test -e /tmp/btnNxt; then
		if pgrep -f "mpv" > /dev/null; then
		#echo 'playlist-next' | socat - /tmp/mpvsocket
		#echo '{ "command": ["keypress", "next"] }' | socat - /tmp/mpvsocket
		echo '{ "command": ["playlist-next"] }' | socat - /tmp/mpvsocket
        rm -f /tmp/btnNxt
		fi
    fi

    # Stop/Salir
    if test -e /tmp/btnFn && test -e /tmp/btnSelect; then
        #echo 'key q' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "q"] }' | socat - /tmp/mpvsocket
		echo '{ "command": ["quit"] }' | socat - /tmp/mpvsocket
		sleep 0.5
		killall mpv
		
		#Subir el CPU
		sudo echo interactive | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
		sudo echo interactive | sudo tee /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
		sudo echo interactive | sudo tee /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
		sudo echo interactive | sudo tee /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
        rm -f /tmp/btnFn /tmp/btnSelect
    fi

    # # Siguiente Musica
    # if [ -e /tmp/btnFn ] && [ -e /tmp/btnPadDer ] && pgrep -f "Musica_Play_Player.sh" > /dev/null; then
		# #echo 'playlist-next' | socat - /tmp/mpvsocket
		# #echo '{ "command": ["keypress", "next"] }' | socat - /tmp/mpvsocket
		# echo '{ "command": ["playlist-next"] }' | socat - /tmp/mpvsocket
        # rm -f /tmp/btnPadDer
    # fi
	
	#Anterior Musica/IPTV (Pantalla ON/OFF)
	if [ -e /tmp/btnPadIzq ] && [ "$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)" -gt 0 ] && ( pgrep -f "Musica_Play_Player.sh" > /dev/null || pgrep -f "IPTV.sh" > /dev/null || pgrep -f "movies.sh" >/dev/null ); then
        #echo 'playlist-prev' | socat - /tmp/mpvsocket
		#echo '{ "command": ["keypress", "prev"] }' | socat - /tmp/mpvsocket
		if pgrep -f "IPTV.sh" > /dev/null; then
			echo 'show-text Cargando...' | socat - /tmp/mpvsocket
		fi
		echo '{ "command": ["playlist-prev"] }' | socat - /tmp/mpvsocket
        rm -f /tmp/btnPadIzq
		elif [ -e /tmp/btnFn ] && [ -e /tmp/btnPadIzq ] && [ "$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)" -eq 0 ] && ( pgrep -f "Musica_Play_Player.sh" > /dev/null || pgrep -f "IPTV.sh" > /dev/null ); then
		echo '{ "command": ["playlist-prev"] }' | socat - /tmp/mpvsocket
		rm -f /tmp/btnPadIzq
	fi
	
	#Siguiente Musica/IPTV (Pantalla ON/OFF)
	if [ -e /tmp/btnPadDer ] && [ "$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)" -gt 0 ] && ( pgrep -f "Musica_Play_Player.sh" > /dev/null || pgrep -f "IPTV.sh" > /dev/null || pgrep -f "movies.sh" >/dev/null ) ; then
        #echo 'playlist-next' | socat - /tmp/mpvsocket
		#echo '{ "command": ["keypress", "next"] }' | socat - /tmp/mpvsocket
		if pgrep -f "IPTV.sh" > /dev/null; then
			echo 'show-text Cargando...' | socat - /tmp/mpvsocket
		fi
		echo '{ "command": ["playlist-next"] }' | socat - /tmp/mpvsocket
        rm -f /tmp/btnPadDer
		elif [ -e /tmp/btnFn ] && [ -e /tmp/btnPadDer ] && [ "$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)" -eq 0 ] && ( pgrep -f "Musica_Play_Player.sh" > /dev/null || pgrep -f "IPTV.sh" > /dev/null ); then
		echo '{ "command": ["playlist-next"] }' | socat - /tmp/mpvsocket
		rm -f /tmp/btnPadDer
	fi
	
	# Siguiente Musica (De Fondo)
	if [ -e /tmp/btnFn ] && [ -e /tmp/btnPadDer ] && pgrep -f "mpv" > /dev/null && ( ! pgrep -f "Musica_Play_Player.sh" > /dev/null && ! pgrep -f "IPTV.sh" > /dev/null ); then
        #echo 'playlist-prev' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "next"] }' | socat - /tmp/mpvsocket
		rm -f /tmp/btnPadDer
	fi
	
	# Anterior Musica (De Fondo)
	if [ -e /tmp/btnFn ] && [ -e /tmp/btnPadIzq ] && pgrep -f "mpv" > /dev/null && ( ! pgrep -f "Musica_Play_Player.sh" > /dev/null && ! pgrep -f "IPTV.sh" > /dev/null ); then
        #echo 'playlist-prev' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "prev"] }' | socat - /tmp/mpvsocket
		rm -f /tmp/btnPadIzq
	fi
	
    #Pantalla OFF y reducir CPU al minimo.
    if test -e /tmp/btnFn && test -e /tmp/btnStick1; then
        if [ "$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)" -gt 0 ]; then
            cat /sys/devices/platform/backlight/backlight/backlight/brightness > /tmp/brightness
			for ((i="$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)"; i>=0; i-=10)); do
				echo "$i" > /sys/devices/platform/backlight/backlight/backlight/brightness
				sleep 0.1
			done
			echo "0" > /sys/devices/platform/backlight/backlight/backlight/brightness
			echo powersave | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
			echo powersave | sudo tee /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
			echo powersave | sudo tee /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
			echo powersave | sudo tee /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
			echo 1008000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
        elif [ "$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)" -eq 0 ]; then
			for ((i=0; i<="$(cat /tmp/brightness)"; i+=10)); do
				echo "$i" > /sys/devices/platform/backlight/backlight/backlight/brightness
				sleep 0.1
			done
			echo "$(cat /tmp/brightness)" > /sys/devices/platform/backlight/backlight/backlight/brightness  # Asegurar el valor final
			echo interactive | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
			echo interactive | sudo tee /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
			echo interactive | sudo tee /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
			echo interactive | sudo tee /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
            #cat /tmp/brightness > /sys/devices/platform/backlight/backlight/backlight/brightness
        fi
        rm -f /tmp/btnFn /tmp/btnStick1
    fi
	
	#Cambiar relación de aspecto (IPTV)
	if [ -e /tmp/btnStick1 ] && ( pgrep -f "IPTV.sh" > /dev/null || pgrep -f "movies.sh" > /dev/null ); then
		#echo 'key A' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "A"] }' | socat - /tmp/mpvsocket
		rm -f /tmp/btnStick1
	fi

	#Encender radio WiFi
    if test -e /tmp/btnFn && test -e /tmp/btnL2; then
        sudo nmcli radio all on
        rm -f /tmp/btnFn /tmp/btnL2
    fi
	
	#Apagar radio WiFi
    if test -e /tmp/btnFn && test -e /tmp/btnR2; then
        sudo nmcli radio all off
        rm -f /tmp/btnFn /tmp/btnR2
    fi
	
	#Conectar a ultimo dispositivo bluetooth (audio)
    if test -e /tmp/btnFn && test -e /tmp/btnL1; then
        btDevice=$(cat /home/ark/last_bluetooth)
		bluetoothctl disconnect "${btDevice//_/:}"
		sleep 1
		sudo pulseaudio -k -v	
		sleep 1
		sudo pulseaudio --start
		sleep 1
		bluetoothctl connect "${btDevice//_/:}"		
		sleep 1
		pactl set-card-profile bluez_card."${btDevice}" a2dp_sink
		sleep 1
		pactl set-default-sink bluez_sink."${btDevice}".a2dp_sink
        rm -f /tmp/btnFn /tmp/btnL1
		SCRIPT_PATH=$(realpath "$0")			
    fi
	
	#Avanzar 15 segundos
	if test -e /tmp/btnFn && test -e /tmp/btnPadUp; then
        #echo 'seek 15' | socat - /tmp/mpvsocket
		echo '{ "command": ["seek", 15] }' | socat - /tmp/mpvsocket
        rm -f /tmp/btnPadUp
    fi
	
	#Retroceder 15 segundos
	if test -e /tmp/btnFn && test -e /tmp/btnPadDown; then
		#echo 'seek -15' | socat - /tmp/mpvsocket
		echo '{ "command": ["seek", -15] }' | socat - /tmp/mpvsocket
        rm -f /tmp/btnPadDown
    fi
	
	#Mostrar nombre de archivo
	if  [ -e /tmp/btnFn ] && [ -e /tmp/btnX ] && pgrep -f "mpv" > /dev/null && ! pgrep -f "IPTV.sh" > /dev/null; then
        echo 'show-text ${filename}' | socat - /tmp/mpvsocket
        rm -f /tmp/btnFn /tmp/btnX
    fi
	
	#Mostrar nombre de Stream (IPTV)
	if  [ -e /tmp/btnFn ] && [ -e /tmp/btnX ] && pgrep -f "IPTV.sh" > /dev/null; then
        echo 'show-text ${media-title}' | socat - /tmp/mpvsocket
        rm -f /tmp/btnFn /tmp/btnX
    fi
	
	#Mostrar información extendida del archivo/stream
	if test -e /tmp/btnFn && test -e /tmp/btnB; then
        #echo 'key i' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "i"] }' | socat - /tmp/mpvsocket
        rm -f /tmp/btnFn /tmp/btnB
    fi
	
	#Activar/Desactivar modo aleatorio (IPTV)
	if [ -e /tmp/btnFn ] && [ -e /tmp/btnY ] && pgrep -f "IPTV.sh" > /dev/null; then
		URL_IPTV=$(cat /tmp/iptv_playlist_url)
        #echo 'key Alt+m' | socat - /tmp/mpvsocket
		#echo '{ "command": ["keypress", "Alt+m"] }' | socat - /tmp/mpvsocket
		if [ ! -e /tmp/shuffle ]; then
			touch /tmp/shuffle
			echo '{ "command": ["playlist-shuffle"] }' | socat - /tmp/mpvsocket
			#echo 'show-text "Modo aleatorio ♫"' | socat - /tmp/mpvsocket
			echo '{ "command": ["show-text", "Modo aleatorio [☺]", 4000, 1] }' | socat - /tmp/mpvsocket
		else
			rm -f /tmp/shuffle
			echo "{ \"command\": [\"loadfile\", \"$URL_IPTV\", \"replace\"] }"| socat - /tmp/mpvsocket
			#echo '{ "command": ["playlist-unshuffle"] }' | socat - /tmp/mpvsocket
			sleep 1
			echo '{ "command": ["show-text", "Modo aleatorio [   ]", 4000, 1] }' | socat - /tmp/mpvsocket
		fi
		rm -f /tmp/btnFn /tmp/btnY
    fi

	
	#Activar/Desactivar modo aleatorio (Musica REPRODUCTOR)
	if [ -e /tmp/btnFn ] && [ -e /tmp/btnY ] && ( pgrep -f "Musica_Play_Player.sh" > /dev/null || pgrep -f "Musica_Play.sh" > /dev/null ); then
        #echo 'key Alt+m' | socat - /tmp/mpvsocket
		#echo '{ "command": ["keypress", "Alt+m"] }' | socat - /tmp/mpvsocket
		#echo 'show-text "Modo aleatorio ♫"' | socat - /tmp/mpvsocket
		if [ ! -e /tmp/shuffle ]; then
			touch /tmp/shuffle
			echo '{ "command": ["playlist-shuffle"] }' | socat - /tmp/mpvsocket
			#echo 'show-text "Modo aleatorio ♫"' | socat - /tmp/mpvsocket
			echo '{ "command": ["show-text", "Modo aleatorio [☺]", 4000, 1] }' | socat - /tmp/mpvsocket
		else
			rm -f /tmp/shuffle
			echo "{ \"command\": [\"loadfile\", \"$PlaylistM3u\", \"replace\"] }"| socat - /tmp/mpvsocket
			#echo '{ "command": ["playlist-unshuffle"] }' | socat - /tmp/mpvsocket
			sleep 1
			echo '{ "command": ["show-text", "Modo aleatorio [   ]", 4000, 1] }' | socat - /tmp/mpvsocket
		fi
		rm -f /tmp/btnFn /tmp/btnY
    fi
	
	#Activar/Desactivar modo aleatorio (Musica FONDO)
	if [ -e /tmp/btnFn ] && [ -e /tmp/btnY ] && pgrep -f "mpv" > /dev/null && ! pgrep -f "IPTV.sh" > /dev/null && ! pgrep -f "Musica_Play_Player.sh" > /dev/null; then
        #echo 'key Alt+m' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "Alt+m"] }' | socat - /tmp/mpvsocket
		rm -f /tmp/btnFn /tmp/btnY
    fi
	
	#Recargar y volver a reproducir Lista IPTV
	if [ -e /tmp/btnFn ] && [ -e /tmp/btnA ] && pgrep -f "IPTV.sh" > /dev/null; then
		URL_IPTV=$(cat /tmp/iptv_playlist_url)
		printf 'show-text "%s"\n' "Actualizando... $URL_IPTV" | socat - /tmp/mpvsocket
		#echo "show-text 'Actualizando... $URL_IPTV'" | socat - /tmp/mpvsocket
		echo "{ \"command\": [\"loadfile\", \"$URL_IPTV\", \"replace\"] }"| socat - /tmp/mpvsocket
		rm -f /tmp/btnFn /tmp/btnA
    fi
	
	#Escanear archivos de música y actualizar playlist.m3u
	if [ -e /tmp/btnFn ] && [ -e /tmp/btnA ] && ! pgrep -f "IPTV.sh" > /dev/null; then
		# Contar archivos en la carpeta
		num_archivos=$(find /roms2/music -type f \( -name "*.m4a" -o -name "*.mp4" -o -name "*.ogg" -o -name "*.mp3" -o -name "*.aac" \) | wc -l | tr -d ' ')

		# Verificar si el PlaylistM3u playlist.m3u existe
		if [ ! -f "$PlaylistM3u" ]; then
			num_lineas=1
		else
			# Contar líneas, ignorando líneas vacías y comentarios
			num_lineas=$(grep -v -e '^$' -e '^#' "$PlaylistM3u" | wc -l | tr -d ' ')
		fi

		# Verificar que las variables sean números válidos
		if ! [[ "$num_archivos" =~ ^[0-9]+$ ]]; then
			echo "Error: num_archivos no es un número válido."
			exit 1
		fi
		if ! [[ "$num_lineas" =~ ^[0-9]+$ ]]; then
			echo "Error: num_lineas no es un número válido."
			exit 1
		fi

		# Comparar y actualizar solo si hay cambios
		if [ "$num_archivos" -ne "$num_lineas" ]; then
			# Actualizar el PlaylistM3u
			find $RUTA_MUSICA -type f \( -name "*.m4a" -o -name "*.mp4" -o -name "*.ogg" -o -name "*.mp3" -o -name "*.aac" \) | sort > "$PlaylistM3u"
			echo "{ \"command\": [\"loadfile\", \"$PlaylistM3u\", \"replace\"] }"| socat - /tmp/mpvsocket
			echo "show-text \"Se actualizó el playlist, tienes $num_archivos archivos\"" | socat - /tmp/mpvsocket
		else
			echo "show-text \"No hay cambios en tu playlist, \ntienes ${num_archivos} archivos\"" | socat - /tmp/mpvsocket
		fi
		rm -f /tmp/btnFn /tmp/btnY
    fi
	
	#Mostrar Bateria y Hora
	if [ -e /tmp/btnFn ] && [ -e /tmp/btnS2Abajo ] && pgrep -f "mpv" > /dev/null; then
        #echo 'key p' | socat - /tmp/mpvsocket
		echo 'show-text "${osd-ass-cc/0}{\\fscx200\\fscy200}\n\n\n\n\n\n\n\n${clock}      ⚡'$(cat /sys/class/power_supply/battery/capacity)'%{\\fscx100\\fscy100\\an5}"' | socat - /tmp/mpvsocket
        rm -f /tmp/btnFn /tmp/btnS2Abajo
    fi
	
	#Navegar arriba IPTV
	if [ -e /tmp/btnS2Arriba ] && ( pgrep -f "IPTV.sh" > /dev/null || pgrep -f "movies.sh" > /dev/null); then
		#echo 'key p' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "p"] }' | socat - /tmp/mpvsocket
		#sleep 0.3
		#echo 'key UP' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "U"] }' | socat - /tmp/mpvsocket
		rm -f /tmp/btnS2Arriba
	fi
	
	#Navegar abajo IPTV
	if [ -e /tmp/btnS2Abajo ] && ( pgrep -f "IPTV.sh" > /dev/null || pgrep -f "movies.sh" > /dev/null); then
		#echo 'key p' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "p"] }' | socat - /tmp/mpvsocket
		#sleep 0.3
		#echo 'key DOWN' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "D"] }' | socat - /tmp/mpvsocket
		rm -f /tmp/btnS2Abajo
	fi

	#Navegar Izquierda IPTV
	if [ -e /tmp/btnS2Izq ]&& ( pgrep -f "IPTV.sh" > /dev/null || pgrep -f "movies.sh" > /dev/null); then
		#echo 'key LEFT' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "LEFT"] }' | socat - /tmp/mpvsocket
        rm -f /tmp/btnS2Izq
    fi

	#Navegar Derecha IPTV
	if [ -e /tmp/btnS2Der ]&& ( pgrep -f "IPTV.sh" > /dev/null || pgrep -f "movies.sh" > /dev/null); then
		#echo 'key RIGHT' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "RIGHT"] }' | socat - /tmp/mpvsocket
        rm -f /tmp/btnS2Der
    fi
	
	#Enter IPTV
	if [ -e /tmp/btnStick2 ]&& ( pgrep -f "IPTV.sh" > /dev/null || pgrep -f "movies.sh" > /dev/null); then
		#echo 'key ENTER' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "ENTER"] }' | socat - /tmp/mpvsocket
        rm -f /tmp/btnStick2
    fi
	
	#Navegar arriba Musica
	if [ -e /tmp/btnS2Arriba ] && [ "$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)" -gt 0 ] && pgrep -f "Musica_Play_Player.sh" > /dev/null; then
		#echo 'key p' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "p"] }' | socat - /tmp/mpvsocket
		#sleep 0.3
		#echo 'key UP' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "U"] }' | socat - /tmp/mpvsocket
		rm -f /tmp/btnS2Arriba
	fi
	
	#Navegar abajo Musica
	if [ -e /tmp/btnS2Abajo ] && [ "$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)" -gt 0 ] && pgrep -f "Musica_Play_Player.sh" > /dev/null; then
		#echo 'key p' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "p"] }' | socat - /tmp/mpvsocket
		#sleep 0.3
		#echo 'key DOWN' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "D"] }' | socat - /tmp/mpvsocket
		rm -f /tmp/btnS2Abajo
	fi

	#Navegar Izquierda Musica
	if [ -e /tmp/btnS2Izq ] && [ "$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)" -gt 0 ] && pgrep -f "Musica_Play_Player.sh" > /dev/null; then
		#echo 'key LEFT' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "LEFT"] }' | socat - /tmp/mpvsocket
        rm -f /tmp/btnS2Izq
    fi

	#Navegar Derecha Musica
	if [ -e /tmp/btnS2Der ] && [ "$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)" -gt 0 ] && pgrep -f "Musica_Play_Player.sh" > /dev/null; then
		#echo 'key RIGHT' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "RIGHT"] }' | socat - /tmp/mpvsocket
        rm -f /tmp/btnS2Der
    fi
	
	#Enter Musica
	if [ -e /tmp/btnStick2 ]&& pgrep -f "Musica_Play_Player.sh" > /dev/null; then
		#echo 'key p' | socat - /tmp/mpvsocket
		#echo '{ "command": ["keypress", "p"] }' | socat - /tmp/mpvsocket
        #echo 'key ENTER' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "ENTER"] }' | socat - /tmp/mpvsocket
        rm -f /tmp/btnStick2
    fi

	#Activar Letras de canciones.
	if [ -e /tmp/btnFn ] && [ -e /tmp/btnR1 ] && pgrep -f "Musica_Play_Player.sh" > /dev/null; then
        #echo 'key Alt+r' | socat - /tmp/mpvsocket
		echo '{ "command": ["keypress", "Alt+r"] }' | socat - /tmp/mpvsocket
        rm -f /tmp/btnFn /tmp/btnR1
    fi
	
    # Mas... mas...
done

#rm -f rm -f /tmp/btn* /tmp/exit