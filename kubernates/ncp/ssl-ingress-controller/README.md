# NCP 도커 쿠버네티스 기본 사용
ALB-Ingress-Controller 사용하여 쿠버네티스 클러스터 구축합니다.   
Ingress에 이번 예제는 SSL연동관련 어노테이션 설정이 추가되었습니다.

## 1. ABL-Ingress-Controller 설치
XEN 하이퍼 바이저인경우 설치가 필요
```aiignore
kubectl apply -f alb-controller-deployment.yaml
```


## 2. 테스트용 서비스 추가
```aiignore
kubectl apply -f nks-alb-ingress-sample-services.yaml
```

## 3. 호스트 도메인별로 요청을 해당 서비스에 분배하는 Ingress 적용
Ingress를 적용하게 되면 NCP로드밸런서가 생성이 됩니다.   
```aiignore
kubectl apply -f ssl-service-host-ingress.yaml
```

DNS서버에 해당 CNAME 레코드 값을 연동해주면 HTTPS 연결이 가능합니다.   
여기서 NCP의  인증서 번호는 Resource Manager의 nrn에서 확인할 수 있습니다.   
(예: nrn:PUB:CertificateManager::000:Certificate/External/${certificateNo})

### 3.1 리소스 매니저에서 DNS검증
NCP내에서 사용하는 인증서는 등록시 DNS검증을 해야하는데   
등록하려는 도메인 별 CNAME 레코드 네임과 레코드 값을 해당 도메인의 DNS서버에 등록해야합니다.   


