


# 클러스터 설정

1. 최초 마스터 노드 설정 
* 초기화
```aiignore
kubeadm init --control-plane-endpoint <LOAD_BALANCER_IP>:6443 --upload-certs

# 초기화 후에는 사용자 설정 한다.
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Network Plugin Install
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```



2. 실행 후 인증키가 출력되고 해당 키로 클러스터 조인 한다.
```aiignore

You can now join any number of control-plane nodes running the following command on each as root:

  kubeadm join <LOAD_BALANCER_IP>:6443 --token <TOKEN> \
        --discovery-token-ca-cert-hash <CA-CERT> \
        --control-plane --certificate-key <CERT-KEY>

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join <LOAD_BALANCER_IP>:6443 --token <TOKEN> \
        --discovery-token-ca-cert-hash <CA-CERT> 


```

3. 클러스터 조인
* 마스터 노드 조인
```aiignore
sudo kubeadm join <LOAD_BALANCER_IP>:6443 --token <TOKEN> \
        --discovery-token-ca-cert-hash <CA-CERT> \
        --control-plane --certificate-key <CERT-KEY>
        
# 사용자 설정
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

* 워커 노드 조인
```aiignore
* 마스터 노드 추가
```aiignore
sudo kubeadm join <LOAD_BALANCER_IP>:6443 --token <TOKEN> \
        --discovery-token-ca-cert-hash <CA-CERT> \
        --control-plane --certificate-key <CERT-KEY>
```



## Trouble Shooting
### VM 실행 후 SSH접속이 안되는 경우
아래의 명령어로 ssh 접속 가상 아이피와 실제 아이피가 동일한지 확인해본다.
```aiignore
vagrant ssh-config ${vm}
``` 

만약 다르다면 해당 vm을 삭제하고 다시 실행한다.
```aiignore
vagrant destroy ${vm}
vagrant up ${vm}
```

### 가상 네트워크 IP 할당 커스텀 
Big Sur이상의 버전에서는 IP할당이 안되고 기본 설정으로 시작해야한다.

