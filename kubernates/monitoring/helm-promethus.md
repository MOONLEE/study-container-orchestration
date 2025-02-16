
# 쿠버네티스 모니터링
쿠버네티스 클러스터 모니터링을 위해 프로메테우스 및 그라파나 패키지를 헬름으로 설치합니다.

## Helm
Kubernetes 애플리케이션의 패키지 매니저로서 어플리케이션을 더 쉽게 배포하고 관리 할 수 있다.

### 헬름 CLI 설치
```
brew install helm
# helm version 확인으로 설치 확인
helm version
```

### 쿠버네티스 클러스터 연결 (연결이 안되어 있다면)
```
kubectl config use-context <YOUR_CLUSTER_NAME>
kubectl get nodes
```

### Helm 저장소 추가
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### 프로메테우스 클러스터에 배포
아래 명령어를 통해 설치가 완료되면 그라파나 접속 가이드가 나온다.
```
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace
```

* install prometheus
  * Helm 릴리스 이름을 prometheus로 설정
* prometheus-community/kube-prometheus-stack 
  * Prometheus, Grafana, Alertmanager 포함된 패키지
* --namespace monitoring
  * monitoring 네임스페이스에 배포
* --create-namespace
  * 네임스페이스가 없으면 자동 생성


### Grafana 로그인
* kube-prometheus-stack has been installed. Check its status by running:
```
  kubectl --namespace monitoring get pods -l "release=prometheus"
```
* Get Grafana 'admin' user password by running:
```
  kubectl --namespace monitoring get secrets prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
```
* Access Grafana local instance:
```
  export POD_NAME=$(kubectl --namespace monitoring get pod -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=prometheus" -oname)
  kubectl --namespace monitoring port-forward $POD_NAME 3000
```