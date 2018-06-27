一键部署Openshift 3.9
#### 可配置项：
查看config.yml文件

    CHANGEREPO: true
    HOSTNAME: os39.test.it.example.com

    Change_Base_Registry: false
    Harbor_Url: harbor.apps.it.example.com

    FULL_INSTALL: false
说明:
- CHANGEREPO: 是否使用files/all.repo替换系统默认repo源
- HOSTNAME：安装Openshift的主机的hostname，也是集群的访问域名
- Change_Base_Registry：是否使用私有镜像仓库
- Harbor_Url：私有镜像仓库地址，Change_Base_Registry为True时有效
- FULL_INSTALL：是否全量安装（包括日志，监控等）

安装步骤如下：
#### 1. 准备一台主机/虚拟机(CentOS 7.4以上, CPU > 2core, Memory > 4G)

#### 2. 将一键部署脚本拷贝到主机上

#### 3. cd到openshift-oneclick-allinone目录
    
    cd openshift-oneclick-allinone
    
#### 4. 运行部署
    
    /bin/bash deploy_openshift.sh
    
#### 5. 本地绑定hosts
    <ip> os39.test.it.example.com
#### 6. 浏览器访问
    https://os39.test.it.example.com:8443
