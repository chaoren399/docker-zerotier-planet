
git clone https://github.com/chaoren399/docker-zerotier-planet.git
cd docker-zerotier-planet/
git checkout zzy-dockercompose


./deploy.sh


docker pull registry.cn-hangzhou.aliyuncs.com/baimeidashu/bmds:xubiaolin-zerotier-planet-latest

docker tag registry.cn-hangzhou.aliyuncs.com/baimeidashu/bmds:xubiaolin-zerotier-planet-latest xubiaolin/zerotier-planet:latest


主要变更说明
交互逻辑移除：原脚本中的 read_port（端口占用检查）、kernel_check（内核检查）、check_proxy（代理检查）等交互式逻辑在 Docker Compose 模式下需由用户提前确认。
端口检查：请在执行 docker-compose up 前手动确认端口未被占用（可使用 netstat -tunlp 或 lsof -i :端口）。
内核检查：ZeroTier 对内核有要求，请确保宿主机内核版本 >= 5.x（特别是 CentOS 7 用户）。
代理检查：如需更换镜像源，请直接修改 .env 文件中的 DOCKER_IMAGE 变量。
数据持久化：
原脚本使用 $(pwd)/data/zerotier。
Compose 方案中通过 .env 的 DATA_PATH 变量控制，默认为当前目录下的 ./data/zerotier，确保数据不会随容器删除而丢失。
使用方法：
编辑 .env 文件，填入正确的公网 IP 和期望的端口。
赋予脚本执行权限：chmod +x manage.sh。
启动服务：./manage.sh up。
查看状态：./manage.sh info。
重置密码：./manage.sh resetpwd。
这种方式更符合现代容器化运维标准，配置与运行逻辑分离，便于版本控制和批量部署。

