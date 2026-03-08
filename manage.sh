#!/bin/bash

# 加载环境变量
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

ACTION=$1

case "$ACTION" in
  up)
    echo "启动服务..."
    docker-compose up -d
    sleep 5
    echo "---------------------------"
    echo "请访问 http://${IP_ADDR4}:${API_PORT} 进行配置"
    echo "默认用户名：admin"
    echo "默认密码：password"
    echo "moon/planet 文件下载链接请在容器日志或配置目录中查看"
    ;;
  down)
    read -p "是否删除数据卷？(y/n): " del_data
    if [[ "$del_data" =~ ^[Yy]$ ]]; then
      docker-compose down -v
      rm -rf ${DATA_PATH}
    else
      docker-compose down
    fi
    ;;
  logs)
    docker-compose logs -f
    ;;
  resetpwd)
    echo "重置密码中..."
    docker exec -it ${CONTAINER_NAME} sh -c 'cp /app/ztncui/src/etc/default.passwd /app/ztncui/src/etc/passwd'
    docker-compose restart
    echo "密码已重置为：password (用户：admin)"
    ;;
  info)
    echo "当前配置信息:"
    echo "IPv4: ${IP_ADDR4}"
    echo "API 端口：${API_PORT}"
    echo "访问地址：http://${IP_ADDR4}:${API_PORT}"
    ;;
  *)
    echo "用法：$0 {up|down|logs|resetpwd|info}"
    echo "  up       : 启动服务"
    echo "  down     : 停止并移除服务"
    echo "  logs     : 查看日志"
    echo "  resetpwd : 重置管理员密码"
    echo "  info     : 查看访问信息"
    exit 1
    ;;
esac
