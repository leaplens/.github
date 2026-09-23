# コントリビューションガイド

leaplens のリポジトリ共通のガイドです。リポジトリ固有のルールがある場合は、各リポジトリの `CONTRIBUTING.md` / `README.md` を優先してください。

## issue

- バグ報告・機能要望は issue テンプレートから作成してください
- セキュリティに関わる内容は issue にせず [SECURITY.md](SECURITY.md) の手順で報告してください

## ブランチ

- `main` から作業ブランチを切ってください
- ブランチ名の例: `feat/xxx`, `fix/xxx`, `chore/xxx`, `docs/xxx`

## コミット

- 1 コミット 1 目的を心がけてください
- メッセージは [Conventional Commits](https://www.conventionalcommits.org/ja/) 形式を推奨します (例: `fix: ログイン後のリダイレクト先を修正`)

## Pull Request

- `main` 向けに PR を作成し、PR テンプレートを埋めてください
- CI が通っていることを確認してください
- 関連 issue があれば `Closes #123` のようにリンクしてください
