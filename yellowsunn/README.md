###  실행하기
>  준비: vagrant, virtualbox 설치
1. 디렉토리 이동 
```sh
cd /yellowsunn/k8s-1-26-1
```

2. Vagrant를 통해 가상머신 이미지 생성
```sh
vagrant up
```

3. 가상 이미지 종료 및 기존 이미지 삭제
```sh
vagrant destroy -f
```
---
### k8s-1-26-1
#### k8s 클러스터 (Virtualbox)
* master-node: 192.168.2.10
* worker-node: 192.168.2.101-192.168.2.103 (3대)
#### Version info
* Vagrant box: [sysnet4admin/CentOS-k8s](https://app.vagrantup.com/sysnet4admin/boxes/CentOS-k8s)
  * OS: CentOS7
* kubernetes version: 1.26.1
  * Calico version: 3.25.0
  * MetalLB version: 0.12.1
  * Helm version: 3.11.0
  * Metrics-Server version: 3.8.3
* Docker version: 20.10.23
* Containerd version: 1.6.15
