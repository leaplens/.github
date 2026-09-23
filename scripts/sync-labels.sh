#!/usr/bin/env bash
# labels.tsv の定義に合わせて org 内リポジトリのラベルを揃える。
# 既定は dry-run。--apply を付けると実際に作成・更新・削除する。
#
#   scripts/sync-labels.sh                 # 全リポジトリを dry-run
#   scripts/sync-labels.sh --apply         # 全リポジトリに反映
#   scripts/sync-labels.sh --apply repo-a  # 指定リポジトリのみ反映
set -euo pipefail

ORG=leaplens
# 同期対象から外すリポジトリ
EXCLUDE=(demo-repository)

apply=false
if [[ "${1:-}" == "--apply" ]]; then
  apply=true
  shift
fi

cd "$(dirname "$0")/.."

run() {
  if $apply; then "$@"; else echo "  [dry-run] $*"; fi
}

if (($# > 0)); then
  repos=("$@")
else
  repos=()
  while IFS= read -r r; do
    [[ " ${EXCLUDE[*]} " == *" $r "* ]] || repos+=("$r")
  done < <(gh repo list "$ORG" --no-archived --limit 200 --json name --jq '.[].name')
fi

wanted=()
while IFS=$'\t' read -r name _; do
  [[ -z "$name" || "$name" == \#* ]] || wanted+=("$name")
done < labels.tsv

for repo in "${repos[@]}"; do
  echo "== $ORG/$repo"

  # 定義にあるラベルを作成 / 色・説明を更新
  while IFS=$'\t' read -r name color desc; do
    [[ -z "$name" || "$name" == \#* ]] && continue
    run gh label create "$name" -R "$ORG/$repo" --color "$color" --description "$desc" --force
  done < labels.tsv

  # 定義にないラベルを削除 (付与済みの issue / PR があればスキップ)
  while IFS= read -r name; do
    [[ " ${wanted[*]} " == *" $name "* ]] && continue
    used=$(gh issue list -R "$ORG/$repo" --state all --label "$name" --limit 1 --json number --jq length)
    used_pr=$(gh pr list -R "$ORG/$repo" --state all --label "$name" --limit 1 --json number --jq length)
    if ((used + used_pr > 0)); then
      echo "  skip: '$name' は使用中のため削除しない"
      continue
    fi
    run gh label delete "$name" -R "$ORG/$repo" --yes
  done < <(gh label list -R "$ORG/$repo" --limit 200 --json name --jq '.[].name')
done
