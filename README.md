一键部署Openshift 3.11
#### 可配置项：
查看config.yml文件

    CHANGEREPO: true
    HOSTNAME: os311.test.it.example.com

    Change_Base_Registry: false
    Harbor_Url: harbor.apps.it.example.com

    FULL_INSTALL: false
    SAMPLE_TEMPLATES: true

    CICD_INSTALL: false

    PV_COUNT: 20
说明:
- CHANGEREPO: 是否使用files/all.repo替换系统默认repo源
- HOSTNAME：安装Openshift的主机的hostname，也是集群的访问域名
- Change_Base_Registry：是否使用私有镜像仓库
- Harbor_Url：私有镜像仓库地址，Change_Base_Registry为True时有效
- FULL_INSTALL：是否全量安装（包括日志，监控等）
- SAMPLE_TEMPLATES: 是否安装Openshift默认的模板
- CICD_INSTALL: 是否安装CICD应用工具链
- PV_COUNT: 自动创建NFS目录及创建PV的数量

安装步骤如下：
#### 1. 准备一台主机/虚拟机(CentOS 7.4以上, CPU > 2core, Memory > 4G)

#### 2. 将一键部署脚本拷贝到主机上

#### 3. cd到openshift-oneclick-allinone目录
    
    cd openshift-oneclick-allinone
    
#### 4. 运行部署(必须切到root账号)

    sudo su
    /bin/bash deploy_openshift.sh
    
#### 5. 本地绑定hosts
    <ip> os311.test.it.example.com
#### 6. 浏览器访问
    https://os311.test.it.example.com:8443

