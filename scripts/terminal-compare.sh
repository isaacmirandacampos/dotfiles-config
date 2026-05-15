#!/usr/bin/env bash
set -euo pipefail

# Compara resultados de benchmark entre terminais.
# Uso: ./terminal-compare.sh [results_dir]
#   Se não informado, procura o diretório mais recente em /tmp/terminal-benchmark-*

if [[ -n "${1:-}" ]]; then
  DIR="$1"
else
  DIR=$(ls -dt /tmp/terminal-benchmark-* 2>/dev/null | head -1)
  if [[ -z "$DIR" ]]; then
    echo "Nenhum resultado encontrado em /tmp/terminal-benchmark-*"
    echo "Rode terminal-benchmark.sh em cada terminal primeiro."
    exit 1
  fi
fi

JSON_FILES=("$DIR"/*.json)
if [[ ${#JSON_FILES[@]} -eq 0 ]]; then
  echo "Nenhum JSON encontrado em $DIR"
  exit 1
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║              COMPARAÇÃO DE TERMINAIS                               ║"
echo "╠══════════════════════════════════════════════════════════════════════╣"
echo ""

# Header
printf "  %-28s" "Métrica"
for f in "${JSON_FILES[@]}"; do
  name=$(python3 -c "import json; print(json.load(open('$f'))['terminal'])")
  printf "%14s" "$name"
done
echo ""
echo "  $(printf '%.0s─' {1..70})"

# Métricas
metrics=(
  "throughput_plain:median_ms:Throughput plain (ms)"
  "throughput_ansi:median_ms:Throughput ANSI (ms)"
  "echo_latency:median_ms:Echo latency (ms)"
  "scrollback:median_ms:Scrollback 50k (ms)"
)

for metric in "${metrics[@]}"; do
  IFS=: read -r section key label <<< "$metric"
  printf "  %-28s" "$label"

  values=()
  for f in "${JSON_FILES[@]}"; do
    val=$(python3 -c "import json; print(json.load(open('$f'))['$section']['$key'])")
    values+=("$val")
    printf "%14s" "$val"
  done

  # Marca o menor valor (melhor)
  min_val=$(printf '%s\n' "${values[@]}" | sort -n | head -1)
  echo -n "  ← "
  for f in "${JSON_FILES[@]}"; do
    val=$(python3 -c "import json; print(json.load(open('$f'))['$section']['$key'])")
    if [[ "$val" == "$min_val" ]]; then
      name=$(python3 -c "import json; print(json.load(open('$f'))['terminal'])")
      echo -n "🏆 $name"
      break
    fi
  done
  echo ""
done

# Memory
printf "  %-28s" "Memory idle (MB)"
for f in "${JSON_FILES[@]}"; do
  val=$(python3 -c "import json; print(json.load(open('$f'))['resources']['memory_mb'])")
  printf "%14s" "$val"
done
echo ""

echo ""
echo "  $(printf '%.0s─' {1..70})"
echo ""

# Diferença percentual entre melhor e pior
echo "  Diferença relativa (melhor vs pior):"
echo ""
for metric in "${metrics[@]}"; do
  IFS=: read -r section key label <<< "$metric"

  values=()
  names=()
  for f in "${JSON_FILES[@]}"; do
    val=$(python3 -c "import json; print(json.load(open('$f'))['$section']['$key'])")
    name=$(python3 -c "import json; print(json.load(open('$f'))['terminal'])")
    values+=("$val")
    names+=("$name")
  done

  best_idx=0
  worst_idx=0
  for i in "${!values[@]}"; do
    if python3 -c "exit(0 if ${values[$i]} < ${values[$best_idx]} else 1)"; then
      best_idx=$i
    fi
    if python3 -c "exit(0 if ${values[$i]} > ${values[$worst_idx]} else 1)"; then
      worst_idx=$i
    fi
  done

  diff_pct=$(python3 -c "
b=${values[$best_idx]}; w=${values[$worst_idx]}
print(f'{((w-b)/b)*100:.1f}' if b > 0 else '0.0')
")

  printf "  %-28s %s é %.1f%% mais rápido que %s\n" "$label" "${names[$best_idx]}" "$diff_pct" "${names[$worst_idx]}"
done

echo ""
echo "╚══════════════════════════════════════════════════════════════════════╝"
echo ""
echo "  Resultados em: $DIR"
echo ""
