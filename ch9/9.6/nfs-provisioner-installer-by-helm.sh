# Main Source - https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner
# path already provided by ch5 
# default storageClass.name is nfs-client 

helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=192.168.1.10 \
    --set nfs.path=/nfs_shared/dynamic-vol \
    --set storageClass.name=managed-nfs-storage
