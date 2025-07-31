# Laravel Nagoyameshi アプリケーション

このリポジトリは、Terraformで構築されたAWSインフラ（ECS Fargate, ALB, RDS など）にデプロイされる Laravel アプリケーションです。

---

## 🚀 デプロイ方法（Terraform連携）

このプロジェクトは、Terraform構成で作成される CodePipeline により、自動的にデプロイされます。

---

### ✅ 必須手順（Terraform側）

Terraformプロジェクト側の `terraform.tfvars` に、このリポジトリの情報を記入してください：

```hcl
github_owner       = "your-github-username"
github_repo        = "laravel-nagoyameshi"
github_oauth_token = "ghp_XXXXXXXXXXXXXXXXXXXX"
github_branch      = "main"
Terraform を init → plan → apply で実行すると、AWS CodePipeline が作成され、
このリポジトリが自動的にデプロイ対象として取り込まれます。
```

## 🐳 ローカル環境での動作確認
ローカルでの動作確認は以下のコマンドで行えます：

```bash
docker compose up --build
```

これにより、Laravel アプリケーションが .env を使って Docker コンテナ上で起動されます。

※ .env ファイルを事前に作成してください（例：.env.example をコピーして編集）

## 🚀 AWS本番デプロイ用のビルドについて
AWS ECS Fargate への本番デプロイでは、以下のDockerfileを使用します：

```bash
Dockerfile.deploy
```

この Dockerfile.deploy は CodeBuild によって使用され、
ECR イメージをビルド → ECS による Laravel アプリの本番環境起動が行われます。

## 📦 プロジェクト構成
Laravel 10.x

MySQL（Amazon RDS）

SSM Parameter Store による環境変数管理（.env は本番環境では不要）

デプロイは GitHub → CodePipeline → CodeBuild → ECR → ECS の流れ

## 📝 注意事項
本番環境の .env は使用されず、SSM によって環境変数が注入されます

ブランチ名は terraform.tfvars で指定した github_branch に合わせてください

push → CodePipeline → デプロイ の自動化を前提としています