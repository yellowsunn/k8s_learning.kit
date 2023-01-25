#!/usr/bin/env bash

# init kubernetes 
kubeadm init --token 123456.1234567890123456 --token-ttl 0 \
--pod-network-cidr=172.16.0.0/16 --apiserver-advertise-address=192.168.2.10

# config for master node only 
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# raw_address for gitcontent
raw_git="raw.githubusercontent.com/yellowsunn/IaC/master/yellowsunn/manifests"
bin_path="/usr/local/bin"

# config for kubernetes's network 
kubectl apply -f https://$raw_git/172.16_net_calico_v3.25.0.yaml

# config metallb for LoadBalancer service
kubectl apply -f https://$raw_git/metallb-0.12.1.yaml

# create configmap for metallb (192.168.2.11 - 60)
kubectl apply -f https://$raw_git/metallb-l2config.yaml

# create secret for metallb 
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

# install helm
curl -0L https://get.helm.sh/helm-v3.11.0-linux-amd64.tar.gz > helm-v3.11.0-linux-amd64.tar.gz
tar xvfz helm-v3.11.0-linux-amd64.tar.gz
mv linux-amd64/helm $bin_path/.

# install metrics-server:3.8.3 by helm
$bin_path/helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
$bin_path/helm repo update
$bin_path/helm install metrics-server metrics-server/metrics-server \
    --create-namespace \
    --namespace=kube-system \
    --set hostNetwork.enabled=true \
    --set args={--kubelet-insecure-tls} \
    --version 3.8.3

# install bash-completion for kubectl 
yum install bash-completion -y 

# kubectl completion on bash-completion dir
kubectl completion bash >/etc/bash_completion.d/kubectl

# alias kubectl to k 
echo 'alias k=kubectl' >> ~/.bashrc
echo "alias ka='kubectl apply -f'" >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc

# git clone k8s-code
git clone https://github.com/sysnet4admin/_Lecture_k8s_learning.kit.git
mv /home/vagrant/_Lecture_k8s_learning.kit $HOME
find $HOME/_Lecture_k8s_learning.kit -regex ".*\.\(sh\)" -exec chmod 700 {} \;

# make rerepo-k8s-learning.kit and put permission
cat <<EOF > /usr/local/bin/rerepo-k8s-learning.kit
#!/usr/bin/env bash
rm -rf $HOME/_Lecture_k8s_learning.kit 
git clone https://github.com/sysnet4admin/_Lecture_k8s_learning.kit.git $HOME/_Lecture_k8s_learning.kit
find $HOME/_Lecture_k8s_learning.kit -regex ".*\.\(sh\)" -exec chmod 700 {} \;
EOF
chmod 700 /usr/local/bin/rerepo-k8s-learning.kit
