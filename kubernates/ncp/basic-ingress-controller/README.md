# NCP 도커 쿠버네티스 기본 사용
ALB-Ingress-Controller 사용하여 쿠버네티스 클러스터 구축 

## 1. ABL-Ingress-Controller 설치
XEN 하이퍼 바이저인경우 설치가 필요
```aiignore
kubectl apply -f [alb-controller-deployment.yaml](alb-controller-deployment.yaml
```


## 2. 테스트용 서비스 추가
```aiignore
kubectl apply -f [nks-alb-ingress-sample-services.yaml](nks-alb-ingress-sample-services.yaml)
```

## 3. Ingress 적용
### 3.1 호스트 도메인별로 요청을 해당 서비스에 분배하는 Ingress 배포
Ingress를 설치하게 되면 NCP로드밸런서가 생성이 되며, DNS서버에 해당 CNAME 레코드 값을 입력해주어야 한다.   
수정이 되면 로드밸런서가 새롭게 만들어진다. 경로 기반 Ingress의 경우에는 수정이 되면 재실행이 될텐데 이 부분에 대한 스터디가 필요할 것 같다.
```aiignore
# Host 기반 Ingress
kubectl apply -f [service-host-ingress.yaml](service-host-ingress.yaml)
```


### 3.2 호스트 도메인별로 요청을 해당 서비스에 분배하는 Ingress 배포
```aiignore
# Host 기반 Ingress
kubectl apply -f [service-path-ingress.yaml](service-path-ingress.yaml)
```
