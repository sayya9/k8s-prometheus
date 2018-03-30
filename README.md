# k8s-prometheus

Prometheus 是使用 Golang 開發的開源監控系統，被人稱為下一代監控系統，是為數不多的適合 Docker、Mesos 、Kubernetes 環境的監控系統之一 。通常與
Grafana互相搭配使用。

Prometheus + Grafana 監控系統的組合中，前者負責採樣數據並存儲這些數據；後者則側重於形象生動的展示數據。

該 repository 使用 [kubernetes](https://kubernetes.io) + [helm](https://helm.sh/) + [prometheus](https://prometheus.io/)部署！

# Overview
![prometheus](https://prometheus.io/assets/architecture.svg)

INSTALL
=======
在pvc部分是存放prometheus的metrics相關的檔案，此例使用ceph rbd，請自行更換或是使用hostpath

```
git clone https://github.com/sayya9/k8s-prometheus.git
cd k8s-prometheus/helm/prometheus
helm install -n your_release_name --namespace=your_namespace --set=slackApiUrl=https://hooks.slack.com/services/your_webhook .
```

prometheus.yml
=======
[prometheus.yml](https://github.com/sayya9/k8s-prometheus/blob/master/helm/prometheus/templates/prometheus-cm.yaml)的部分，
參考官方[example](https://github.com/prometheus/prometheus/blob/master/documentation/examples/prometheus-kubernetes.yml)，
ingress部分，暫時沒用到故先註解。

Slack Setup
=======

前往[incoming webhook integration](https://my.slack.com/services/new/incoming-webhook)登入你的 workspace，選擇要發送alert的channel，並創建webhook url。

詳細可以參考：https://www.robustperception.io/using-slack-with-the-alertmanager/

Alert
=======
[alertmanager-cm.yaml](https://github.com/sayya9/k8s-prometheus/blob/master/templates/alertmanager-cm.yaml)的設定參考[官方example](https://github.com/prometheus/alertmanager/blob/master/doc/examples/simple.yml)

該repositroy以設三條rule(filesystem, memory, cpu)，客戶的儲存空間快滿或負荷太重時，發alert到slack的某個channel。

新版格式：(此例version 2.x故為新版格式)

```
groups:
- name: example
  rules:
  - alert: HighErrorRate
    expr: job:request_latency_seconds:mean5m{job="myjob"} > 0.5
    for: 10m
    labels:
      severity: page
    annotations:
      summary: High request latency
```

舊版格式：
```
ALERT <alert name>
  IF <expression>
  [ FOR <duration> ]
  [ LABELS <label set> ]
  [ ANNOTATIONS <label set> ]
```

可使用下面工具轉換
```
promtool update rules alert.rules
```
