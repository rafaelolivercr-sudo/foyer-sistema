#!/usr/bin/env bash
set -euo pipefail

OUTFILE="${1:-htpasswd}"
USER="${2:-admin}"

echo "Gerando htpasswd em: $OUTFILE (usuário: $USER)"

read -s -p "Senha: " PASS1
echo
read -s -p "Confirme a senha: " PASS2
echo

if [[ "$PASS1" != "$PASS2" ]]; then
  echo "As senhas não coincidem." >&2
  exit 1
fi

if command -v htpasswd >/dev/null 2>&1; then
  if [[ -f "$OUTFILE" ]]; then
    echo "$PASS1" | htpasswd -B -i "$OUTFILE" "$USER"
  else
    echo "$PASS1" | htpasswd -cB -i "$OUTFILE" "$USER"
  fi
  echo "Arquivo $OUTFILE gerado usando htpasswd local."
  exit 0
fi

if command -v docker >/dev/null 2>&1; then
  echo "htpasswd não encontrado localmente — usando imagem Docker 'httpd:2.4' como fallback."
  # usa stdin para passar senha duas vezes e retorna o conteúdo do arquivo
  if docker run --rm -i httpd:2.4 sh -c "htpasswd -B -i /tmp/htpasswd $USER && cat /tmp/htpasswd" >"$OUTFILE" <<EOF
$PASS1
$PASS2
EOF
  then
    echo "Arquivo $OUTFILE gerado via Docker."
    exit 0
  else
    echo "Falha ao gerar htpasswd via Docker." >&2
    exit 2
  fi
fi

echo "Nem 'htpasswd' nem 'docker' estão disponíveis. Instale apache2-utils (ou httpd-tools) ou o Docker." >&2
exit 3
