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

1、选择命名空间和组件类型

进入主菜单后，选择Select Namespaces & Workloads选项，首先选择需要备份的命名空间namespace，默认全部选择，如果部分命名空间不需要备份，可将光标移至该命名空间，按空格键取消勾选，或按空格键再次勾选，确认后按OK进入下一步，选择需要备份的组件类型，默认全部选择，如果部分组件不需要备份，可将光标移至该组件，按空格键取消勾选，或按空格键再次勾选，确认后按OK保存配置，返回主菜单

2、合并备份

进入主菜单后，选择Dump Yamls，会根据之前选择的命名空间和组件类型，在工具运行目录生成名为k8s-yaml-dump的目录，在该目录下对每个命名空间生成二级目录，将命名空间下的组件按照同一组件类型导出为一个yaml文件的方式进行备份。备份过程中会有图形化进度条显示备份进度。同时会在k8s-yaml-dump目录下生成dump.log日志记录备份过程。

备份开始前，如果工具运行目录已存在k8s-yaml-dump，会提示是否覆盖。

如果备份前没有选择命名空间和组件类型，会直接默认导出所有命名空间和组件类型开始备份

3、分离备份

进入主菜单后，选择Dump Yamls Seperated，会根据之前选择的命名空间和组件类型，在工具运行目录生成名为k8s-yaml-dump的目录，在该目录下对每个命名空间生成二级目录，在二级目录中对命名空间下的组件生成三级目录，按照同一组件类型的每一个对象都会单独导出为一个yaml文件的方式进行备份。备份过程中会有图形化进度条显示备份进度。同时会在k8s-yaml-dump目录下生成dump.log日志记录备份过程。

备份开始前，如果工具运行目录已存在k8s-yaml-dump，会提示是否覆盖。

如果备份前没有选择命名空间和组件类型，会直接默认导出所有命名空间和组件类型开始备份

4、yaml文件处理器

进入主菜单后，选择Yaml File Processor进入yaml文件处理器子菜单

注意进行yaml文件处理前需要先使用备份功能导出yaml文件

1）选择Replace Image可对所有文件查找指定image字段值，替换为新值，根据提示先输入查找值，按ok确认，再输入替换值，按ok确认开始替换。替换完成后会显示查找到的文件数Files，已替换文件数Replace和替换失败的文件数Left。同时会在k8s-yaml-dump目录下生成process-image.log日志，记录查找值，替换值和查找到的文件路径名称，替换成功和失败的文件路径名称。

2）选择Replace Image Pull Secret可对所有文件查找指定imagePullSecrets字段值，替换为新值，根据提示先输入查找值，按ok确认，再输入替换值，按ok确认开始替换。替换完成后会显示查找到的文件数Files，已替换文件数Replace和替换失败的文件数Left。同时会在k8s-yaml-dump目录下生成process-imagepullsecret.log日志，记录查找值，替换值和查找到的文件路径名称，替换成功和失败的文件路径名称。

3）选择Replace Api Version可对所有文件apiVersion字段extensions/v1beta1替换为apps/v1

4）选择Process Noisy Info可对所有文件注释clusterIP、resourceVersion、selfLink、uid字段
