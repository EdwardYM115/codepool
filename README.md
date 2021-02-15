# k8s-dump-tool
功能

（一）备份

1、k8s集群所有workload和configmap等组件和配置导出为yaml文件

2、可根据需要选择导出部分命名空间（namespace）的组件

3、可根据需要选择导出workload和配置组件的类型

4、可根据需要选择将同一类型的组件导出为一个yaml文件，或者每个组件对象导出为一个yaml文件

（二）Yaml文件处理

1、替换容器镜像image字段值

2、替换容器镜像拉取令牌imagePullSecrets字段值

3、1.8版本之前（含）集群yaml文件apiVersion字段extensions/v1beta1替换为apps/v1，用于导入1.9及以上版本集群

4、clusterIP、resourceVersion、selfLink、uid字段注释，用于导入新集群时避免报错

环境要求

1、linux发行版系统，已安装awk、sed和grep工具

2、已安装dialog工具（用于生成图形化界面）

   如未安装，centos/RHEL系统可执行sudo yum install dialog -y安装，ubuntu系统可执行sudo apt-get install dialog安装
   
3、系统已安装kubectl客户端，且可以正常连接需要备份的k8s集群

安装

将除README.md外的所有文件下载至待部署环境中的任一新建目录即可

运行

在备份工具所在目录执行sh k8dumptool.sh

操作说明
