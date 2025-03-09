#!/bin/bash

# 스크립트가 root 권한으로 실행되는지 확인
if [ "$(id -u)" -ne 0 ]; then
  echo "이 스크립트는 root 권한으로 실행되어야 합니다."
  exit 1
fi

echo "✅ 가상화 지원 여부 확인 중..."
if ! grep -E -c '(vmx|svm)' /proc/cpuinfo; then
  echo "❌ 이 시스템은 가상화를 지원하지 않습니다."
  exit 1
else
  echo "✅ 가상화 기술 지원됨."
fi

# 필수 패키지 설치
echo "✅ KVM 및 가상화 관련 패키지 설치 중..."
apt update
apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager ovmf cpu-checker

# libvirt 그룹 확인 후 생성
if ! getent group libvirt; then
  echo "✅ libvirt 그룹 생성 중..."
  groupadd libvirt
fi

# 현재 사용자 그룹 추가
echo "✅ 현재 사용자를 libvirt 및 kvm 그룹에 추가 중..."
usermod -aG libvirt,kvm $(whoami)

# libvirt 서비스 시작 및 활성화
echo "✅ libvirt 서비스 시작 중..."
systemctl enable --now libvirtd || systemctl enable --now virtqemud
systemctl restart libvirtd

# KVM 설치 확인
echo "✅ KVM 설치 확인 중..."
if ! kvm-ok; then
  echo "❌ KVM을 사용할 수 없습니다. BIOS에서 가상화(VT-x/AMD-V)를 활성화하세요."
  exit 1
fi

# Virt-Manager 실행 확인
echo "✅ Virt-Manager 실행 확인 중..."
if ! command -v virt-manager &> /dev/null; then
  echo "❌ Virt-Manager 설치 실패!"
  exit 1
else
  echo "✅ Virt-Manager 설치 완료."
fi

# 스냅샷 기능 사용 가능하도록 설정
echo "✅ 스냅샷 기능 활성화..."
modprobe nbd max_part=8
echo "nbd max_part=8" >> /etc/modules

# 브릿지 네트워크 설정 (자동 구성)
echo "✅ 브릿지 네트워크 설정 중..."
NET_IFACE=$(ip -o -4 route show to default | awk '{print $5}')
cat <<EOF > /etc/netplan/00-installer-config.yaml
network:
  version: 2
  ethernets:
    ${NET_IFACE}:
      dhcp4: no
  bridges:
    br0:
      interfaces: [${NET_IFACE}]
      dhcp4: yes
EOF
netplan apply

# GPU 패스스루 (VFIO) 설정 (선택 사항)
echo "✅ GPU 패스스루 설정 중..."
echo "vfio" >> /etc/modules
echo "vfio_iommu_type1" >> /etc/modules
echo "vfio_pci" >> /etc/modules
echo "vfio_virqfd" >> /etc/modules

update-initramfs -u

echo "✅ 모든 설정이 완료되었습니다! 재부팅 후 적용됩니다."
echo "👉 가상 머신을 만들려면 'virt-manager'를 실행하세요."
echo "👉 고급 기능: 스냅샷 생성 'virsh snapshot-create-as --domain VM_NAME --name SNAPSHOT_NAME'"
echo "👉 GPU 패스스루 사용: 'lspci -nnk | grep -i nvidia' 확인 후 설정 필요"
