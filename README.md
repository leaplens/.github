# .github

leaplens org 共通の GitHub 設定リポジトリ。

## デフォルトのコミュニティヘルスファイル

自前のファイルを持たないリポジトリに自動で適用される。リポジトリ側に同種のファイルがあればそちらが優先される (`ISSUE_TEMPLATE/` はフォルダ単位で丸ごと置き換わる)。

| ファイル | 内容 |
|---|---|
| `ISSUE_TEMPLATE/` | バグ報告 / 機能要望テンプレート |
| `pull_request_template.md` | PR テンプレート |
| `SECURITY.md` | 脆弱性の報告方法 |
| `CONTRIBUTING.md` | コントリビューションガイド |
| `CODE_OF_CONDUCT.md` | 行動規範 |
| `SUPPORT.md` | 問い合わせ先 |

## org プロフィール

`profile/README.md` が https://github.com/leaplens に表示される。

## 共通アクション

### `actions/setup-pnpm-node`

pnpm + Node.js のセットアップと `pnpm install --frozen-lockfile` をまとめた composite action。

```yaml
steps:
  - uses: actions/checkout@v4
  - uses: leaplens/.github/actions/setup-pnpm-node@main
    # with:
    #   node-version: "20"          # 既定: 20
    #   pnpm-version: ""            # 既定: package.json の packageManager に従う
    #   working-directory: .
    #   install: "true"
```

GitHub Packages (`@leaplens` スコープ) を使う場合は、job 側で `permissions.packages: read` と `env.NODE_AUTH_TOKEN: ${{ secrets.GITHUB_TOKEN }}` を設定する。

## ワークフローテンプレート

`workflow-templates/` に置いたテンプレートは、各リポジトリの Actions → New workflow に表示される。

| テンプレート | 内容 |
|---|---|
| `ci.yml` | pnpm + Node.js の lint / typecheck / test / build。ジョブ名は `ci` で統一 |

## ラベル

org 共通ラベルは `labels.tsv` で定義し、`scripts/sync-labels.sh` で全リポジトリに反映する (既定は dry-run、`--apply` で反映)。

- issue には種類 (`bug` / `enhancement` / `documentation`) を 1 つ付ける
- PR には基本的に手で付けない (種類は Conventional Commits のタイトルで表す)。`breaking` のみ例外
- 重複・見送りはラベルではなく close 理由 (Duplicate / Not planned) で表す
