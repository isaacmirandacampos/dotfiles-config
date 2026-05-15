#!/usr/bin/env bash
set -euo pipefail

# Terminal Emulator Benchmark Suite
# Compara throughput, latência e uso de recursos entre terminais.
#
# Uso: ./terminal-benchmark.sh [rounds] [results_dir]
#   rounds:      número de rodadas por teste (default: 3)
#   results_dir: diretório compartilhado para salvar JSONs (default: auto)
#
# IMPORTANTE: Rode FORA do tmux, diretamente em cada terminal.
# Dentro do tmux, o benchmark mede o tmux-server, não o terminal.
#
# Requisitos: python3

ROUNDS="${1:-3}"

# -- Detecta terminal real ----------------------------------------------------

detect_terminal() {
  # Dentro do tmux, TERM_PROGRAM vira "tmux" — inútil para nós
  if [[ -n "${TMUX:-}" ]]; then
    echo "tmux"
    return
  fi

  local term="${TERM_PROGRAM:-unknown}"

  # Normaliza nomes conhecidos
  case "$term" in
    *Alacritty*|*alacritty*) echo "alacritty"; return ;;
    *ghostty*|*Ghostty*)     echo "ghostty"; return ;;
    *kitty*)                 echo "kitty"; return ;;
    *Apple_Terminal*)        echo "terminal-app"; return ;;
    *iTerm*|*iterm*)         echo "iterm2"; return ;;
  esac

  # Fallback: sobe na árvore de processos até achar o terminal
  local pid=$$
  for _ in $(seq 1 10); do
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
    [[ -z "$pid" || "$pid" == "1" || "$pid" == "0" ]] && break
    local comm
    comm=$(ps -o comm= -p "$pid" 2>/dev/null || true)
    case "$comm" in
      *alacritty*) echo "alacritty"; return ;;
      *ghostty*)   echo "ghostty"; return ;;
      *kitty*)     echo "kitty"; return ;;
    esac
  done

  echo "$term"
}

TERMINAL=$(detect_terminal)

# -- Aviso tmux ---------------------------------------------------------------

if [[ "$TERMINAL" == "tmux" ]]; then
  echo ""
  echo "  ⚠  DETECTADO: você está dentro do tmux."
  echo ""
  echo "  Dentro do tmux, este benchmark mede o tmux-server,"
  echo "  NÃO o terminal emulator. Os resultados serão idênticos"
  echo "  em qualquer terminal conectado à mesma sessão."
  echo ""
  echo "  Para benchmark real, rode FORA do tmux:"
  echo "    1. Abra cada terminal sem tmux"
  echo "    2. Rode: ./terminal-benchmark.sh $ROUNDS /tmp/terminal-bench"
  echo "       (use o mesmo diretório nos 3 terminais)"
  echo "    3. Compare: ./terminal-compare.sh /tmp/terminal-bench"
  echo ""
  echo "  Prosseguir mesmo assim? O resultado será rotulado 'tmux'."
  echo "  (Ctrl+C para cancelar, Enter para continuar)"
  read -r
fi

# -- Results dir (compartilhável entre terminais) -----------------------------

if [[ -n "${2:-}" ]]; then
  RESULTS_DIR="$2"
else
  RESULTS_DIR="/tmp/terminal-benchmark-results"
fi
mkdir -p "$RESULTS_DIR"

REPORT_FILE="$RESULTS_DIR/${TERMINAL}.json"

# Avisa se vai sobrescrever
if [[ -f "$REPORT_FILE" ]]; then
  echo "  ℹ  Resultado anterior para '$TERMINAL' será sobrescrito."
fi

echo "============================================"
echo "  Terminal Benchmark — $TERMINAL"
echo "  Rounds: $ROUNDS"
echo "  Results: $RESULTS_DIR"
echo "============================================"
echo ""

# -- Helpers ------------------------------------------------------------------

median() {
  sort -n | awk '{a[NR]=$1} END {print (NR%2==1) ? a[(NR+1)/2] : (a[NR/2]+a[NR/2+1])/2}'
}

avg() {
  awk '{s+=$1; n++} END {if(n>0) printf "%.4f\n", s/n; else print 0}'
}

now_ms() {
  python3 -c "import time; print(f'{time.time()*1000:.3f}')"
}

hr() {
  echo "--------------------------------------------"
}

# -- Gera payloads (reutiliza se já existem) ----------------------------------

PAYLOAD_FILE="$RESULTS_DIR/_payload.txt"
COLOR_PAYLOAD="$RESULTS_DIR/_color_payload.txt"

if [[ ! -f "$PAYLOAD_FILE" ]]; then
  python3 -c "
import string, random
random.seed(42)
chars = string.ascii_letters + string.digits + ' .,-:;!?@#\$%&*()[]{}'
for _ in range(20000):
    print(''.join(random.choices(chars, k=120)))
" > "$PAYLOAD_FILE"
fi

if [[ ! -f "$COLOR_PAYLOAD" ]]; then
  python3 -c "
import random
random.seed(42)
colors = [f'\033[{c}m' for c in range(31, 38)]
reset = '\033[0m'
for i in range(15000):
    parts = []
    for _ in range(10):
        color = random.choice(colors)
        word = ''.join(random.choices('abcdefghijklmnopqrstuvwxyz', k=random.randint(3,12)))
        parts.append(f'{color}{word}{reset}')
    print(' '.join(parts))
" > "$COLOR_PAYLOAD"
fi

PAYLOAD_SIZE=$(wc -c < "$PAYLOAD_FILE" | tr -d ' ')

# -- Test 1: Throughput (saída massiva) ---------------------------------------
echo "[1/5] Throughput — renderização de output grande"
hr
echo "  Payload: 20000 linhas (~${PAYLOAD_SIZE} bytes)"

throughput_times=()
for i in $(seq 1 "$ROUNDS"); do
  t_start=$(now_ms)
  cat "$PAYLOAD_FILE"
  t_end=$(now_ms)
  elapsed=$(python3 -c "print(f'{($t_end - $t_start):.3f}')")
  throughput_times+=("$elapsed")
  echo "  Round $i: ${elapsed}ms"
done

throughput_median=$(printf '%s\n' "${throughput_times[@]}" | median)
throughput_avg=$(printf '%s\n' "${throughput_times[@]}" | avg)
echo "  Mediana: ${throughput_median}ms | Média: ${throughput_avg}ms"
echo ""

# -- Test 2: Throughput com escape sequences (cores ANSI) ---------------------
echo "[2/5] Throughput — output com cores ANSI"
hr

color_times=()
for i in $(seq 1 "$ROUNDS"); do
  t_start=$(now_ms)
  cat "$COLOR_PAYLOAD"
  t_end=$(now_ms)
  elapsed=$(python3 -c "print(f'{($t_end - $t_start):.3f}')")
  color_times+=("$elapsed")
  echo "  Round $i: ${elapsed}ms"
done

color_median=$(printf '%s\n' "${color_times[@]}" | median)
color_avg=$(printf '%s\n' "${color_times[@]}" | avg)
echo "  Mediana: ${color_median}ms | Média: ${color_avg}ms"
echo ""

# -- Test 3: Latência de echo ------------------------------------------------
echo "[3/5] Latência — echo round-trip (${ROUNDS}x100 iterações)"
hr

echo_times=()
for i in $(seq 1 "$((ROUNDS * 100))"); do
  t_start=$(now_ms)
  echo -n "" > /dev/null
  t_end=$(now_ms)
  elapsed=$(python3 -c "print(f'{($t_end - $t_start):.3f}')")
  echo_times+=("$elapsed")
done

echo_median=$(printf '%s\n' "${echo_times[@]}" | median)
echo_avg=$(printf '%s\n' "${echo_times[@]}" | avg)
echo "  ${#echo_times[@]} iterações"
echo "  Mediana: ${echo_median}ms | Média: ${echo_avg}ms"
echo ""

# -- Test 4: Scrollback stress -----------------------------------------------
echo "[4/5] Scrollback — seq 1..50000"
hr

scroll_times=()
for i in $(seq 1 "$ROUNDS"); do
  t_start=$(now_ms)
  seq 1 50000
  t_end=$(now_ms)
  elapsed=$(python3 -c "print(f'{($t_end - $t_start):.3f}')")
  scroll_times+=("$elapsed")
  echo "  Round $i: ${elapsed}ms"
done

scroll_median=$(printf '%s\n' "${scroll_times[@]}" | median)
scroll_avg=$(printf '%s\n' "${scroll_times[@]}" | avg)
echo "  Mediana: ${scroll_median}ms | Média: ${scroll_avg}ms"
echo ""

# -- Test 5: Resource snapshot ------------------------------------------------
echo "[5/5] Resource Usage — snapshot do processo do terminal"
hr

find_terminal_pid() {
  local pids=""
  case "$TERMINAL" in
    alacritty) pids=$(pgrep -x alacritty 2>/dev/null || true) ;;
    ghostty)   pids=$(pgrep -x ghostty 2>/dev/null || true) ;;
    kitty)     pids=$(pgrep -x kitty 2>/dev/null || true) ;;
    *)
      # Sobe na árvore de processos
      local pid=$$
      for _ in $(seq 1 10); do
        pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
        [[ -z "$pid" || "$pid" == "1" || "$pid" == "0" ]] && break
        local comm
        comm=$(ps -o comm= -p "$pid" 2>/dev/null || true)
        case "$comm" in
          *alacritty*|*ghostty*|*kitty*) echo "$pid"; return ;;
        esac
      done
      ;;
  esac
  echo "$pids" | head -1
}

TERM_PID=$(find_terminal_pid)
TMUX_PID=""

# Se estamos no tmux, captura ambos: terminal E tmux-server
if [[ -n "${TMUX:-}" ]]; then
  TMUX_PID=$(echo "$TMUX" | cut -d, -f2)
  # Tenta achar o terminal real mesmo dentro do tmux
  for name in alacritty ghostty kitty; do
    pid=$(pgrep -x "$name" 2>/dev/null | head -1 || true)
    if [[ -n "$pid" ]]; then
      echo "  Terminal real detectado: $name (PID $pid)"
      ps -o pid=,pcpu=,rss=,comm= -p "$pid" 2>/dev/null | while read -r line; do
        echo "    $line"
      done
    fi
  done
  echo ""
  echo "  tmux-server (PID $TMUX_PID):"
  ps -o pid=,pcpu=,rss= -p "$TMUX_PID" 2>/dev/null | while read -r line; do
    echo "    $line"
  done
fi

RSS_MB="N/A"
RESOURCE_IDLE="N/A"
RESOURCE_LOAD="N/A"
CPU_IDLE="N/A"
CPU_LOAD="N/A"

if [[ -n "$TERM_PID" ]]; then
  RESOURCE_IDLE=$(ps -o pid=,pcpu=,rss= -p "$TERM_PID" 2>/dev/null || echo "N/A")
  echo "  PID: $TERM_PID"
  echo "  Idle — $RESOURCE_IDLE"

  # Captura CPU idle
  CPU_IDLE=$(echo "$RESOURCE_IDLE" | awk '{print $2}')

  # Sob carga: renderiza payload e mede recursos durante
  cat "$PAYLOAD_FILE" &>/dev/null &
  CAT_PID=$!
  sleep 0.3
  RESOURCE_LOAD=$(ps -o pid=,pcpu=,rss= -p "$TERM_PID" 2>/dev/null || echo "N/A")
  wait "$CAT_PID" 2>/dev/null || true
  echo "  Load — $RESOURCE_LOAD"
  CPU_LOAD=$(echo "$RESOURCE_LOAD" | awk '{print $2}')

  RSS_KB=$(echo "$RESOURCE_IDLE" | awk '{print $3}')
  RSS_MB=$(python3 -c "print(f'{int(${RSS_KB:-0})/1024:.1f}')" 2>/dev/null || echo "N/A")
  echo "  Memory (idle): ${RSS_MB} MB"
else
  echo "  Não foi possível encontrar o PID do terminal."
  echo "  Dica: se está no tmux, os PIDs de todos os terminais conectados são mostrados acima."
fi

echo ""

# -- Relatório JSON -----------------------------------------------------------
cat > "$REPORT_FILE" <<EOF
{
  "terminal": "$TERMINAL",
  "timestamp": "$(date -Iseconds)",
  "rounds": $ROUNDS,
  "inside_tmux": $([ -n "${TMUX:-}" ] && echo "true" || echo "false"),
  "throughput_plain": {
    "median_ms": $throughput_median,
    "avg_ms": $throughput_avg,
    "all_ms": [$(IFS=,; echo "${throughput_times[*]}")]
  },
  "throughput_ansi": {
    "median_ms": $color_median,
    "avg_ms": $color_avg,
    "all_ms": [$(IFS=,; echo "${color_times[*]}")]
  },
  "echo_latency": {
    "median_ms": $echo_median,
    "avg_ms": $echo_avg,
    "iterations": ${#echo_times[@]}
  },
  "scrollback": {
    "median_ms": $scroll_median,
    "avg_ms": $scroll_avg,
    "all_ms": [$(IFS=,; echo "${scroll_times[*]}")]
  },
  "resources": {
    "memory_mb": "$RSS_MB",
    "cpu_idle": "$CPU_IDLE",
    "cpu_load": "$CPU_LOAD",
    "idle_raw": "$RESOURCE_IDLE",
    "load_raw": "$RESOURCE_LOAD"
  }
}
EOF

echo "============================================"
echo "  RESUMO — $TERMINAL"
echo "============================================"
echo ""
printf "  %-25s %12s %12s\n" "Teste" "Mediana" "Média"
hr
printf "  %-25s %10sms %10sms\n" "Throughput (plain)" "$throughput_median" "$throughput_avg"
printf "  %-25s %10sms %10sms\n" "Throughput (ANSI)" "$color_median" "$color_avg"
printf "  %-25s %10sms %10sms\n" "Echo latency" "$echo_median" "$echo_avg"
printf "  %-25s %10sms %10sms\n" "Scrollback (50k lines)" "$scroll_median" "$scroll_avg"
printf "  %-25s %10s\n" "Memory (idle)" "${RSS_MB} MB"
echo ""
echo "  JSON: $REPORT_FILE"
echo ""
if [[ -n "${TMUX:-}" ]]; then
  echo "  ⚠  Resultado dentro do tmux — throughput/latência"
  echo "     medem o tmux-server, não o terminal."
fi
echo "============================================"
echo "  Rode em cada terminal e compare com:"
echo "  ./terminal-compare.sh $RESULTS_DIR"
echo "============================================"
