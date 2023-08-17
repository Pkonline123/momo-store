# Momo Store aka Пельменная №2

<img width="900" alt="image" src="https://user-images.githubusercontent.com/9394918/167876466-2c530828-d658-4efe-9064-825626cc6db5.png">

## Frontend

```bash
npm install
NODE_ENV=production VUE_APP_API_URL=http://localhost:8081 npm run serve
```

## Backend

```bash
go run ./cmd/api
go test -v ./... 
```

## CI/CD

- используется единый репозиторий
- развертывание приложение осуществляется с использованием [Downstream pipeline]
- при изменениях в соответствующих директориях триггерятся pipeline для backend, frontend и helm

## Versioning

- [SemVer 2.0.0]
- мажорные и минорные версии приложения изменяются вручную в файлах `backend/.gitlab-ci.yaml` и `frontend/.gitlab-ci.yaml` в переменной `VERSION`
- патч-версии изменяются автоматически на основе переменной `CI_PIPELINE_ID`
- для инфраструктуры версия приложения изменяется вручную в чарте `helm/Chart.yaml`

## Init kubernetes

- клонировать репозиторий на машину с установленным terraform
- через консоль Yandex Cloud создать сервисный аккаунт с ролью `editor`, получить статический ключ доступа, сохранить секретный ключ в файле `terraform/backend.tfvars`
- получить [iam-token](https://cloud.yandex.ru/docs/iam/operations/iam-token/create), сохранить в файле `terraform/secret.tfvars`
- через консоль Yandex Cloud создать Object Storage, внести параметры подключения в файл `terraform/provider.tf`
- выполнить следующие комманды:

```
cd terraform
terraform init
terraform apply
```

## Init production

```
# создаем базовый namespace
kubectl create namespace momo-store

# устанавливаем cert-manager и ингресс контролер согласно инструкции
https://cloud.yandex.ru/docs/managed-kubernetes/tutorials/ingress-cert-manager?from=int-console-help-center-or-nav

# сохраняем креды для docker-registry
kubectl create secret generic -n momo-store docker-config-secret --from-file=.dockerconfigjson="/home/user/.docker/config.json" --type=kubernetes.io/dockerconfigjson 
# устанавливаем приложение, указав версии backend и frontend
helm dependency build
helm upgrade --install --atomic -n momo-store momo-store .

# смотрим IP load balancer, прописываем А-записи для приложения и мониторинга
kubectl get svc
```

## Monitoring

- [Пельмени](https://momo-store-std-013-20.ru)
- [Метрики](https://grafana.momo-store-std-013-20.ru)
- admin / prom-operator
- включен в состав helm-chart приложения, зависимости прописаны в `helm/Chart.yaml`