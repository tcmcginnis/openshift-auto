#docker system prune -f --volumes --filter "label!=io.kubernetes.container.name=istio-init"'

docker ps -a --filter exited=0 --format "{{.ID}}\t{{.Names}}"

