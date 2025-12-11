#!/bin/bash
# Reproducir todos los videos en /roms2/movies/ (y subcarpetas) con MPV
# Maneja espacios y caracteres especiales en nombres de archivo.

set -euo pipefail

get_rom_root() {
    if [ -d "/roms2" ] && [ "$(ls -A /roms2 2>/dev/null)" ]; then
        # Existe y no está vacía → la tomamos como ruta de ROMs
        echo "/roms2"
    else
        # De lo contrario, asumimos /roms
        echo "/roms"
    fi
}

ROM_ROOT="$(get_rom_root)"

CARPETA="$ROM_ROOT/movies"
REQUIRED_PACKAGES=("socat" "pulseaudio")
CRON_LINE="@reboot $ROM_ROOT/tools/Botones.sh"

# Verifica conexión a internet
check_internet() {
    if ping -c 1 8.8.8.8 &>/dev/null || ping -c 1 1.1.1.1 &>/dev/null; then
        echo "[√] Conexión a internet disponible."
        return 0
    else
        echo "[X] No hay conexión a internet. No se puede continuar con la instalación."
		sleep 2
        return 1
    fi
}

add_cron_job() {
    (crontab -l 2>/dev/null | grep -F "$CRON_LINE" >/dev/null) ||
{
    echo "[√] Agregando entrada al crontab..."
    (crontab -l 2>/dev/null; echo "$CRON_LINE") | crontab -
    echo "[√] Entrada al crontab agregada, reiniciando el dispositivo"
    sleep 5
    reboot
}
}

install_packages() {
    for package in "${REQUIRED_PACKAGES[@]}"; do
        if ! command -v "$package" &>/dev/null; then
            echo "⚠ El paquete '$package' no está instalado. Instalando..."

            if check_internet; then
                # Ojo: el fallo lo manejamos con `if ! ...`
                if ! sudo apt update || ! sudo apt install -y "$package"; then
                    echo "[X] No se pudo instalar '$package'. Continuando de todos modos."
                fi
            else
                echo "[X] Sin internet, no se puede instalar '$package'."
            fi
        else
            echo "[√] '$package'"
        fi
    done
}

install_mpv() {
    if ! command -v mpv &>/dev/null; then
        echo "⚠ El paquete 'mpv' no está instalado. Instalando..."

        if check_internet; then
            if ! sudo apt update || ! sudo apt install -y mpv --no-install-recommends; then
                echo "[X] No se pudo instalar 'mpv'."
            fi
        else
            echo "[X] Sin internet, no se puede instalar 'mpv'."
        fi
    fi
}

install_scripts() {
    cd ~
    curl -L "https://codeload.github.com/kemazon/R36SMoviePlayer/zip/refs/heads/main" -o R36SMoviePlayer.zip
	unzip -o R36SMoviePlayer.zip
	cd R36SMoviePlayer-main
	sudo cp -r . /
    sudo chmod +x /usr/bin/mpv
    mv /home/ark/Botones.sh $ROM_ROOT/tools/Botones.sh
    mv /home/ark/movies.sh $ROM_ROOT/tools/movies.sh
}

check_and_download_zip() {
    local ZIP_URL="https://codeload.github.com/kemazon/R36SMoviePlayer/zip/refs/heads/main"
    local LOCAL_ZIP="$HOME/R36SMoviePlayer.zip"
    local NEW_ZIP="/tmp/R36SMoviePlayer_new.zip"
    local HASH_FILE="$HOME/R36SMoviePlayer.sha256"
    local NEW_HASH
    local OLD_HASH

    echo "⬇ Buscando actualización..."

    # Primero: ¿hay internet?
    if ! check_internet; then
        echo "[!] Sin internet, se omite la comprobación de actualización."
        return 0
    fi

    # Segundo: intentar descargar. Si falla, no matamos el script.
    if ! curl -sL "$ZIP_URL" -o "$NEW_ZIP"; then
        echo "[X] No se pudo descargar el ZIP. Continuando sin actualizar."
        [ -f "$NEW_ZIP" ] && rm -f "$NEW_ZIP"
        return 0
    fi

    # Tercero: calcular hash del ZIP nuevo
    NEW_HASH=$(sha256sum "$NEW_ZIP" | awk '{print $1}')

    # Si ya tenemos un hash previo, comparar
    if [[ -f "$HASH_FILE" ]]; then
        OLD_HASH=$(cat "$HASH_FILE")

        if [[ "$NEW_HASH" == "$OLD_HASH" ]]; then
            echo "✔ No hay actualizaciones disponibles."
            rm -f "$NEW_ZIP"
            return 0
        fi
    fi

    # Si llegamos aquí, hay versión nueva
    echo "⬆ Nueva versión detectada, instalando..."
    echo "$NEW_HASH" > "$HASH_FILE"
    mv "$NEW_ZIP" "$LOCAL_ZIP"
    install_scripts

    return 0
}


install_packages
install_mpv
check_and_download_zip
add_cron_job

# Extensiones admitidas (insensible a mayúsculas)
PATTERN='.*\.\(mp4\|mov\|avi\|mkv\|wmv\|flv\|webm\|m4v\)$'

# Creamos una lista...
mapfile -d '' VIDEOS < <(find "$CARPETA" -type f -iregex "$PATTERN" -print0 | sort -z)

if (( ${#VIDEOS[@]} == 0 )); then
  echo "No se encontraron videos en $CARPETA."
  exit 1
fi

echo "Se encontraron ${#VIDEOS[@]} videos. Iniciando reproducción…"

# Reproducir (aleatorio, bucle infinito, pantalla completa)
#mpv --save-position-on-quit=yes --resume-playback --fs "${VIDEOS[@]}"
mpv --osd-status-msg="" --input-conf=<(echo 'm script-binding osc/visibility') --script=<(echo 'mp.add_key_binding(nil, "PLAY", function() mp.command("cycle pause") end))
mp.add_key_binding(nil, "PlayCD", function() mp.command("cycle pause") end)') \
--ao=pulse --osd-font='Century Schoolbook' --sub-color='#ffff01' --sub-shadow-offset=10 --sub-visibility=yes --sub-shadow-color='#0f0300' --sub-bold=yes --sub-font-size=60 --sub-pos=60 --save-position-on-quit=yes --resume-playback --fs --osd-level=2 --osd-color="#05fcba" --osd-duration=5000 --osd-font-size=40.000 --osd-italic=yes --osd-scale=1.300 --osd-shadow-color="#000000" --osd-shadow-offset=8.000 --player-operation-mode=cplayer --geometry=640x480 --autofit=640x480 --image-display-duration=inf --video-unscaled=yes --video-aspect=-1 --volume-max=100.000 --cache=no --demuxer-thread=no --hr-seek=no --vd-lavc-threads=1 --hwdec=no --really-quiet --untimed "${VIDEOS[@]}" --input-ipc-server=/tmp/mpvsocket
