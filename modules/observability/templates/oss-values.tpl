prometheus:
  alertmanagerFiles:
    alertmanager.yml:
      global: {}
        # slack_api_url: ''

      receivers:
        - name: default-receiver
      route:
        group_wait: 10s
        group_interval: 1m
        receiver: default-receiver
        repeat_interval: 1h
  serverFiles:
    prometheus.yml:
      scrape_configs:
      - job_name: serviceMonitor/default/promstack-kube-prometheus-alertmanager/0
        honor_timestamps: true
        scrape_interval: 30s
        scrape_timeout: 10s
        metrics_path: /metrics
        scheme: http
        follow_redirects: true
        enable_http2: true
        relabel_configs:
        - source_labels: [job]
          separator: ;
          regex: (.*)
          target_label: __tmp_prometheus_job_name
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_label_app, __meta_kubernetes_service_labelpresent_app]
          separator: ;
          regex: (kube-prometheus-stack-alertmanager);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_release, __meta_kubernetes_service_labelpresent_release]
          separator: ;
          regex: (stackspot-promstack);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_self_monitor, __meta_kubernetes_service_labelpresent_self_monitor]
          separator: ;
          regex: (true);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_port_name]
          separator: ;
          regex: http-web
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Node;(.*)
          target_label: node
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Pod;(.*)
          target_label: pod
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_namespace]
          separator: ;
          regex: (.*)
          target_label: namespace
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: service
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_name]
          separator: ;
          regex: (.*)
          target_label: pod
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_container_name]
          separator: ;
          regex: (.*)
          target_label: container
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: job
          replacement: $${1}
          action: replace
        - separator: ;
          regex: (.*)
          target_label: endpoint
          replacement: http-web
          action: replace
        - source_labels: [__address__]
          separator: ;
          regex: (.*)
          modulus: 1
          target_label: __tmp_hash
          replacement: $1
          action: hashmod
        - source_labels: [__tmp_hash]
          separator: ;
          regex: "0"
          replacement: $1
          action: keep
        kubernetes_sd_configs:
        - role: endpoints
          kubeconfig_file: ""
          follow_redirects: true
          enable_http2: true
      - job_name: serviceMonitor/default/promstack-kube-prometheus-apiserver/0
        honor_timestamps: true
        scrape_interval: 30s
        scrape_timeout: 10s
        metrics_path: /metrics
        scheme: https
        authorization:
          type: Bearer
          credentials_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
          server_name: kubernetes
          insecure_skip_verify: false
        follow_redirects: true
        enable_http2: true
        relabel_configs:
        - source_labels: [job]
          separator: ;
          regex: (.*)
          target_label: __tmp_prometheus_job_name
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_label_component, __meta_kubernetes_service_labelpresent_component]
          separator: ;
          regex: (apiserver);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_provider, __meta_kubernetes_service_labelpresent_provider]
          separator: ;
          regex: (kubernetes);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_port_name]
          separator: ;
          regex: https
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Node;(.*)
          target_label: node
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Pod;(.*)
          target_label: pod
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_namespace]
          separator: ;
          regex: (.*)
          target_label: namespace
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: service
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_name]
          separator: ;
          regex: (.*)
          target_label: pod
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_container_name]
          separator: ;
          regex: (.*)
          target_label: container
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: job
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_service_label_component]
          separator: ;
          regex: (.+)
          target_label: job
          replacement: $${1}
          action: replace
        - separator: ;
          regex: (.*)
          target_label: endpoint
          replacement: https
          action: replace
        - source_labels: [__address__]
          separator: ;
          regex: (.*)
          modulus: 1
          target_label: __tmp_hash
          replacement: $1
          action: hashmod
        - source_labels: [__tmp_hash]
          separator: ;
          regex: "0"
          replacement: $1
          action: keep
        metric_relabel_configs:
        - source_labels: [__name__, le]
          separator: ;
          regex: apiserver_request_duration_seconds_bucket;(0.15|0.2|0.3|0.35|0.4|0.45|0.6|0.7|0.8|0.9|1.25|1.5|1.75|2|3|3.5|4|4.5|6|7|8|9|15|25|40|50)
          replacement: $1
          action: drop
        kubernetes_sd_configs:
        - role: endpoints
          kubeconfig_file: ""
          follow_redirects: true
          enable_http2: true
      - job_name: serviceMonitor/default/promstack-kube-prometheus-coredns/0
        honor_timestamps: true
        scrape_interval: 30s
        scrape_timeout: 10s
        metrics_path: /metrics
        scheme: http
        authorization:
          type: Bearer
          credentials_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        follow_redirects: true
        enable_http2: true
        relabel_configs:
        - source_labels: [job]
          separator: ;
          regex: (.*)
          target_label: __tmp_prometheus_job_name
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_label_app, __meta_kubernetes_service_labelpresent_app]
          separator: ;
          regex: (kube-prometheus-stack-coredns);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_release, __meta_kubernetes_service_labelpresent_release]
          separator: ;
          regex: (stackspot-promstack);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_port_name]
          separator: ;
          regex: http-metrics
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Node;(.*)
          target_label: node
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Pod;(.*)
          target_label: pod
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_namespace]
          separator: ;
          regex: (.*)
          target_label: namespace
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: service
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_name]
          separator: ;
          regex: (.*)
          target_label: pod
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_container_name]
          separator: ;
          regex: (.*)
          target_label: container
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: job
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_service_label_jobLabel]
          separator: ;
          regex: (.+)
          target_label: job
          replacement: $${1}
          action: replace
        - separator: ;
          regex: (.*)
          target_label: endpoint
          replacement: http-metrics
          action: replace
        - source_labels: [__address__]
          separator: ;
          regex: (.*)
          modulus: 1
          target_label: __tmp_hash
          replacement: $1
          action: hashmod
        - source_labels: [__tmp_hash]
          separator: ;
          regex: "0"
          replacement: $1
          action: keep
        kubernetes_sd_configs:
        - role: endpoints
          kubeconfig_file: ""
          follow_redirects: true
          enable_http2: true
      - job_name: serviceMonitor/default/promstack-kube-prometheus-kube-controller-manager/0
        honor_timestamps: true
        scrape_interval: 30s
        scrape_timeout: 10s
        metrics_path: /metrics
        scheme: https
        authorization:
          type: Bearer
          credentials_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
          insecure_skip_verify: true
        follow_redirects: true
        enable_http2: true
        relabel_configs:
        - source_labels: [job]
          separator: ;
          regex: (.*)
          target_label: __tmp_prometheus_job_name
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_label_app, __meta_kubernetes_service_labelpresent_app]
          separator: ;
          regex: (kube-prometheus-stack-kube-controller-manager);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_release, __meta_kubernetes_service_labelpresent_release]
          separator: ;
          regex: (stackspot-promstack);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_port_name]
          separator: ;
          regex: http-metrics
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Node;(.*)
          target_label: node
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Pod;(.*)
          target_label: pod
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_namespace]
          separator: ;
          regex: (.*)
          target_label: namespace
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: service
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_name]
          separator: ;
          regex: (.*)
          target_label: pod
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_container_name]
          separator: ;
          regex: (.*)
          target_label: container
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: job
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_service_label_jobLabel]
          separator: ;
          regex: (.+)
          target_label: job
          replacement: $${1}
          action: replace
        - separator: ;
          regex: (.*)
          target_label: endpoint
          replacement: http-metrics
          action: replace
        - source_labels: [__address__]
          separator: ;
          regex: (.*)
          modulus: 1
          target_label: __tmp_hash
          replacement: $1
          action: hashmod
        - source_labels: [__tmp_hash]
          separator: ;
          regex: "0"
          replacement: $1
          action: keep
        kubernetes_sd_configs:
        - role: endpoints
          kubeconfig_file: ""
          follow_redirects: true
          enable_http2: true
      - job_name: serviceMonitor/default/promstack-kube-prometheus-kube-etcd/0
        honor_timestamps: true
        scrape_interval: 30s
        scrape_timeout: 10s
        metrics_path: /metrics
        scheme: http
        authorization:
          type: Bearer
          credentials_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        follow_redirects: true
        enable_http2: true
        relabel_configs:
        - source_labels: [job]
          separator: ;
          regex: (.*)
          target_label: __tmp_prometheus_job_name
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_label_app, __meta_kubernetes_service_labelpresent_app]
          separator: ;
          regex: (kube-prometheus-stack-kube-etcd);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_release, __meta_kubernetes_service_labelpresent_release]
          separator: ;
          regex: (stackspot-promstack);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_port_name]
          separator: ;
          regex: http-metrics
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Node;(.*)
          target_label: node
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Pod;(.*)
          target_label: pod
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_namespace]
          separator: ;
          regex: (.*)
          target_label: namespace
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: service
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_name]
          separator: ;
          regex: (.*)
          target_label: pod
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_container_name]
          separator: ;
          regex: (.*)
          target_label: container
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: job
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_service_label_jobLabel]
          separator: ;
          regex: (.+)
          target_label: job
          replacement: $${1}
          action: replace
        - separator: ;
          regex: (.*)
          target_label: endpoint
          replacement: http-metrics
          action: replace
        - source_labels: [__address__]
          separator: ;
          regex: (.*)
          modulus: 1
          target_label: __tmp_hash
          replacement: $1
          action: hashmod
        - source_labels: [__tmp_hash]
          separator: ;
          regex: "0"
          replacement: $1
          action: keep
        kubernetes_sd_configs:
        - role: endpoints
          kubeconfig_file: ""
          follow_redirects: true
          enable_http2: true
      - job_name: serviceMonitor/default/promstack-kube-prometheus-kube-proxy/0
        honor_timestamps: true
        scrape_interval: 30s
        scrape_timeout: 10s
        metrics_path: /metrics
        scheme: http
        authorization:
          type: Bearer
          credentials_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        follow_redirects: true
        enable_http2: true
        relabel_configs:
        - source_labels: [job]
          separator: ;
          regex: (.*)
          target_label: __tmp_prometheus_job_name
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_label_app, __meta_kubernetes_service_labelpresent_app]
          separator: ;
          regex: (kube-prometheus-stack-kube-proxy);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_release, __meta_kubernetes_service_labelpresent_release]
          separator: ;
          regex: (stackspot-promstack);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_port_name]
          separator: ;
          regex: http-metrics
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Node;(.*)
          target_label: node
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Pod;(.*)
          target_label: pod
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_namespace]
          separator: ;
          regex: (.*)
          target_label: namespace
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: service
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_name]
          separator: ;
          regex: (.*)
          target_label: pod
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_container_name]
          separator: ;
          regex: (.*)
          target_label: container
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: job
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_service_label_jobLabel]
          separator: ;
          regex: (.+)
          target_label: job
          replacement: $${1}
          action: replace
        - separator: ;
          regex: (.*)
          target_label: endpoint
          replacement: http-metrics
          action: replace
        - source_labels: [__address__]
          separator: ;
          regex: (.*)
          modulus: 1
          target_label: __tmp_hash
          replacement: $1
          action: hashmod
        - source_labels: [__tmp_hash]
          separator: ;
          regex: "0"
          replacement: $1
          action: keep
        kubernetes_sd_configs:
        - role: endpoints
          kubeconfig_file: ""
          follow_redirects: true
          enable_http2: true
      - job_name: serviceMonitor/default/promstack-kube-prometheus-kube-scheduler/0
        honor_timestamps: true
        scrape_interval: 30s
        scrape_timeout: 10s
        metrics_path: /metrics
        scheme: http
        authorization:
          type: Bearer
          credentials_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        follow_redirects: true
        enable_http2: true
        relabel_configs:
        - source_labels: [job]
          separator: ;
          regex: (.*)
          target_label: __tmp_prometheus_job_name
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_label_app, __meta_kubernetes_service_labelpresent_app]
          separator: ;
          regex: (kube-prometheus-stack-kube-scheduler);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_release, __meta_kubernetes_service_labelpresent_release]
          separator: ;
          regex: (stackspot-promstack);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_port_name]
          separator: ;
          regex: http-metrics
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Node;(.*)
          target_label: node
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Pod;(.*)
          target_label: pod
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_namespace]
          separator: ;
          regex: (.*)
          target_label: namespace
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: service
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_name]
          separator: ;
          regex: (.*)
          target_label: pod
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_container_name]
          separator: ;
          regex: (.*)
          target_label: container
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: job
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_service_label_jobLabel]
          separator: ;
          regex: (.+)
          target_label: job
          replacement: $${1}
          action: replace
        - separator: ;
          regex: (.*)
          target_label: endpoint
          replacement: http-metrics
          action: replace
        - source_labels: [__address__]
          separator: ;
          regex: (.*)
          modulus: 1
          target_label: __tmp_hash
          replacement: $1
          action: hashmod
        - source_labels: [__tmp_hash]
          separator: ;
          regex: "0"
          replacement: $1
          action: keep
        kubernetes_sd_configs:
        - role: endpoints
          kubeconfig_file: ""
          follow_redirects: true
          enable_http2: true
      - job_name: serviceMonitor/default/promstack-kube-prometheus-kubelet/0
        honor_labels: true
        honor_timestamps: true
        scrape_interval: 30s
        scrape_timeout: 10s
        metrics_path: /metrics
        scheme: https
        authorization:
          type: Bearer
          credentials_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
          insecure_skip_verify: true
        follow_redirects: true
        enable_http2: true
        relabel_configs:
        - source_labels: [job]
          separator: ;
          regex: (.*)
          target_label: __tmp_prometheus_job_name
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_label_app_kubernetes_io_name, __meta_kubernetes_service_labelpresent_app_kubernetes_io_name]
          separator: ;
          regex: (kubelet);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_k8s_app, __meta_kubernetes_service_labelpresent_k8s_app]
          separator: ;
          regex: (kubelet);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_port_name]
          separator: ;
          regex: https-metrics
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Node;(.*)
          target_label: node
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Pod;(.*)
          target_label: pod
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_namespace]
          separator: ;
          regex: (.*)
          target_label: namespace
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: service
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_name]
          separator: ;
          regex: (.*)
          target_label: pod
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_container_name]
          separator: ;
          regex: (.*)
          target_label: container
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: job
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_service_label_k8s_app]
          separator: ;
          regex: (.+)
          target_label: job
          replacement: $${1}
          action: replace
        - separator: ;
          regex: (.*)
          target_label: endpoint
          replacement: https-metrics
          action: replace
        - source_labels: [__metrics_path__]
          separator: ;
          regex: (.*)
          target_label: metrics_path
          replacement: $1
          action: replace
        - source_labels: [__address__]
          separator: ;
          regex: (.*)
          modulus: 1
          target_label: __tmp_hash
          replacement: $1
          action: hashmod
        - source_labels: [__tmp_hash]
          separator: ;
          regex: "0"
          replacement: $1
          action: keep
        kubernetes_sd_configs:
        - role: endpoints
          kubeconfig_file: ""
          follow_redirects: true
          enable_http2: true
      - job_name: serviceMonitor/default/promstack-kube-prometheus-kubelet/1
        honor_labels: true
        honor_timestamps: true
        scrape_interval: 30s
        scrape_timeout: 10s
        metrics_path: /metrics/cadvisor
        scheme: https
        authorization:
          type: Bearer
          credentials_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
          insecure_skip_verify: true
        follow_redirects: true
        enable_http2: true
        relabel_configs:
        - source_labels: [job]
          separator: ;
          regex: (.*)
          target_label: __tmp_prometheus_job_name
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_label_app_kubernetes_io_name, __meta_kubernetes_service_labelpresent_app_kubernetes_io_name]
          separator: ;
          regex: (kubelet);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_k8s_app, __meta_kubernetes_service_labelpresent_k8s_app]
          separator: ;
          regex: (kubelet);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_port_name]
          separator: ;
          regex: https-metrics
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Node;(.*)
          target_label: node
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Pod;(.*)
          target_label: pod
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_namespace]
          separator: ;
          regex: (.*)
          target_label: namespace
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: service
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_name]
          separator: ;
          regex: (.*)
          target_label: pod
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_container_name]
          separator: ;
          regex: (.*)
          target_label: container
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: job
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_service_label_k8s_app]
          separator: ;
          regex: (.+)
          target_label: job
          replacement: $${1}
          action: replace
        - separator: ;
          regex: (.*)
          target_label: endpoint
          replacement: https-metrics
          action: replace
        - source_labels: [__metrics_path__]
          separator: ;
          regex: (.*)
          target_label: metrics_path
          replacement: $1
          action: replace
        - source_labels: [__address__]
          separator: ;
          regex: (.*)
          modulus: 1
          target_label: __tmp_hash
          replacement: $1
          action: hashmod
        - source_labels: [__tmp_hash]
          separator: ;
          regex: "0"
          replacement: $1
          action: keep
        metric_relabel_configs:
        - source_labels: [__name__]
          separator: ;
          regex: container_cpu_(cfs_throttled_seconds_total|load_average_10s|system_seconds_total|user_seconds_total)
          replacement: $1
          action: drop
        - source_labels: [__name__]
          separator: ;
          regex: container_fs_(io_current|io_time_seconds_total|io_time_weighted_seconds_total|reads_merged_total|sector_reads_total|sector_writes_total|writes_merged_total)
          replacement: $1
          action: drop
        - source_labels: [__name__]
          separator: ;
          regex: container_memory_(mapped_file|swap)
          replacement: $1
          action: drop
        - source_labels: [__name__]
          separator: ;
          regex: container_(file_descriptors|tasks_state|threads_max)
          replacement: $1
          action: drop
        - source_labels: [__name__]
          separator: ;
          regex: container_spec.*
          replacement: $1
          action: drop
        - source_labels: [id, pod]
          separator: ;
          regex: .+;
          replacement: $1
          action: drop
        kubernetes_sd_configs:
        - role: endpoints
          kubeconfig_file: ""
          follow_redirects: true
          enable_http2: true
      - job_name: serviceMonitor/default/promstack-kube-prometheus-kubelet/2
        honor_labels: true
        honor_timestamps: true
        scrape_interval: 30s
        scrape_timeout: 10s
        metrics_path: /metrics/probes
        scheme: https
        authorization:
          type: Bearer
          credentials_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
          insecure_skip_verify: true
        follow_redirects: true
        enable_http2: true
        relabel_configs:
        - source_labels: [job]
          separator: ;
          regex: (.*)
          target_label: __tmp_prometheus_job_name
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_label_app_kubernetes_io_name, __meta_kubernetes_service_labelpresent_app_kubernetes_io_name]
          separator: ;
          regex: (kubelet);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_k8s_app, __meta_kubernetes_service_labelpresent_k8s_app]
          separator: ;
          regex: (kubelet);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_port_name]
          separator: ;
          regex: https-metrics
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Node;(.*)
          target_label: node
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Pod;(.*)
          target_label: pod
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_namespace]
          separator: ;
          regex: (.*)
          target_label: namespace
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: service
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_name]
          separator: ;
          regex: (.*)
          target_label: pod
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_container_name]
          separator: ;
          regex: (.*)
          target_label: container
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: job
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_service_label_k8s_app]
          separator: ;
          regex: (.+)
          target_label: job
          replacement: $${1}
          action: replace
        - separator: ;
          regex: (.*)
          target_label: endpoint
          replacement: https-metrics
          action: replace
        - source_labels: [__metrics_path__]
          separator: ;
          regex: (.*)
          target_label: metrics_path
          replacement: $1
          action: replace
        - source_labels: [__address__]
          separator: ;
          regex: (.*)
          modulus: 1
          target_label: __tmp_hash
          replacement: $1
          action: hashmod
        - source_labels: [__tmp_hash]
          separator: ;
          regex: "0"
          replacement: $1
          action: keep
        kubernetes_sd_configs:
        - role: endpoints
          kubeconfig_file: ""
          follow_redirects: true
          enable_http2: true
      - job_name: kubernetes-nodes-cadvisor
        scheme: https
        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        kubernetes_sd_configs:
        - role: node
        relabel_configs:
        - action: labelmap
          regex: __meta_kubernetes_node_label_(.+)
        - target_label: __address__
          replacement: kubernetes.default.svc:443
        - source_labels: [__meta_kubernetes_node_name]
          regex: (.+)
          target_label: __metrics_path__
          replacement: /api/v1/nodes/$${1}/proxy/metrics/cadvisor
      - job_name: serviceMonitor/default/promstack-kube-prometheus-operator/0
        honor_labels: true
        honor_timestamps: true
        scrape_interval: 30s
        scrape_timeout: 10s
        metrics_path: /metrics
        scheme: https
        tls_config:
          ca_file: /etc/prometheus/certs/secret_default_promstack-kube-prometheus-admission_ca
          server_name: promstack-kube-prometheus-operator
          insecure_skip_verify: false
        follow_redirects: true
        enable_http2: true
        relabel_configs:
        - source_labels: [job]
          separator: ;
          regex: (.*)
          target_label: __tmp_prometheus_job_name
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_label_app, __meta_kubernetes_service_labelpresent_app]
          separator: ;
          regex: (kube-prometheus-stack-operator);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_release, __meta_kubernetes_service_labelpresent_release]
          separator: ;
          regex: (stackspot-promstack);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_port_name]
          separator: ;
          regex: https
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Node;(.*)
          target_label: node
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Pod;(.*)
          target_label: pod
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_namespace]
          separator: ;
          regex: (.*)
          target_label: namespace
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: service
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_name]
          separator: ;
          regex: (.*)
          target_label: pod
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_container_name]
          separator: ;
          regex: (.*)
          target_label: container
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: job
          replacement: $${1}
          action: replace
        - separator: ;
          regex: (.*)
          target_label: endpoint
          replacement: https
          action: replace
        - source_labels: [__address__]
          separator: ;
          regex: (.*)
          modulus: 1
          target_label: __tmp_hash
          replacement: $1
          action: hashmod
        - source_labels: [__tmp_hash]
          separator: ;
          regex: "0"
          replacement: $1
          action: keep
        kubernetes_sd_configs:
        - role: endpoints
          kubeconfig_file: ""
          follow_redirects: true
          enable_http2: true
      - job_name: serviceMonitor/default/promstack-kube-prometheus-prometheus/0
        honor_timestamps: true
        scrape_interval: 30s
        scrape_timeout: 10s
        metrics_path: /metrics
        scheme: http
        follow_redirects: true
        enable_http2: true
        relabel_configs:
        - source_labels: [job]
          separator: ;
          regex: (.*)
          target_label: __tmp_prometheus_job_name
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_label_app, __meta_kubernetes_service_labelpresent_app]
          separator: ;
          regex: (kube-prometheus-stack-prometheus);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_release, __meta_kubernetes_service_labelpresent_release]
          separator: ;
          regex: (stackspot-promstack);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_self_monitor, __meta_kubernetes_service_labelpresent_self_monitor]
          separator: ;
          regex: (true);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_port_name]
          separator: ;
          regex: http-web
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Node;(.*)
          target_label: node
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Pod;(.*)
          target_label: pod
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_namespace]
          separator: ;
          regex: (.*)
          target_label: namespace
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: service
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_name]
          separator: ;
          regex: (.*)
          target_label: pod
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_container_name]
          separator: ;
          regex: (.*)
          target_label: container
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: job
          replacement: $${1}
          action: replace
        - separator: ;
          regex: (.*)
          target_label: endpoint
          replacement: http-web
          action: replace
        - source_labels: [__address__]
          separator: ;
          regex: (.*)
          modulus: 1
          target_label: __tmp_hash
          replacement: $1
          action: hashmod
        - source_labels: [__tmp_hash]
          separator: ;
          regex: "0"
          replacement: $1
          action: keep
        kubernetes_sd_configs:
        - role: endpoints
          kubeconfig_file: ""
          follow_redirects: true
          enable_http2: true
      - job_name: serviceMonitor/default/promstack-kube-state-metrics/0
        honor_labels: true
        honor_timestamps: true
        scrape_interval: 30s
        scrape_timeout: 10s
        metrics_path: /metrics
        scheme: http
        follow_redirects: true
        enable_http2: true
        relabel_configs:
        - source_labels: [job]
          separator: ;
          regex: (.*)
          target_label: __tmp_prometheus_job_name
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_label_app_kubernetes_io_instance, __meta_kubernetes_service_labelpresent_app_kubernetes_io_instance]
          separator: ;
          regex: (stackspot-promstack);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_app_kubernetes_io_name, __meta_kubernetes_service_labelpresent_app_kubernetes_io_name]
          separator: ;
          regex: (kube-state-metrics);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_port_name]
          separator: ;
          regex: http
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Node;(.*)
          target_label: node
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Pod;(.*)
          target_label: pod
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_namespace]
          separator: ;
          regex: (.*)
          target_label: namespace
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: service
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_name]
          separator: ;
          regex: (.*)
          target_label: pod
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_container_name]
          separator: ;
          regex: (.*)
          target_label: container
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: job
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_service_label_app_kubernetes_io_name]
          separator: ;
          regex: (.+)
          target_label: job
          replacement: $${1}
          action: replace
        - separator: ;
          regex: (.*)
          target_label: endpoint
          replacement: http
          action: replace
        - source_labels: [__address__]
          separator: ;
          regex: (.*)
          modulus: 1
          target_label: __tmp_hash
          replacement: $1
          action: hashmod
        - source_labels: [__tmp_hash]
          separator: ;
          regex: "0"
          replacement: $1
          action: keep
        kubernetes_sd_configs:
        - role: endpoints
          kubeconfig_file: ""
          follow_redirects: true
          enable_http2: true
      - job_name: serviceMonitor/default/promstack-prometheus-node-exporter/0
        honor_timestamps: true
        scrape_interval: 30s
        scrape_timeout: 10s
        metrics_path: /metrics
        scheme: http
        follow_redirects: true
        enable_http2: true
        relabel_configs:
        - source_labels: [job]
          separator: ;
          regex: (.*)
          target_label: __tmp_prometheus_job_name
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_label_app_kubernetes_io_instance, __meta_kubernetes_service_labelpresent_app_kubernetes_io_instance]
          separator: ;
          regex: (stackspot-promstack);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_service_label_app_kubernetes_io_name, __meta_kubernetes_service_labelpresent_app_kubernetes_io_name]
          separator: ;
          regex: (prometheus-node-exporter);true
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_port_name]
          separator: ;
          regex: http-metrics
          replacement: $1
          action: keep
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Node;(.*)
          target_label: node
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
          separator: ;
          regex: Pod;(.*)
          target_label: pod
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_namespace]
          separator: ;
          regex: (.*)
          target_label: namespace
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: service
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_name]
          separator: ;
          regex: (.*)
          target_label: pod
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_pod_container_name]
          separator: ;
          regex: (.*)
          target_label: container
          replacement: $1
          action: replace
        - source_labels: [__meta_kubernetes_service_name]
          separator: ;
          regex: (.*)
          target_label: job
          replacement: $${1}
          action: replace
        - source_labels: [__meta_kubernetes_service_label_jobLabel]
          separator: ;
          regex: (.+)
          target_label: job
          replacement: $${1}
          action: replace
        - separator: ;
          regex: (.*)
          target_label: endpoint
          replacement: http-metrics
          action: replace
        - source_labels: [__address__]
          separator: ;
          regex: (.*)
          modulus: 1
          target_label: __tmp_hash
          replacement: $1
          action: hashmod
        - source_labels: [__tmp_hash]
          separator: ;
          regex: "0"
          replacement: $1
          action: keep
        kubernetes_sd_configs:
        - role: endpoints
          kubeconfig_file: ""
          follow_redirects: true
          enable_http2: true
    alerting_rules.yml:
      groups:
      - name: alertmanager.rules
        rules:
        - alert: AlertmanagerFailedReload
          annotations:
            description: Configuration has failed to load for {{ $labels.namespace }}/{{
              $labels.pod}}.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagerfailedreload
            summary: Reloading an Alertmanager configuration has failed.
          expr: |-
            # Without max_over_time, failed scrapes could create false negatives, see
            # https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.
            max_over_time(alertmanager_config_last_reload_successful{job="promstack-kube-prometheus-alertmanager",namespace="default"}[5m]) == 0
          for: 10m
          labels:
            severity: critical
        - alert: AlertmanagerMembersInconsistent
          annotations:
            description: Alertmanager {{ $labels.namespace }}/{{ $labels.pod}} has only
              found {{ $value }} members of the {{$labels.job}} cluster.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagermembersinconsistent
            summary: A member of an Alertmanager cluster has not found all other cluster
              members.
          expr: |-
            # Without max_over_time, failed scrapes could create false negatives, see
            # https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.
              max_over_time(alertmanager_cluster_members{job="promstack-kube-prometheus-alertmanager",namespace="default"}[5m])
            < on (namespace,service) group_left
              count by (namespace,service) (max_over_time(alertmanager_cluster_members{job="promstack-kube-prometheus-alertmanager",namespace="default"}[5m]))
          for: 15m
          labels:
            severity: critical
        - alert: AlertmanagerFailedToSendAlerts
          annotations:
            description: Alertmanager {{ $labels.namespace }}/{{ $labels.pod}} failed to
              send {{ $value | humanizePercentage }} of notifications to {{ $labels.integration
              }}.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagerfailedtosendalerts
            summary: An Alertmanager instance failed to send notifications.
          expr: |-
            (
              rate(alertmanager_notifications_failed_total{job="promstack-kube-prometheus-alertmanager",namespace="default"}[5m])
            /
              rate(alertmanager_notifications_total{job="promstack-kube-prometheus-alertmanager",namespace="default"}[5m])
            )
            > 0.01
          for: 5m
          labels:
            severity: warning
        - alert: AlertmanagerClusterFailedToSendAlerts
          annotations:
            description: The minimum notification failure rate to {{ $labels.integration
              }} sent from any instance in the {{$labels.job}} cluster is {{ $value | humanizePercentage
              }}.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagerclusterfailedtosendalerts
            summary: All Alertmanager instances in a cluster failed to send notifications
              to a critical integration.
          expr: |-
            min by (namespace,service, integration) (
              rate(alertmanager_notifications_failed_total{job="promstack-kube-prometheus-alertmanager",namespace="default", integration=~`.*`}[5m])
            /
              rate(alertmanager_notifications_total{job="promstack-kube-prometheus-alertmanager",namespace="default", integration=~`.*`}[5m])
            )
            > 0.01
          for: 5m
          labels:
            severity: critical
        - alert: AlertmanagerClusterFailedToSendAlerts
          annotations:
            description: The minimum notification failure rate to {{ $labels.integration
              }} sent from any instance in the {{$labels.job}} cluster is {{ $value | humanizePercentage
              }}.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagerclusterfailedtosendalerts
            summary: All Alertmanager instances in a cluster failed to send notifications
              to a non-critical integration.
          expr: |-
            min by (namespace,service, integration) (
              rate(alertmanager_notifications_failed_total{job="promstack-kube-prometheus-alertmanager",namespace="default", integration!~`.*`}[5m])
            /
              rate(alertmanager_notifications_total{job="promstack-kube-prometheus-alertmanager",namespace="default", integration!~`.*`}[5m])
            )
            > 0.01
          for: 5m
          labels:
            severity: warning
        - alert: AlertmanagerConfigInconsistent
          annotations:
            description: Alertmanager instances within the {{$labels.job}} cluster have
              different configurations.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagerconfiginconsistent
            summary: Alertmanager instances within the same cluster have different configurations.
          expr: |-
            count by (namespace,service) (
              count_values by (namespace,service) ("config_hash", alertmanager_config_hash{job="promstack-kube-prometheus-alertmanager",namespace="default"})
            )
            != 1
          for: 20m
          labels:
            severity: critical
        - alert: AlertmanagerClusterDown
          annotations:
            description: '{{ $value | humanizePercentage }} of Alertmanager instances within
              the {{$labels.job}} cluster have been up for less than half of the last 5m.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagerclusterdown
            summary: Half or more of the Alertmanager instances within the same cluster
              are down.
          expr: |-
            (
              count by (namespace,service) (
                avg_over_time(up{job="promstack-kube-prometheus-alertmanager",namespace="default"}[5m]) < 0.5
              )
            /
              count by (namespace,service) (
                up{job="promstack-kube-prometheus-alertmanager",namespace="default"}
              )
            )
            >= 0.5
          for: 5m
          labels:
            severity: critical
        - alert: AlertmanagerClusterCrashlooping
          annotations:
            description: '{{ $value | humanizePercentage }} of Alertmanager instances within
              the {{$labels.job}} cluster have restarted at least 5 times in the last 10m.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/alertmanager/alertmanagerclustercrashlooping
            summary: Half or more of the Alertmanager instances within the same cluster
              are crashlooping.
          expr: |-
            (
              count by (namespace,service) (
                changes(process_start_time_seconds{job="promstack-kube-prometheus-alertmanager",namespace="default"}[10m]) > 4
              )
            /
              count by (namespace,service) (
                up{job="promstack-kube-prometheus-alertmanager",namespace="default"}
              )
            )
            >= 0.5
          for: 5m
          labels:
            severity: critical
      - name: config-reloaders
        rules:
        - alert: ConfigReloaderSidecarErrors
          annotations:
            description: |-
              Errors encountered while the {{$labels.pod}} config-reloader sidecar attempts to sync config in {{$labels.namespace}} namespace.
              As a result, configuration for service running in {{$labels.pod}} may be stale and cannot be updated anymore.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/configreloadersidecarerrors
            summary: config-reloader sidecar has not had a successful reload for 10m
          expr: max_over_time(reloader_last_reload_successful{namespace=~".+"}[5m]) == 0
          for: 10m
          labels:
            severity: warning
      - name: etcd
        rules:
        - alert: etcdMembersDown
          annotations:
            description: 'etcd cluster "{{ $labels.job }}": members are down ({{ $value
              }}).'
            summary: etcd cluster members are down.
          expr: |-
            max without (endpoint) (
              sum without (instance) (up{job=~".*etcd.*"} == bool 0)
            or
              count without (To) (
                sum without (instance) (rate(etcd_network_peer_sent_failures_total{job=~".*etcd.*"}[120s])) > 0.01
              )
            )
            > 0
          for: 10m
          labels:
            severity: critical
        - alert: etcdInsufficientMembers
          annotations:
            description: 'etcd cluster "{{ $labels.job }}": insufficient members ({{ $value
              }}).'
            summary: etcd cluster has insufficient number of members.
          expr: sum(up{job=~".*etcd.*"} == bool 1) without (instance) < ((count(up{job=~".*etcd.*"})
            without (instance) + 1) / 2)
          for: 3m
          labels:
            severity: critical
        - alert: etcdNoLeader
          annotations:
            description: 'etcd cluster "{{ $labels.job }}": member {{ $labels.instance }}
              has no leader.'
            summary: etcd cluster has no leader.
          expr: etcd_server_has_leader{job=~".*etcd.*"} == 0
          for: 1m
          labels:
            severity: critical
        - alert: etcdHighNumberOfLeaderChanges
          annotations:
            description: 'etcd cluster "{{ $labels.job }}": {{ $value }} leader changes
              within the last 15 minutes. Frequent elections may be a sign of insufficient
              resources, high network latency, or disruptions by other components and should
              be investigated.'
            summary: etcd cluster has high number of leader changes.
          expr: increase((max without (instance) (etcd_server_leader_changes_seen_total{job=~".*etcd.*"})
            or 0*absent(etcd_server_leader_changes_seen_total{job=~".*etcd.*"}))[15m:1m])
            >= 4
          for: 5m
          labels:
            severity: warning
        - alert: etcdHighNumberOfFailedGRPCRequests
          annotations:
            description: 'etcd cluster "{{ $labels.job }}": {{ $value }}% of requests for
              {{ $labels.grpc_method }} failed on etcd instance {{ $labels.instance }}.'
            summary: etcd cluster has high number of failed grpc requests.
          expr: |-
            100 * sum(rate(grpc_server_handled_total{job=~".*etcd.*", grpc_code=~"Unknown|FailedPrecondition|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded"}[5m])) without (grpc_type, grpc_code)
              /
            sum(rate(grpc_server_handled_total{job=~".*etcd.*"}[5m])) without (grpc_type, grpc_code)
              > 1
          for: 10m
          labels:
            severity: warning
        - alert: etcdHighNumberOfFailedGRPCRequests
          annotations:
            description: 'etcd cluster "{{ $labels.job }}": {{ $value }}% of requests for
              {{ $labels.grpc_method }} failed on etcd instance {{ $labels.instance }}.'
            summary: etcd cluster has high number of failed grpc requests.
          expr: |-
            100 * sum(rate(grpc_server_handled_total{job=~".*etcd.*", grpc_code=~"Unknown|FailedPrecondition|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded"}[5m])) without (grpc_type, grpc_code)
              /
            sum(rate(grpc_server_handled_total{job=~".*etcd.*"}[5m])) without (grpc_type, grpc_code)
              > 5
          for: 5m
          labels:
            severity: critical
        - alert: etcdGRPCRequestsSlow
          annotations:
            description: 'etcd cluster "{{ $labels.job }}": 99th percentile of gRPC requests
              is {{ $value }}s on etcd instance {{ $labels.instance }} for {{ $labels.grpc_method
              }} method.'
            summary: etcd grpc requests are slow
          expr: |-
            histogram_quantile(0.99, sum(rate(grpc_server_handling_seconds_bucket{job=~".*etcd.*", grpc_method!="Defragment", grpc_type="unary"}[5m])) without(grpc_type))
            > 0.15
          for: 10m
          labels:
            severity: critical
        - alert: etcdMemberCommunicationSlow
          annotations:
            description: 'etcd cluster "{{ $labels.job }}": member communication with {{
              $labels.To }} is taking {{ $value }}s on etcd instance {{ $labels.instance
              }}.'
            summary: etcd cluster member communication is slow.
          expr: |-
            histogram_quantile(0.99, rate(etcd_network_peer_round_trip_time_seconds_bucket{job=~".*etcd.*"}[5m]))
            > 0.15
          for: 10m
          labels:
            severity: warning
        - alert: etcdHighNumberOfFailedProposals
          annotations:
            description: 'etcd cluster "{{ $labels.job }}": {{ $value }} proposal failures
              within the last 30 minutes on etcd instance {{ $labels.instance }}.'
            summary: etcd cluster has high number of proposal failures.
          expr: rate(etcd_server_proposals_failed_total{job=~".*etcd.*"}[15m]) > 5
          for: 15m
          labels:
            severity: warning
        - alert: etcdHighFsyncDurations
          annotations:
            description: 'etcd cluster "{{ $labels.job }}": 99th percentile fsync durations
              are {{ $value }}s on etcd instance {{ $labels.instance }}.'
            summary: etcd cluster 99th percentile fsync durations are too high.
          expr: |-
            histogram_quantile(0.99, rate(etcd_disk_wal_fsync_duration_seconds_bucket{job=~".*etcd.*"}[5m]))
            > 0.5
          for: 10m
          labels:
            severity: warning
        - alert: etcdHighFsyncDurations
          annotations:
            description: 'etcd cluster "{{ $labels.job }}": 99th percentile fsync durations
              are {{ $value }}s on etcd instance {{ $labels.instance }}.'
            summary: etcd cluster 99th percentile fsync durations are too high.
          expr: |-
            histogram_quantile(0.99, rate(etcd_disk_wal_fsync_duration_seconds_bucket{job=~".*etcd.*"}[5m]))
            > 1
          for: 10m
          labels:
            severity: critical
        - alert: etcdHighCommitDurations
          annotations:
            description: 'etcd cluster "{{ $labels.job }}": 99th percentile commit durations
              {{ $value }}s on etcd instance {{ $labels.instance }}.'
            summary: etcd cluster 99th percentile commit durations are too high.
          expr: |-
            histogram_quantile(0.99, rate(etcd_disk_backend_commit_duration_seconds_bucket{job=~".*etcd.*"}[5m]))
            > 0.25
          for: 10m
          labels:
            severity: warning
        - alert: etcdDatabaseQuotaLowSpace
          annotations:
            description: 'etcd cluster "{{ $labels.job }}": database size exceeds the defined
              quota on etcd instance {{ $labels.instance }}, please defrag or increase the
              quota as the writes to etcd will be disabled when it is full.'
            summary: etcd cluster database is running full.
          expr: (last_over_time(etcd_mvcc_db_total_size_in_bytes[5m]) / last_over_time(etcd_server_quota_backend_bytes[5m]))*100
            > 95
          for: 10m
          labels:
            severity: critical
        - alert: etcdExcessiveDatabaseGrowth
          annotations:
            description: 'etcd cluster "{{ $labels.job }}": Predicting running out of disk
              space in the next four hours, based on write observations within the past
              four hours on etcd instance {{ $labels.instance }}, please check as it might
              be disruptive.'
            summary: etcd cluster database growing very fast.
          expr: predict_linear(etcd_mvcc_db_total_size_in_bytes[4h], 4*60*60) > etcd_server_quota_backend_bytes
          for: 10m
          labels:
            severity: warning
        - alert: etcdDatabaseHighFragmentationRatio
          annotations:
            description: 'etcd cluster "{{ $labels.job }}": database size in use on instance
              {{ $labels.instance }} is {{ $value | humanizePercentage }} of the actual
              allocated disk space, please run defragmentation (e.g. etcdctl defrag) to
              retrieve the unused fragmented disk space.'
            runbook_url: https://etcd.io/docs/v3.5/op-guide/maintenance/#defragmentation
            summary: etcd database size in use is less than 50% of the actual allocated
              storage.
          expr: (last_over_time(etcd_mvcc_db_total_size_in_use_in_bytes[5m]) / last_over_time(etcd_mvcc_db_total_size_in_bytes[5m]))
            < 0.5
          for: 10m
          labels:
            severity: warning
      - name: general.rules
        rules:
        - alert: TargetDown
          annotations:
            description: '{{ printf "%.4g" $value }}% of the {{ $labels.job }}/{{ $labels.service
              }} targets in {{ $labels.namespace }} namespace are down.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/general/targetdown
            summary: One or more targets are unreachable.
          expr: 100 * (count(up == 0) BY (job, namespace, service) / count(up) BY (job,
            namespace, service)) > 10
          for: 10m
          labels:
            severity: warning
        - alert: Watchdog
          annotations:
            description: |
              This is an alert meant to ensure that the entire alerting pipeline is functional.
              This alert is always firing, therefore it should always be firing in Alertmanager
              and always fire against a receiver. There are integrations with various notification
              mechanisms that send a notification when this alert is not firing. For example the
              "DeadMansSnitch" integration in PagerDuty.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/general/watchdog
            summary: An alert that should always be firing to certify that Alertmanager
              is working properly.
          expr: vector(1)
          labels:
            severity: none
        - alert: InfoInhibitor
          annotations:
            description: |
              This is an alert that is used to inhibit info alerts.
              By themselves, the info-level alerts are sometimes very noisy, but they are relevant when combined with
              other alerts.
              This alert fires whenever there's a severity="info" alert, and stops firing when another alert with a
              severity of 'warning' or 'critical' starts firing on the same namespace.
              This alert should be routed to a null receiver and configured to inhibit alerts with severity="info".
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/general/infoinhibitor
            summary: Info-level alert inhibition.
          expr: ALERTS{severity = "info"} == 1 unless on(namespace) ALERTS{alertname !=
            "InfoInhibitor", severity =~ "warning|critical", alertstate="firing"} == 1
          labels:
            severity: none
      - name: k8s.rules
        rules:
        - expr: |-
            sum by (cluster, namespace, pod, container) (
              irate(container_cpu_usage_seconds_total{image!=""}[5m])
            ) * on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (
              1, max by(cluster, namespace, pod, node) (kube_pod_info{node!=""})
            )
          record: node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate
        - expr: |-
            container_memory_working_set_bytes{image!=""}
            * on (namespace, pod) group_left(node) topk by(namespace, pod) (1,
              max by(namespace, pod, node) (kube_pod_info{node!=""})
            )
          record: node_namespace_pod_container:container_memory_working_set_bytes
        - expr: |-
            container_memory_rss{image!=""}
            * on (namespace, pod) group_left(node) topk by(namespace, pod) (1,
              max by(namespace, pod, node) (kube_pod_info{node!=""})
            )
          record: node_namespace_pod_container:container_memory_rss
        - expr: |-
            container_memory_cache{image!=""}
            * on (namespace, pod) group_left(node) topk by(namespace, pod) (1,
              max by(namespace, pod, node) (kube_pod_info{node!=""})
            )
          record: node_namespace_pod_container:container_memory_cache
        - expr: |-
            container_memory_swap{image!=""}
            * on (namespace, pod) group_left(node) topk by(namespace, pod) (1,
              max by(namespace, pod, node) (kube_pod_info{node!=""})
            )
          record: node_namespace_pod_container:container_memory_swap
        - expr: |-
            kube_pod_container_resource_requests{resource="memory",job="kube-state-metrics"}  * on (namespace, pod, cluster)
            group_left() max by (namespace, pod, cluster) (
              (kube_pod_status_phase{phase=~"Pending|Running"} == 1)
            )
          record: cluster:namespace:pod_memory:active:kube_pod_container_resource_requests
        - expr: |-
            sum by (namespace, cluster) (
                sum by (namespace, pod, cluster) (
                    max by (namespace, pod, container, cluster) (
                      kube_pod_container_resource_requests{resource="memory",job="kube-state-metrics"}
                    ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (
                      kube_pod_status_phase{phase=~"Pending|Running"} == 1
                    )
                )
            )
          record: namespace_memory:kube_pod_container_resource_requests:sum
        - expr: |-
            kube_pod_container_resource_requests{resource="cpu",job="kube-state-metrics"}  * on (namespace, pod, cluster)
            group_left() max by (namespace, pod, cluster) (
              (kube_pod_status_phase{phase=~"Pending|Running"} == 1)
            )
          record: cluster:namespace:pod_cpu:active:kube_pod_container_resource_requests
        - expr: |-
            sum by (namespace, cluster) (
                sum by (namespace, pod, cluster) (
                    max by (namespace, pod, container, cluster) (
                      kube_pod_container_resource_requests{resource="cpu",job="kube-state-metrics"}
                    ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (
                      kube_pod_status_phase{phase=~"Pending|Running"} == 1
                    )
                )
            )
          record: namespace_cpu:kube_pod_container_resource_requests:sum
        - expr: |-
            kube_pod_container_resource_limits{resource="memory",job="kube-state-metrics"}  * on (namespace, pod, cluster)
            group_left() max by (namespace, pod, cluster) (
              (kube_pod_status_phase{phase=~"Pending|Running"} == 1)
            )
          record: cluster:namespace:pod_memory:active:kube_pod_container_resource_limits
        - expr: |-
            sum by (namespace, cluster) (
                sum by (namespace, pod, cluster) (
                    max by (namespace, pod, container, cluster) (
                      kube_pod_container_resource_limits{resource="memory",job="kube-state-metrics"}
                    ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (
                      kube_pod_status_phase{phase=~"Pending|Running"} == 1
                    )
                )
            )
          record: namespace_memory:kube_pod_container_resource_limits:sum
        - expr: |-
            kube_pod_container_resource_limits{resource="cpu",job="kube-state-metrics"}  * on (namespace, pod, cluster)
            group_left() max by (namespace, pod, cluster) (
            (kube_pod_status_phase{phase=~"Pending|Running"} == 1)
            )
          record: cluster:namespace:pod_cpu:active:kube_pod_container_resource_limits
        - expr: |-
            sum by (namespace, cluster) (
                sum by (namespace, pod, cluster) (
                    max by (namespace, pod, container, cluster) (
                      kube_pod_container_resource_limits{resource="cpu",job="kube-state-metrics"}
                    ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (
                      kube_pod_status_phase{phase=~"Pending|Running"} == 1
                    )
                )
            )
          record: namespace_cpu:kube_pod_container_resource_limits:sum
        - expr: |-
            max by (cluster, namespace, workload, pod) (
              label_replace(
                label_replace(
                  kube_pod_owner{job="kube-state-metrics", owner_kind="ReplicaSet"},
                  "replicaset", "$1", "owner_name", "(.*)"
                ) * on(replicaset, namespace) group_left(owner_name) topk by(replicaset, namespace) (
                  1, max by (replicaset, namespace, owner_name) (
                    kube_replicaset_owner{job="kube-state-metrics"}
                  )
                ),
                "workload", "$1", "owner_name", "(.*)"
              )
            )
          labels:
            workload_type: deployment
          record: namespace_workload_pod:kube_pod_owner:relabel
        - expr: |-
            max by (cluster, namespace, workload, pod) (
              label_replace(
                kube_pod_owner{job="kube-state-metrics", owner_kind="DaemonSet"},
                "workload", "$1", "owner_name", "(.*)"
              )
            )
          labels:
            workload_type: daemonset
          record: namespace_workload_pod:kube_pod_owner:relabel
        - expr: |-
            max by (cluster, namespace, workload, pod) (
              label_replace(
                kube_pod_owner{job="kube-state-metrics", owner_kind="StatefulSet"},
                "workload", "$1", "owner_name", "(.*)"
              )
            )
          labels:
            workload_type: statefulset
          record: namespace_workload_pod:kube_pod_owner:relabel
        - expr: |-
            max by (cluster, namespace, workload, pod) (
              label_replace(
                kube_pod_owner{job="kube-state-metrics", owner_kind="Job"},
                "workload", "$1", "owner_name", "(.*)"
              )
            )
          labels:
            workload_type: job
          record: namespace_workload_pod:kube_pod_owner:relabel
      - interval: 3m
        name: kube-apiserver-availability.rules
        rules:
        - expr: avg_over_time(code_verb:apiserver_request_total:increase1h[30d]) * 24 *
            30
          record: code_verb:apiserver_request_total:increase30d
        - expr: sum by (cluster, code) (code_verb:apiserver_request_total:increase30d{verb=~"LIST|GET"})
          labels:
            verb: read
          record: code:apiserver_request_total:increase30d
        - expr: sum by (cluster, code) (code_verb:apiserver_request_total:increase30d{verb=~"POST|PUT|PATCH|DELETE"})
          labels:
            verb: write
          record: code:apiserver_request_total:increase30d
        - expr: sum by (cluster, verb, scope) (increase(apiserver_request_slo_duration_seconds_count[1h]))
          record: cluster_verb_scope:apiserver_request_slo_duration_seconds_count:increase1h
        - expr: sum by (cluster, verb, scope) (avg_over_time(cluster_verb_scope:apiserver_request_slo_duration_seconds_count:increase1h[30d])
            * 24 * 30)
          record: cluster_verb_scope:apiserver_request_slo_duration_seconds_count:increase30d
        - expr: sum by (cluster, verb, scope, le) (increase(apiserver_request_slo_duration_seconds_bucket[1h]))
          record: cluster_verb_scope_le:apiserver_request_slo_duration_seconds_bucket:increase1h
        - expr: sum by (cluster, verb, scope, le) (avg_over_time(cluster_verb_scope_le:apiserver_request_slo_duration_seconds_bucket:increase1h[30d])
            * 24 * 30)
          record: cluster_verb_scope_le:apiserver_request_slo_duration_seconds_bucket:increase30d
        - expr: |-
            1 - (
              (
                # write too slow
                sum by (cluster) (cluster_verb_scope:apiserver_request_slo_duration_seconds_count:increase30d{verb=~"POST|PUT|PATCH|DELETE"})
                -
                sum by (cluster) (cluster_verb_scope_le:apiserver_request_slo_duration_seconds_bucket:increase30d{verb=~"POST|PUT|PATCH|DELETE",le="1"})
              ) +
              (
                # read too slow
                sum by (cluster) (cluster_verb_scope:apiserver_request_slo_duration_seconds_count:increase30d{verb=~"LIST|GET"})
                -
                (
                  (
                    sum by (cluster) (cluster_verb_scope_le:apiserver_request_slo_duration_seconds_bucket:increase30d{verb=~"LIST|GET",scope=~"resource|",le="1"})
                    or
                    vector(0)
                  )
                  +
                  sum by (cluster) (cluster_verb_scope_le:apiserver_request_slo_duration_seconds_bucket:increase30d{verb=~"LIST|GET",scope="namespace",le="5"})
                  +
                  sum by (cluster) (cluster_verb_scope_le:apiserver_request_slo_duration_seconds_bucket:increase30d{verb=~"LIST|GET",scope="cluster",le="30"})
                )
              ) +
              # errors
              sum by (cluster) (code:apiserver_request_total:increase30d{code=~"5.."} or vector(0))
            )
            /
            sum by (cluster) (code:apiserver_request_total:increase30d)
          labels:
            verb: all
          record: apiserver_request:availability30d
        - expr: |-
            1 - (
              sum by (cluster) (cluster_verb_scope:apiserver_request_slo_duration_seconds_count:increase30d{verb=~"LIST|GET"})
              -
              (
                # too slow
                (
                  sum by (cluster) (cluster_verb_scope_le:apiserver_request_slo_duration_seconds_bucket:increase30d{verb=~"LIST|GET",scope=~"resource|",le="1"})
                  or
                  vector(0)
                )
                +
                sum by (cluster) (cluster_verb_scope_le:apiserver_request_slo_duration_seconds_bucket:increase30d{verb=~"LIST|GET",scope="namespace",le="5"})
                +
                sum by (cluster) (cluster_verb_scope_le:apiserver_request_slo_duration_seconds_bucket:increase30d{verb=~"LIST|GET",scope="cluster",le="30"})
              )
              +
              # errors
              sum by (cluster) (code:apiserver_request_total:increase30d{verb="read",code=~"5.."} or vector(0))
            )
            /
            sum by (cluster) (code:apiserver_request_total:increase30d{verb="read"})
          labels:
            verb: read
          record: apiserver_request:availability30d
        - expr: |-
            1 - (
              (
                # too slow
                sum by (cluster) (cluster_verb_scope:apiserver_request_slo_duration_seconds_count:increase30d{verb=~"POST|PUT|PATCH|DELETE"})
                -
                sum by (cluster) (cluster_verb_scope_le:apiserver_request_slo_duration_seconds_bucket:increase30d{verb=~"POST|PUT|PATCH|DELETE",le="1"})
              )
              +
              # errors
              sum by (cluster) (code:apiserver_request_total:increase30d{verb="write",code=~"5.."} or vector(0))
            )
            /
            sum by (cluster) (code:apiserver_request_total:increase30d{verb="write"})
          labels:
            verb: write
          record: apiserver_request:availability30d
        - expr: sum by (cluster,code,resource) (rate(apiserver_request_total{job="apiserver",verb=~"LIST|GET"}[5m]))
          labels:
            verb: read
          record: code_resource:apiserver_request_total:rate5m
        - expr: sum by (cluster,code,resource) (rate(apiserver_request_total{job="apiserver",verb=~"POST|PUT|PATCH|DELETE"}[5m]))
          labels:
            verb: write
          record: code_resource:apiserver_request_total:rate5m
        - expr: sum by (cluster, code, verb) (increase(apiserver_request_total{job="apiserver",verb=~"LIST|GET|POST|PUT|PATCH|DELETE",code=~"2.."}[1h]))
          record: code_verb:apiserver_request_total:increase1h
        - expr: sum by (cluster, code, verb) (increase(apiserver_request_total{job="apiserver",verb=~"LIST|GET|POST|PUT|PATCH|DELETE",code=~"3.."}[1h]))
          record: code_verb:apiserver_request_total:increase1h
        - expr: sum by (cluster, code, verb) (increase(apiserver_request_total{job="apiserver",verb=~"LIST|GET|POST|PUT|PATCH|DELETE",code=~"4.."}[1h]))
          record: code_verb:apiserver_request_total:increase1h
        - expr: sum by (cluster, code, verb) (increase(apiserver_request_total{job="apiserver",verb=~"LIST|GET|POST|PUT|PATCH|DELETE",code=~"5.."}[1h]))
          record: code_verb:apiserver_request_total:increase1h
      - name: kube-apiserver-burnrate.rules
        rules:
        - expr: |-
            (
              (
                # too slow
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_count{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[1d]))
                -
                (
                  (
                    sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope=~"resource|",le="1"}[1d]))
                    or
                    vector(0)
                  )
                  +
                  sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="namespace",le="5"}[1d]))
                  +
                  sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="cluster",le="30"}[1d]))
                )
              )
              +
              # errors
              sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"LIST|GET",code=~"5.."}[1d]))
            )
            /
            sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"LIST|GET"}[1d]))
          labels:
            verb: read
          record: apiserver_request:burnrate1d
        - expr: |-
            (
              (
                # too slow
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_count{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[1h]))
                -
                (
                  (
                    sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope=~"resource|",le="1"}[1h]))
                    or
                    vector(0)
                  )
                  +
                  sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="namespace",le="5"}[1h]))
                  +
                  sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="cluster",le="30"}[1h]))
                )
              )
              +
              # errors
              sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"LIST|GET",code=~"5.."}[1h]))
            )
            /
            sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"LIST|GET"}[1h]))
          labels:
            verb: read
          record: apiserver_request:burnrate1h
        - expr: |-
            (
              (
                # too slow
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_count{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[2h]))
                -
                (
                  (
                    sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope=~"resource|",le="1"}[2h]))
                    or
                    vector(0)
                  )
                  +
                  sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="namespace",le="5"}[2h]))
                  +
                  sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="cluster",le="30"}[2h]))
                )
              )
              +
              # errors
              sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"LIST|GET",code=~"5.."}[2h]))
            )
            /
            sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"LIST|GET"}[2h]))
          labels:
            verb: read
          record: apiserver_request:burnrate2h
        - expr: |-
            (
              (
                # too slow
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_count{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[30m]))
                -
                (
                  (
                    sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope=~"resource|",le="1"}[30m]))
                    or
                    vector(0)
                  )
                  +
                  sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="namespace",le="5"}[30m]))
                  +
                  sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="cluster",le="30"}[30m]))
                )
              )
              +
              # errors
              sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"LIST|GET",code=~"5.."}[30m]))
            )
            /
            sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"LIST|GET"}[30m]))
          labels:
            verb: read
          record: apiserver_request:burnrate30m
        - expr: |-
            (
              (
                # too slow
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_count{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[3d]))
                -
                (
                  (
                    sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope=~"resource|",le="1"}[3d]))
                    or
                    vector(0)
                  )
                  +
                  sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="namespace",le="5"}[3d]))
                  +
                  sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="cluster",le="30"}[3d]))
                )
              )
              +
              # errors
              sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"LIST|GET",code=~"5.."}[3d]))
            )
            /
            sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"LIST|GET"}[3d]))
          labels:
            verb: read
          record: apiserver_request:burnrate3d
        - expr: |-
            (
              (
                # too slow
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_count{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[5m]))
                -
                (
                  (
                    sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope=~"resource|",le="1"}[5m]))
                    or
                    vector(0)
                  )
                  +
                  sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="namespace",le="5"}[5m]))
                  +
                  sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="cluster",le="30"}[5m]))
                )
              )
              +
              # errors
              sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"LIST|GET",code=~"5.."}[5m]))
            )
            /
            sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"LIST|GET"}[5m]))
          labels:
            verb: read
          record: apiserver_request:burnrate5m
        - expr: |-
            (
              (
                # too slow
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_count{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[6h]))
                -
                (
                  (
                    sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope=~"resource|",le="1"}[6h]))
                    or
                    vector(0)
                  )
                  +
                  sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="namespace",le="5"}[6h]))
                  +
                  sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="cluster",le="30"}[6h]))
                )
              )
              +
              # errors
              sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"LIST|GET",code=~"5.."}[6h]))
            )
            /
            sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"LIST|GET"}[6h]))
          labels:
            verb: read
          record: apiserver_request:burnrate6h
        - expr: |-
            (
              (
                # too slow
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_count{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[1d]))
                -
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward",le="1"}[1d]))
              )
              +
              sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[1d]))
            )
            /
            sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"POST|PUT|PATCH|DELETE"}[1d]))
          labels:
            verb: write
          record: apiserver_request:burnrate1d
        - expr: |-
            (
              (
                # too slow
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_count{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[1h]))
                -
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward",le="1"}[1h]))
              )
              +
              sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[1h]))
            )
            /
            sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"POST|PUT|PATCH|DELETE"}[1h]))
          labels:
            verb: write
          record: apiserver_request:burnrate1h
        - expr: |-
            (
              (
                # too slow
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_count{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[2h]))
                -
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward",le="1"}[2h]))
              )
              +
              sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[2h]))
            )
            /
            sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"POST|PUT|PATCH|DELETE"}[2h]))
          labels:
            verb: write
          record: apiserver_request:burnrate2h
        - expr: |-
            (
              (
                # too slow
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_count{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[30m]))
                -
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward",le="1"}[30m]))
              )
              +
              sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[30m]))
            )
            /
            sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"POST|PUT|PATCH|DELETE"}[30m]))
          labels:
            verb: write
          record: apiserver_request:burnrate30m
        - expr: |-
            (
              (
                # too slow
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_count{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[3d]))
                -
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward",le="1"}[3d]))
              )
              +
              sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[3d]))
            )
            /
            sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"POST|PUT|PATCH|DELETE"}[3d]))
          labels:
            verb: write
          record: apiserver_request:burnrate3d
        - expr: |-
            (
              (
                # too slow
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_count{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[5m]))
                -
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward",le="1"}[5m]))
              )
              +
              sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[5m]))
            )
            /
            sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"POST|PUT|PATCH|DELETE"}[5m]))
          labels:
            verb: write
          record: apiserver_request:burnrate5m
        - expr: |-
            (
              (
                # too slow
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_count{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[6h]))
                -
                sum by (cluster) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward",le="1"}[6h]))
              )
              +
              sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[6h]))
            )
            /
            sum by (cluster) (rate(apiserver_request_total{job="apiserver",verb=~"POST|PUT|PATCH|DELETE"}[6h]))
          labels:
            verb: write
          record: apiserver_request:burnrate6h
      - name: kube-apiserver-histogram.rules
        rules:
        - expr: histogram_quantile(0.99, sum by (cluster, le, resource) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[5m])))
            > 0
          labels:
            quantile: "0.99"
            verb: read
          record: cluster_quantile:apiserver_request_slo_duration_seconds:histogram_quantile
        - expr: histogram_quantile(0.99, sum by (cluster, le, resource) (rate(apiserver_request_slo_duration_seconds_bucket{job="apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[5m])))
            > 0
          labels:
            quantile: "0.99"
            verb: write
          record: cluster_quantile:apiserver_request_slo_duration_seconds:histogram_quantile
      - name: kube-apiserver-slos
        rules:
        - alert: KubeAPIErrorBudgetBurn
          annotations:
            description: The API server is burning too much error budget.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapierrorbudgetburn
            summary: The API server is burning too much error budget.
          expr: |-
            sum(apiserver_request:burnrate1h) > (14.40 * 0.01000)
            and
            sum(apiserver_request:burnrate5m) > (14.40 * 0.01000)
          for: 2m
          labels:
            long: 1h
            severity: critical
            short: 5m
        - alert: KubeAPIErrorBudgetBurn
          annotations:
            description: The API server is burning too much error budget.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapierrorbudgetburn
            summary: The API server is burning too much error budget.
          expr: |-
            sum(apiserver_request:burnrate6h) > (6.00 * 0.01000)
            and
            sum(apiserver_request:burnrate30m) > (6.00 * 0.01000)
          for: 15m
          labels:
            long: 6h
            severity: critical
            short: 30m
        - alert: KubeAPIErrorBudgetBurn
          annotations:
            description: The API server is burning too much error budget.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapierrorbudgetburn
            summary: The API server is burning too much error budget.
          expr: |-
            sum(apiserver_request:burnrate1d) > (3.00 * 0.01000)
            and
            sum(apiserver_request:burnrate2h) > (3.00 * 0.01000)
          for: 1h
          labels:
            long: 1d
            severity: warning
            short: 2h
        - alert: KubeAPIErrorBudgetBurn
          annotations:
            description: The API server is burning too much error budget.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapierrorbudgetburn
            summary: The API server is burning too much error budget.
          expr: |-
            sum(apiserver_request:burnrate3d) > (1.00 * 0.01000)
            and
            sum(apiserver_request:burnrate6h) > (1.00 * 0.01000)
          for: 3h
          labels:
            long: 3d
            severity: warning
            short: 6h
      - name: kube-prometheus-general.rules
        rules:
        - expr: count without(instance, pod, node) (up == 1)
          record: count:up1
        - expr: count without(instance, pod, node) (up == 0)
          record: count:up0
      - name: kube-prometheus-node-recording.rules
        rules:
        - expr: sum(rate(node_cpu_seconds_total{mode!="idle",mode!="iowait",mode!="steal"}[3m]))
            BY (instance)
          record: instance:node_cpu:rate:sum
        - expr: sum(rate(node_network_receive_bytes_total[3m])) BY (instance)
          record: instance:node_network_receive_bytes:rate:sum
        - expr: sum(rate(node_network_transmit_bytes_total[3m])) BY (instance)
          record: instance:node_network_transmit_bytes:rate:sum
        - expr: sum(rate(node_cpu_seconds_total{mode!="idle",mode!="iowait",mode!="steal"}[5m]))
            WITHOUT (cpu, mode) / ON(instance) GROUP_LEFT() count(sum(node_cpu_seconds_total)
            BY (instance, cpu)) BY (instance)
          record: instance:node_cpu:ratio
        - expr: sum(rate(node_cpu_seconds_total{mode!="idle",mode!="iowait",mode!="steal"}[5m]))
          record: cluster:node_cpu:sum_rate5m
        - expr: cluster:node_cpu:sum_rate5m / count(sum(node_cpu_seconds_total) BY (instance,
            cpu))
          record: cluster:node_cpu:ratio
      - name: kube-scheduler.rules
        rules:
        - expr: histogram_quantile(0.99, sum(rate(scheduler_e2e_scheduling_duration_seconds_bucket{job="kube-scheduler"}[5m]))
            without(instance, pod))
          labels:
            quantile: "0.99"
          record: cluster_quantile:scheduler_e2e_scheduling_duration_seconds:histogram_quantile
        - expr: histogram_quantile(0.99, sum(rate(scheduler_scheduling_algorithm_duration_seconds_bucket{job="kube-scheduler"}[5m]))
            without(instance, pod))
          labels:
            quantile: "0.99"
          record: cluster_quantile:scheduler_scheduling_algorithm_duration_seconds:histogram_quantile
        - expr: histogram_quantile(0.99, sum(rate(scheduler_binding_duration_seconds_bucket{job="kube-scheduler"}[5m]))
            without(instance, pod))
          labels:
            quantile: "0.99"
          record: cluster_quantile:scheduler_binding_duration_seconds:histogram_quantile
        - expr: histogram_quantile(0.9, sum(rate(scheduler_e2e_scheduling_duration_seconds_bucket{job="kube-scheduler"}[5m]))
            without(instance, pod))
          labels:
            quantile: "0.9"
          record: cluster_quantile:scheduler_e2e_scheduling_duration_seconds:histogram_quantile
        - expr: histogram_quantile(0.9, sum(rate(scheduler_scheduling_algorithm_duration_seconds_bucket{job="kube-scheduler"}[5m]))
            without(instance, pod))
          labels:
            quantile: "0.9"
          record: cluster_quantile:scheduler_scheduling_algorithm_duration_seconds:histogram_quantile
        - expr: histogram_quantile(0.9, sum(rate(scheduler_binding_duration_seconds_bucket{job="kube-scheduler"}[5m]))
            without(instance, pod))
          labels:
            quantile: "0.9"
          record: cluster_quantile:scheduler_binding_duration_seconds:histogram_quantile
        - expr: histogram_quantile(0.5, sum(rate(scheduler_e2e_scheduling_duration_seconds_bucket{job="kube-scheduler"}[5m]))
            without(instance, pod))
          labels:
            quantile: "0.5"
          record: cluster_quantile:scheduler_e2e_scheduling_duration_seconds:histogram_quantile
        - expr: histogram_quantile(0.5, sum(rate(scheduler_scheduling_algorithm_duration_seconds_bucket{job="kube-scheduler"}[5m]))
            without(instance, pod))
          labels:
            quantile: "0.5"
          record: cluster_quantile:scheduler_scheduling_algorithm_duration_seconds:histogram_quantile
        - expr: histogram_quantile(0.5, sum(rate(scheduler_binding_duration_seconds_bucket{job="kube-scheduler"}[5m]))
            without(instance, pod))
          labels:
            quantile: "0.5"
          record: cluster_quantile:scheduler_binding_duration_seconds:histogram_quantile
      - name: kube-state-metrics
        rules:
        - alert: KubeStateMetricsListErrors
          annotations:
            description: kube-state-metrics is experiencing errors at an elevated rate in
              list operations. This is likely causing it to not be able to expose metrics
              about Kubernetes objects correctly or at all.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kube-state-metrics/kubestatemetricslisterrors
            summary: kube-state-metrics is experiencing errors in list operations.
          expr: |-
            (sum(rate(kube_state_metrics_list_total{job="kube-state-metrics",result="error"}[5m]))
              /
            sum(rate(kube_state_metrics_list_total{job="kube-state-metrics"}[5m])))
            > 0.01
          for: 15m
          labels:
            severity: critical
        - alert: KubeStateMetricsWatchErrors
          annotations:
            description: kube-state-metrics is experiencing errors at an elevated rate in
              watch operations. This is likely causing it to not be able to expose metrics
              about Kubernetes objects correctly or at all.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kube-state-metrics/kubestatemetricswatcherrors
            summary: kube-state-metrics is experiencing errors in watch operations.
          expr: |-
            (sum(rate(kube_state_metrics_watch_total{job="kube-state-metrics",result="error"}[5m]))
              /
            sum(rate(kube_state_metrics_watch_total{job="kube-state-metrics"}[5m])))
            > 0.01
          for: 15m
          labels:
            severity: critical
        - alert: KubeStateMetricsShardingMismatch
          annotations:
            description: kube-state-metrics pods are running with different --total-shards
              configuration, some Kubernetes objects may be exposed multiple times or not
              exposed at all.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kube-state-metrics/kubestatemetricsshardingmismatch
            summary: kube-state-metrics sharding is misconfigured.
          expr: stdvar (kube_state_metrics_total_shards{job="kube-state-metrics"}) != 0
          for: 15m
          labels:
            severity: critical
        - alert: KubeStateMetricsShardsMissing
          annotations:
            description: kube-state-metrics shards are missing, some Kubernetes objects
              are not being exposed.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kube-state-metrics/kubestatemetricsshardsmissing
            summary: kube-state-metrics shards are missing.
          expr: |-
            2^max(kube_state_metrics_total_shards{job="kube-state-metrics"}) - 1
              -
            sum( 2 ^ max by (shard_ordinal) (kube_state_metrics_shard_ordinal{job="kube-state-metrics"}) )
            != 0
          for: 15m
          labels:
            severity: critical
      - name: kubelet.rules
        rules:
        - expr: histogram_quantile(0.99, sum(rate(kubelet_pleg_relist_duration_seconds_bucket[5m]))
            by (cluster, instance, le) * on(cluster, instance) group_left(node) kubelet_node_name{job="kubelet",
            metrics_path="/metrics"})
          labels:
            quantile: "0.99"
          record: node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile
        - expr: histogram_quantile(0.9, sum(rate(kubelet_pleg_relist_duration_seconds_bucket[5m]))
            by (cluster, instance, le) * on(cluster, instance) group_left(node) kubelet_node_name{job="kubelet",
            metrics_path="/metrics"})
          labels:
            quantile: "0.9"
          record: node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile
        - expr: histogram_quantile(0.5, sum(rate(kubelet_pleg_relist_duration_seconds_bucket[5m]))
            by (cluster, instance, le) * on(cluster, instance) group_left(node) kubelet_node_name{job="kubelet",
            metrics_path="/metrics"})
          labels:
            quantile: "0.5"
          record: node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile
      - name: kubernetes-apps
        rules:
        - alert: KubePodCrashLooping
          annotations:
            description: 'Pod {{ $labels.namespace }}/{{ $labels.pod }} ({{ $labels.container
              }}) is in waiting state (reason: "CrashLoopBackOff").'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepodcrashlooping
            summary: Pod is crash looping.
          expr: max_over_time(kube_pod_container_status_waiting_reason{reason="CrashLoopBackOff",
            job="kube-state-metrics", namespace=~".*"}[5m]) >= 1
          for: 15m
          labels:
            severity: warning
        - alert: KubePodNotReady
          annotations:
            description: Pod {{ $labels.namespace }}/{{ $labels.pod }} has been in a non-ready
              state for longer than 15 minutes.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepodnotready
            summary: Pod has been in a non-ready state for more than 15 minutes.
          expr: |-
            sum by (namespace, pod, cluster) (
              max by(namespace, pod, cluster) (
                kube_pod_status_phase{job="kube-state-metrics", namespace=~".*", phase=~"Pending|Unknown|Failed"}
              ) * on(namespace, pod, cluster) group_left(owner_kind) topk by(namespace, pod, cluster) (
                1, max by(namespace, pod, owner_kind, cluster) (kube_pod_owner{owner_kind!="Job"})
              )
            ) > 0
          for: 15m
          labels:
            severity: warning
        - alert: KubeDeploymentGenerationMismatch
          annotations:
            description: Deployment generation for {{ $labels.namespace }}/{{ $labels.deployment
              }} does not match, this indicates that the Deployment has failed but has not
              been rolled back.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedeploymentgenerationmismatch
            summary: Deployment generation mismatch due to possible roll-back
          expr: |-
            kube_deployment_status_observed_generation{job="kube-state-metrics", namespace=~".*"}
              !=
            kube_deployment_metadata_generation{job="kube-state-metrics", namespace=~".*"}
          for: 15m
          labels:
            severity: warning
        - alert: KubeDeploymentReplicasMismatch
          annotations:
            description: Deployment {{ $labels.namespace }}/{{ $labels.deployment }} has
              not matched the expected number of replicas for longer than 15 minutes.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedeploymentreplicasmismatch
            summary: Deployment has not matched the expected number of replicas.
          expr: |-
            (
              kube_deployment_spec_replicas{job="kube-state-metrics", namespace=~".*"}
                >
              kube_deployment_status_replicas_available{job="kube-state-metrics", namespace=~".*"}
            ) and (
              changes(kube_deployment_status_replicas_updated{job="kube-state-metrics", namespace=~".*"}[10m])
                ==
              0
            )
          for: 15m
          labels:
            severity: warning
        - alert: KubeStatefulSetReplicasMismatch
          annotations:
            description: StatefulSet {{ $labels.namespace }}/{{ $labels.statefulset }} has
              not matched the expected number of replicas for longer than 15 minutes.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubestatefulsetreplicasmismatch
            summary: Deployment has not matched the expected number of replicas.
          expr: |-
            (
              kube_statefulset_status_replicas_ready{job="kube-state-metrics", namespace=~".*"}
                !=
              kube_statefulset_status_replicas{job="kube-state-metrics", namespace=~".*"}
            ) and (
              changes(kube_statefulset_status_replicas_updated{job="kube-state-metrics", namespace=~".*"}[10m])
                ==
              0
            )
          for: 15m
          labels:
            severity: warning
        - alert: KubeStatefulSetGenerationMismatch
          annotations:
            description: StatefulSet generation for {{ $labels.namespace }}/{{ $labels.statefulset
              }} does not match, this indicates that the StatefulSet has failed but has
              not been rolled back.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubestatefulsetgenerationmismatch
            summary: StatefulSet generation mismatch due to possible roll-back
          expr: |-
            kube_statefulset_status_observed_generation{job="kube-state-metrics", namespace=~".*"}
              !=
            kube_statefulset_metadata_generation{job="kube-state-metrics", namespace=~".*"}
          for: 15m
          labels:
            severity: warning
        - alert: KubeStatefulSetUpdateNotRolledOut
          annotations:
            description: StatefulSet {{ $labels.namespace }}/{{ $labels.statefulset }} update
              has not been rolled out.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubestatefulsetupdatenotrolledout
            summary: StatefulSet update has not been rolled out.
          expr: |-
            (
              max without (revision) (
                kube_statefulset_status_current_revision{job="kube-state-metrics", namespace=~".*"}
                  unless
                kube_statefulset_status_update_revision{job="kube-state-metrics", namespace=~".*"}
              )
                *
              (
                kube_statefulset_replicas{job="kube-state-metrics", namespace=~".*"}
                  !=
                kube_statefulset_status_replicas_updated{job="kube-state-metrics", namespace=~".*"}
              )
            )  and (
              changes(kube_statefulset_status_replicas_updated{job="kube-state-metrics", namespace=~".*"}[5m])
                ==
              0
            )
          for: 15m
          labels:
            severity: warning
        - alert: KubeDaemonSetRolloutStuck
          annotations:
            description: DaemonSet {{ $labels.namespace }}/{{ $labels.daemonset }} has not
              finished or progressed for at least 15 minutes.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedaemonsetrolloutstuck
            summary: DaemonSet rollout is stuck.
          expr: |-
            (
              (
                kube_daemonset_status_current_number_scheduled{job="kube-state-metrics", namespace=~".*"}
                !=
                kube_daemonset_status_desired_number_scheduled{job="kube-state-metrics", namespace=~".*"}
              ) or (
                kube_daemonset_status_number_misscheduled{job="kube-state-metrics", namespace=~".*"}
                !=
                0
              ) or (
                kube_daemonset_status_updated_number_scheduled{job="kube-state-metrics", namespace=~".*"}
                !=
                kube_daemonset_status_desired_number_scheduled{job="kube-state-metrics", namespace=~".*"}
              ) or (
                kube_daemonset_status_number_available{job="kube-state-metrics", namespace=~".*"}
                !=
                kube_daemonset_status_desired_number_scheduled{job="kube-state-metrics", namespace=~".*"}
              )
            ) and (
              changes(kube_daemonset_status_updated_number_scheduled{job="kube-state-metrics", namespace=~".*"}[5m])
                ==
              0
            )
          for: 15m
          labels:
            severity: warning
        - alert: KubeContainerWaiting
          annotations:
            description: pod/{{ $labels.pod }} in namespace {{ $labels.namespace }} on container
              {{ $labels.container}} has been in waiting state for longer than 1 hour.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubecontainerwaiting
            summary: Pod container waiting longer than 1 hour
          expr: sum by (namespace, pod, container, cluster) (kube_pod_container_status_waiting_reason{job="kube-state-metrics",
            namespace=~".*"}) > 0
          for: 1h
          labels:
            severity: warning
        - alert: KubeDaemonSetNotScheduled
          annotations:
            description: '{{ $value }} Pods of DaemonSet {{ $labels.namespace }}/{{ $labels.daemonset
              }} are not scheduled.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedaemonsetnotscheduled
            summary: DaemonSet pods are not scheduled.
          expr: |-
            kube_daemonset_status_desired_number_scheduled{job="kube-state-metrics", namespace=~".*"}
              -
            kube_daemonset_status_current_number_scheduled{job="kube-state-metrics", namespace=~".*"} > 0
          for: 10m
          labels:
            severity: warning
        - alert: KubeDaemonSetMisScheduled
          annotations:
            description: '{{ $value }} Pods of DaemonSet {{ $labels.namespace }}/{{ $labels.daemonset
              }} are running where they are not supposed to run.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedaemonsetmisscheduled
            summary: DaemonSet pods are misscheduled.
          expr: kube_daemonset_status_number_misscheduled{job="kube-state-metrics", namespace=~".*"}
            > 0
          for: 15m
          labels:
            severity: warning
        - alert: KubeJobNotCompleted
          annotations:
            description: Job {{ $labels.namespace }}/{{ $labels.job_name }} is taking more
              than {{ "43200" | humanizeDuration }} to complete.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubejobnotcompleted
            summary: Job did not complete in time
          expr: |-
            time() - max by(namespace, job_name, cluster) (kube_job_status_start_time{job="kube-state-metrics", namespace=~".*"}
              and
            kube_job_status_active{job="kube-state-metrics", namespace=~".*"} > 0) > 43200
          labels:
            severity: warning
        - alert: KubeJobFailed
          annotations:
            description: Job {{ $labels.namespace }}/{{ $labels.job_name }} failed to complete.
              Removing failed job after investigation should clear this alert.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubejobfailed
            summary: Job failed to complete.
          expr: kube_job_failed{job="kube-state-metrics", namespace=~".*"}  > 0
          for: 15m
          labels:
            severity: warning
        - alert: KubeHpaReplicasMismatch
          annotations:
            description: HPA {{ $labels.namespace }}/{{ $labels.horizontalpodautoscaler  }}
              has not matched the desired number of replicas for longer than 15 minutes.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubehpareplicasmismatch
            summary: HPA has not matched desired number of replicas.
          expr: |-
            (kube_horizontalpodautoscaler_status_desired_replicas{job="kube-state-metrics", namespace=~".*"}
              !=
            kube_horizontalpodautoscaler_status_current_replicas{job="kube-state-metrics", namespace=~".*"})
              and
            (kube_horizontalpodautoscaler_status_current_replicas{job="kube-state-metrics", namespace=~".*"}
              >
            kube_horizontalpodautoscaler_spec_min_replicas{job="kube-state-metrics", namespace=~".*"})
              and
            (kube_horizontalpodautoscaler_status_current_replicas{job="kube-state-metrics", namespace=~".*"}
              <
            kube_horizontalpodautoscaler_spec_max_replicas{job="kube-state-metrics", namespace=~".*"})
              and
            changes(kube_horizontalpodautoscaler_status_current_replicas{job="kube-state-metrics", namespace=~".*"}[15m]) == 0
          for: 15m
          labels:
            severity: warning
        - alert: KubeHpaMaxedOut
          annotations:
            description: HPA {{ $labels.namespace }}/{{ $labels.horizontalpodautoscaler  }}
              has been running at max replicas for longer than 15 minutes.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubehpamaxedout
            summary: HPA is running at max replicas
          expr: |-
            kube_horizontalpodautoscaler_status_current_replicas{job="kube-state-metrics", namespace=~".*"}
              ==
            kube_horizontalpodautoscaler_spec_max_replicas{job="kube-state-metrics", namespace=~".*"}
          for: 15m
          labels:
            severity: warning
      - name: kubernetes-resources
        rules:
        - alert: KubeCPUOvercommit
          annotations:
            description: Cluster has overcommitted CPU resource requests for Pods by {{
              $value }} CPU shares and cannot tolerate node failure.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubecpuovercommit
            summary: Cluster has overcommitted CPU resource requests.
          expr: |-
            sum(namespace_cpu:kube_pod_container_resource_requests:sum{}) - (sum(kube_node_status_allocatable{resource="cpu"}) - max(kube_node_status_allocatable{resource="cpu"})) > 0
            and
            (sum(kube_node_status_allocatable{resource="cpu"}) - max(kube_node_status_allocatable{resource="cpu"})) > 0
          for: 10m
          labels:
            severity: warning
        - alert: KubeMemoryOvercommit
          annotations:
            description: Cluster has overcommitted memory resource requests for Pods by
              {{ $value | humanize }} bytes and cannot tolerate node failure.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubememoryovercommit
            summary: Cluster has overcommitted memory resource requests.
          expr: |-
            sum(namespace_memory:kube_pod_container_resource_requests:sum{}) - (sum(kube_node_status_allocatable{resource="memory"}) - max(kube_node_status_allocatable{resource="memory"})) > 0
            and
            (sum(kube_node_status_allocatable{resource="memory"}) - max(kube_node_status_allocatable{resource="memory"})) > 0
          for: 10m
          labels:
            severity: warning
        - alert: KubeCPUQuotaOvercommit
          annotations:
            description: Cluster has overcommitted CPU resource requests for Namespaces.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubecpuquotaovercommit
            summary: Cluster has overcommitted CPU resource requests.
          expr: |-
            sum(min without(resource) (kube_resourcequota{job="kube-state-metrics", type="hard", resource=~"(cpu|requests.cpu)"}))
              /
            sum(kube_node_status_allocatable{resource="cpu", job="kube-state-metrics"})
              > 1.5
          for: 5m
          labels:
            severity: warning
        - alert: KubeMemoryQuotaOvercommit
          annotations:
            description: Cluster has overcommitted memory resource requests for Namespaces.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubememoryquotaovercommit
            summary: Cluster has overcommitted memory resource requests.
          expr: |-
            sum(min without(resource) (kube_resourcequota{job="kube-state-metrics", type="hard", resource=~"(memory|requests.memory)"}))
              /
            sum(kube_node_status_allocatable{resource="memory", job="kube-state-metrics"})
              > 1.5
          for: 5m
          labels:
            severity: warning
        - alert: KubeQuotaAlmostFull
          annotations:
            description: Namespace {{ $labels.namespace }} is using {{ $value | humanizePercentage
              }} of its {{ $labels.resource }} quota.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubequotaalmostfull
            summary: Namespace quota is going to be full.
          expr: |-
            kube_resourcequota{job="kube-state-metrics", type="used"}
              / ignoring(instance, job, type)
            (kube_resourcequota{job="kube-state-metrics", type="hard"} > 0)
              > 0.9 < 1
          for: 15m
          labels:
            severity: info
        - alert: KubeQuotaFullyUsed
          annotations:
            description: Namespace {{ $labels.namespace }} is using {{ $value | humanizePercentage
              }} of its {{ $labels.resource }} quota.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubequotafullyused
            summary: Namespace quota is fully used.
          expr: |-
            kube_resourcequota{job="kube-state-metrics", type="used"}
              / ignoring(instance, job, type)
            (kube_resourcequota{job="kube-state-metrics", type="hard"} > 0)
              == 1
          for: 15m
          labels:
            severity: info
        - alert: KubeQuotaExceeded
          annotations:
            description: Namespace {{ $labels.namespace }} is using {{ $value | humanizePercentage
              }} of its {{ $labels.resource }} quota.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubequotaexceeded
            summary: Namespace quota has exceeded the limits.
          expr: |-
            kube_resourcequota{job="kube-state-metrics", type="used"}
              / ignoring(instance, job, type)
            (kube_resourcequota{job="kube-state-metrics", type="hard"} > 0)
              > 1
          for: 15m
          labels:
            severity: warning
        - alert: CPUThrottlingHigh
          annotations:
            description: '{{ $value | humanizePercentage }} throttling of CPU in namespace
              {{ $labels.namespace }} for container {{ $labels.container }} in pod {{ $labels.pod
              }}.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/cputhrottlinghigh
            summary: Processes experience elevated CPU throttling.
          expr: |-
            sum(increase(container_cpu_cfs_throttled_periods_total{container!="", }[5m])) by (container, pod, namespace)
              /
            sum(increase(container_cpu_cfs_periods_total{}[5m])) by (container, pod, namespace)
              > ( 25 / 100 )
          for: 15m
          labels:
            severity: info
      - name: kubernetes-storage
        rules:
        - alert: KubePersistentVolumeFillingUp
          annotations:
            description: The PersistentVolume claimed by {{ $labels.persistentvolumeclaim
              }} in Namespace {{ $labels.namespace }} is only {{ $value | humanizePercentage
              }} free.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepersistentvolumefillingup
            summary: PersistentVolume is filling up.
          expr: |-
            (
              kubelet_volume_stats_available_bytes{job="kubelet", namespace=~".*", metrics_path="/metrics"}
                /
              kubelet_volume_stats_capacity_bytes{job="kubelet", namespace=~".*", metrics_path="/metrics"}
            ) < 0.03
            and
            kubelet_volume_stats_used_bytes{job="kubelet", namespace=~".*", metrics_path="/metrics"} > 0
            unless on(namespace, persistentvolumeclaim)
            kube_persistentvolumeclaim_access_mode{ access_mode="ReadOnlyMany"} == 1
            unless on(namespace, persistentvolumeclaim)
            kube_persistentvolumeclaim_labels{label_excluded_from_alerts="true"} == 1
          for: 1m
          labels:
            severity: critical
        - alert: KubePersistentVolumeFillingUp
          annotations:
            description: Based on recent sampling, the PersistentVolume claimed by {{ $labels.persistentvolumeclaim
              }} in Namespace {{ $labels.namespace }} is expected to fill up within four
              days. Currently {{ $value | humanizePercentage }} is available.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepersistentvolumefillingup
            summary: PersistentVolume is filling up.
          expr: |-
            (
              kubelet_volume_stats_available_bytes{job="kubelet", namespace=~".*", metrics_path="/metrics"}
                /
              kubelet_volume_stats_capacity_bytes{job="kubelet", namespace=~".*", metrics_path="/metrics"}
            ) < 0.15
            and
            kubelet_volume_stats_used_bytes{job="kubelet", namespace=~".*", metrics_path="/metrics"} > 0
            and
            predict_linear(kubelet_volume_stats_available_bytes{job="kubelet", namespace=~".*", metrics_path="/metrics"}[6h], 4 * 24 * 3600) < 0
            unless on(namespace, persistentvolumeclaim)
            kube_persistentvolumeclaim_access_mode{ access_mode="ReadOnlyMany"} == 1
            unless on(namespace, persistentvolumeclaim)
            kube_persistentvolumeclaim_labels{label_excluded_from_alerts="true"} == 1
          for: 1h
          labels:
            severity: warning
        - alert: KubePersistentVolumeInodesFillingUp
          annotations:
            description: The PersistentVolume claimed by {{ $labels.persistentvolumeclaim
              }} in Namespace {{ $labels.namespace }} only has {{ $value | humanizePercentage
              }} free inodes.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepersistentvolumeinodesfillingup
            summary: PersistentVolumeInodes are filling up.
          expr: |-
            (
              kubelet_volume_stats_inodes_free{job="kubelet", namespace=~".*", metrics_path="/metrics"}
                /
              kubelet_volume_stats_inodes{job="kubelet", namespace=~".*", metrics_path="/metrics"}
            ) < 0.03
            and
            kubelet_volume_stats_inodes_used{job="kubelet", namespace=~".*", metrics_path="/metrics"} > 0
            unless on(namespace, persistentvolumeclaim)
            kube_persistentvolumeclaim_access_mode{ access_mode="ReadOnlyMany"} == 1
            unless on(namespace, persistentvolumeclaim)
            kube_persistentvolumeclaim_labels{label_excluded_from_alerts="true"} == 1
          for: 1m
          labels:
            severity: critical
        - alert: KubePersistentVolumeInodesFillingUp
          annotations:
            description: Based on recent sampling, the PersistentVolume claimed by {{ $labels.persistentvolumeclaim
              }} in Namespace {{ $labels.namespace }} is expected to run out of inodes within
              four days. Currently {{ $value | humanizePercentage }} of its inodes are free.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepersistentvolumeinodesfillingup
            summary: PersistentVolumeInodes are filling up.
          expr: |-
            (
              kubelet_volume_stats_inodes_free{job="kubelet", namespace=~".*", metrics_path="/metrics"}
                /
              kubelet_volume_stats_inodes{job="kubelet", namespace=~".*", metrics_path="/metrics"}
            ) < 0.15
            and
            kubelet_volume_stats_inodes_used{job="kubelet", namespace=~".*", metrics_path="/metrics"} > 0
            and
            predict_linear(kubelet_volume_stats_inodes_free{job="kubelet", namespace=~".*", metrics_path="/metrics"}[6h], 4 * 24 * 3600) < 0
            unless on(namespace, persistentvolumeclaim)
            kube_persistentvolumeclaim_access_mode{ access_mode="ReadOnlyMany"} == 1
            unless on(namespace, persistentvolumeclaim)
            kube_persistentvolumeclaim_labels{label_excluded_from_alerts="true"} == 1
          for: 1h
          labels:
            severity: warning
        - alert: KubePersistentVolumeErrors
          annotations:
            description: The persistent volume {{ $labels.persistentvolume }} has status
              {{ $labels.phase }}.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepersistentvolumeerrors
            summary: PersistentVolume is having issues with provisioning.
          expr: kube_persistentvolume_status_phase{phase=~"Failed|Pending",job="kube-state-metrics"}
            > 0
          for: 5m
          labels:
            severity: critical
      - name: kubernetes-system
        rules:
        - alert: KubeVersionMismatch
          annotations:
            description: There are {{ $value }} different semantic versions of Kubernetes
              components running.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeversionmismatch
            summary: Different semantic versions of Kubernetes components running.
          expr: count by (cluster) (count by (git_version, cluster) (label_replace(kubernetes_build_info{job!~"kube-dns|coredns"},"git_version","$1","git_version","(v[0-9]*.[0-9]*).*")))
            > 1
          for: 15m
          labels:
            severity: warning
        - alert: KubeClientErrors
          annotations:
            description: Kubernetes API server client '{{ $labels.job }}/{{ $labels.instance
              }}' is experiencing {{ $value | humanizePercentage }} errors.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeclienterrors
            summary: Kubernetes API server client is experiencing errors.
          expr: |-
            (sum(rate(rest_client_requests_total{code=~"5.."}[5m])) by (cluster, instance, job, namespace)
              /
            sum(rate(rest_client_requests_total[5m])) by (cluster, instance, job, namespace))
            > 0.01
          for: 15m
          labels:
            severity: warning
      - name: kubernetes-system-apiserver
        rules:
        - alert: KubeClientCertificateExpiration
          annotations:
            description: A client certificate used to authenticate to kubernetes apiserver
              is expiring in less than 7.0 days.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeclientcertificateexpiration
            summary: Client certificate is about to expire.
          expr: apiserver_client_certificate_expiration_seconds_count{job="apiserver"} >
            0 and on(job) histogram_quantile(0.01, sum by (job, le) (rate(apiserver_client_certificate_expiration_seconds_bucket{job="apiserver"}[5m])))
            < 604800
          for: 5m
          labels:
            severity: warning
        - alert: KubeClientCertificateExpiration
          annotations:
            description: A client certificate used to authenticate to kubernetes apiserver
              is expiring in less than 24.0 hours.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeclientcertificateexpiration
            summary: Client certificate is about to expire.
          expr: apiserver_client_certificate_expiration_seconds_count{job="apiserver"} >
            0 and on(job) histogram_quantile(0.01, sum by (job, le) (rate(apiserver_client_certificate_expiration_seconds_bucket{job="apiserver"}[5m])))
            < 86400
          for: 5m
          labels:
            severity: critical
        - alert: KubeAggregatedAPIErrors
          annotations:
            description: Kubernetes aggregated API {{ $labels.name }}/{{ $labels.namespace
              }} has reported errors. It has appeared unavailable {{ $value | humanize }}
              times averaged over the past 10m.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeaggregatedapierrors
            summary: Kubernetes aggregated API has reported errors.
          expr: sum by(name, namespace, cluster)(increase(aggregator_unavailable_apiservice_total[10m]))
            > 4
          labels:
            severity: warning
        - alert: KubeAggregatedAPIDown
          annotations:
            description: Kubernetes aggregated API {{ $labels.name }}/{{ $labels.namespace
              }} has been only {{ $value | humanize }}% available over the last 10m.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeaggregatedapidown
            summary: Kubernetes aggregated API is down.
          expr: (1 - max by(name, namespace, cluster)(avg_over_time(aggregator_unavailable_apiservice[10m])))
            * 100 < 85
          for: 5m
          labels:
            severity: warning
        - alert: KubeAPIDown
          annotations:
            description: KubeAPI has disappeared from Prometheus target discovery.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapidown
            summary: Target disappeared from Prometheus target discovery.
          expr: absent(up{job="apiserver"} == 1)
          for: 15m
          labels:
            severity: critical
        - alert: KubeAPITerminatedRequests
          annotations:
            description: The kubernetes apiserver has terminated {{ $value | humanizePercentage
              }} of its incoming requests.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapiterminatedrequests
            summary: The kubernetes apiserver has terminated {{ $value | humanizePercentage
              }} of its incoming requests.
          expr: sum(rate(apiserver_request_terminations_total{job="apiserver"}[10m]))  /
            (  sum(rate(apiserver_request_total{job="apiserver"}[10m])) + sum(rate(apiserver_request_terminations_total{job="apiserver"}[10m]))
            ) > 0.20
          for: 5m
          labels:
            severity: warning
      - name: kubernetes-system-controller-manager
        rules:
        - alert: KubeControllerManagerDown
          annotations:
            description: KubeControllerManager has disappeared from Prometheus target discovery.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubecontrollermanagerdown
            summary: Target disappeared from Prometheus target discovery.
          expr: absent(up{job="kube-controller-manager"} == 1)
          for: 15m
          labels:
            severity: critical
      - name: kubernetes-system-kube-proxy
        rules:
        - alert: KubeProxyDown
          annotations:
            description: KubeProxy has disappeared from Prometheus target discovery.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeproxydown
            summary: Target disappeared from Prometheus target discovery.
          expr: absent(up{job="kube-proxy"} == 1)
          for: 15m
          labels:
            severity: critical
      - name: kubernetes-system-kubelet
        rules:
        - alert: KubeNodeNotReady
          annotations:
            description: '{{ $labels.node }} has been unready for more than 15 minutes.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubenodenotready
            summary: Node is not ready.
          expr: kube_node_status_condition{job="kube-state-metrics",condition="Ready",status="true"}
            == 0
          for: 15m
          labels:
            severity: warning
        - alert: KubeNodeUnreachable
          annotations:
            description: '{{ $labels.node }} is unreachable and some workloads may be rescheduled.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubenodeunreachable
            summary: Node is unreachable.
          expr: (kube_node_spec_taint{job="kube-state-metrics",key="node.kubernetes.io/unreachable",effect="NoSchedule"}
            unless ignoring(key,value) kube_node_spec_taint{job="kube-state-metrics",key=~"ToBeDeletedByClusterAutoscaler|cloud.google.com/impending-node-termination|aws-node-termination-handler/spot-itn"})
            == 1
          for: 15m
          labels:
            severity: warning
        - alert: KubeletTooManyPods
          annotations:
            description: Kubelet '{{ $labels.node }}' is running at {{ $value | humanizePercentage
              }} of its Pod capacity.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubelettoomanypods
            summary: Kubelet is running at capacity.
          expr: |-
            count by(cluster, node) (
              (kube_pod_status_phase{job="kube-state-metrics",phase="Running"} == 1) * on(instance,pod,namespace,cluster) group_left(node) topk by(instance,pod,namespace,cluster) (1, kube_pod_info{job="kube-state-metrics"})
            )
            /
            max by(cluster, node) (
              kube_node_status_capacity{job="kube-state-metrics",resource="pods"} != 1
            ) > 0.95
          for: 15m
          labels:
            severity: info
        - alert: KubeNodeReadinessFlapping
          annotations:
            description: The readiness status of node {{ $labels.node }} has changed {{
              $value }} times in the last 15 minutes.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubenodereadinessflapping
            summary: Node readiness status is flapping.
          expr: sum(changes(kube_node_status_condition{status="true",condition="Ready"}[15m]))
            by (cluster, node) > 2
          for: 15m
          labels:
            severity: warning
        - alert: KubeletPlegDurationHigh
          annotations:
            description: The Kubelet Pod Lifecycle Event Generator has a 99th percentile
              duration of {{ $value }} seconds on node {{ $labels.node }}.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletplegdurationhigh
            summary: Kubelet Pod Lifecycle Event Generator is taking too long to relist.
          expr: node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile{quantile="0.99"}
            >= 10
          for: 5m
          labels:
            severity: warning
        - alert: KubeletPodStartUpLatencyHigh
          annotations:
            description: Kubelet Pod startup 99th percentile latency is {{ $value }} seconds
              on node {{ $labels.node }}.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletpodstartuplatencyhigh
            summary: Kubelet Pod startup latency is too high.
          expr: histogram_quantile(0.99, sum(rate(kubelet_pod_worker_duration_seconds_bucket{job="kubelet",
            metrics_path="/metrics"}[5m])) by (cluster, instance, le)) * on(cluster, instance)
            group_left(node) kubelet_node_name{job="kubelet", metrics_path="/metrics"} >
            60
          for: 15m
          labels:
            severity: warning
        - alert: KubeletClientCertificateExpiration
          annotations:
            description: Client certificate for Kubelet on node {{ $labels.node }} expires
              in {{ $value | humanizeDuration }}.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletclientcertificateexpiration
            summary: Kubelet client certificate is about to expire.
          expr: kubelet_certificate_manager_client_ttl_seconds < 604800
          labels:
            severity: warning
        - alert: KubeletClientCertificateExpiration
          annotations:
            description: Client certificate for Kubelet on node {{ $labels.node }} expires
              in {{ $value | humanizeDuration }}.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletclientcertificateexpiration
            summary: Kubelet client certificate is about to expire.
          expr: kubelet_certificate_manager_client_ttl_seconds < 86400
          labels:
            severity: critical
        - alert: KubeletServerCertificateExpiration
          annotations:
            description: Server certificate for Kubelet on node {{ $labels.node }} expires
              in {{ $value | humanizeDuration }}.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletservercertificateexpiration
            summary: Kubelet server certificate is about to expire.
          expr: kubelet_certificate_manager_server_ttl_seconds < 604800
          labels:
            severity: warning
        - alert: KubeletServerCertificateExpiration
          annotations:
            description: Server certificate for Kubelet on node {{ $labels.node }} expires
              in {{ $value | humanizeDuration }}.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletservercertificateexpiration
            summary: Kubelet server certificate is about to expire.
          expr: kubelet_certificate_manager_server_ttl_seconds < 86400
          labels:
            severity: critical
        - alert: KubeletClientCertificateRenewalErrors
          annotations:
            description: Kubelet on node {{ $labels.node }} has failed to renew its client
              certificate ({{ $value | humanize }} errors in the last 5 minutes).
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletclientcertificaterenewalerrors
            summary: Kubelet has failed to renew its client certificate.
          expr: increase(kubelet_certificate_manager_client_expiration_renew_errors[5m])
            > 0
          for: 15m
          labels:
            severity: warning
        - alert: KubeletServerCertificateRenewalErrors
          annotations:
            description: Kubelet on node {{ $labels.node }} has failed to renew its server
              certificate ({{ $value | humanize }} errors in the last 5 minutes).
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletservercertificaterenewalerrors
            summary: Kubelet has failed to renew its server certificate.
          expr: increase(kubelet_server_expiration_renew_errors[5m]) > 0
          for: 15m
          labels:
            severity: warning
        - alert: KubeletDown
          annotations:
            description: Kubelet has disappeared from Prometheus target discovery.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletdown
            summary: Target disappeared from Prometheus target discovery.
          expr: absent(up{job="kubelet", metrics_path="/metrics"} == 1)
          for: 15m
          labels:
            severity: critical
      - name: kubernetes-system-scheduler
        rules:
        - alert: KubeSchedulerDown
          annotations:
            description: KubeScheduler has disappeared from Prometheus target discovery.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeschedulerdown
            summary: Target disappeared from Prometheus target discovery.
          expr: absent(up{job="kube-scheduler"} == 1)
          for: 15m
          labels:
            severity: critical
      - name: node-exporter
        rules:
        - alert: NodeFilesystemSpaceFillingUp
          annotations:
            description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has
              only {{ printf "%.2f" $value }}% available space left and is filling up.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemspacefillingup
            summary: Filesystem is predicted to run out of space within the next 24 hours.
          expr: |-
            (
              node_filesystem_avail_bytes{job="node-exporter",fstype!=""} / node_filesystem_size_bytes{job="node-exporter",fstype!=""} * 100 < 15
            and
              predict_linear(node_filesystem_avail_bytes{job="node-exporter",fstype!=""}[6h], 24*60*60) < 0
            and
              node_filesystem_readonly{job="node-exporter",fstype!=""} == 0
            )
          for: 1h
          labels:
            severity: warning
        - alert: NodeFilesystemSpaceFillingUp
          annotations:
            description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has
              only {{ printf "%.2f" $value }}% available space left and is filling up fast.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemspacefillingup
            summary: Filesystem is predicted to run out of space within the next 4 hours.
          expr: |-
            (
              node_filesystem_avail_bytes{job="node-exporter",fstype!=""} / node_filesystem_size_bytes{job="node-exporter",fstype!=""} * 100 < 10
            and
              predict_linear(node_filesystem_avail_bytes{job="node-exporter",fstype!=""}[6h], 4*60*60) < 0
            and
              node_filesystem_readonly{job="node-exporter",fstype!=""} == 0
            )
          for: 1h
          labels:
            severity: critical
        - alert: NodeFilesystemAlmostOutOfSpace
          annotations:
            description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has
              only {{ printf "%.2f" $value }}% available space left.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutofspace
            summary: Filesystem has less than 5% space left.
          expr: |-
            (
              node_filesystem_avail_bytes{job="node-exporter",fstype!=""} / node_filesystem_size_bytes{job="node-exporter",fstype!=""} * 100 < 5
            and
              node_filesystem_readonly{job="node-exporter",fstype!=""} == 0
            )
          for: 30m
          labels:
            severity: warning
        - alert: NodeFilesystemAlmostOutOfSpace
          annotations:
            description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has
              only {{ printf "%.2f" $value }}% available space left.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutofspace
            summary: Filesystem has less than 3% space left.
          expr: |-
            (
              node_filesystem_avail_bytes{job="node-exporter",fstype!=""} / node_filesystem_size_bytes{job="node-exporter",fstype!=""} * 100 < 3
            and
              node_filesystem_readonly{job="node-exporter",fstype!=""} == 0
            )
          for: 30m
          labels:
            severity: critical
        - alert: NodeFilesystemFilesFillingUp
          annotations:
            description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has
              only {{ printf "%.2f" $value }}% available inodes left and is filling up.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemfilesfillingup
            summary: Filesystem is predicted to run out of inodes within the next 24 hours.
          expr: |-
            (
              node_filesystem_files_free{job="node-exporter",fstype!=""} / node_filesystem_files{job="node-exporter",fstype!=""} * 100 < 40
            and
              predict_linear(node_filesystem_files_free{job="node-exporter",fstype!=""}[6h], 24*60*60) < 0
            and
              node_filesystem_readonly{job="node-exporter",fstype!=""} == 0
            )
          for: 1h
          labels:
            severity: warning
        - alert: NodeFilesystemFilesFillingUp
          annotations:
            description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has
              only {{ printf "%.2f" $value }}% available inodes left and is filling up fast.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemfilesfillingup
            summary: Filesystem is predicted to run out of inodes within the next 4 hours.
          expr: |-
            (
              node_filesystem_files_free{job="node-exporter",fstype!=""} / node_filesystem_files{job="node-exporter",fstype!=""} * 100 < 20
            and
              predict_linear(node_filesystem_files_free{job="node-exporter",fstype!=""}[6h], 4*60*60) < 0
            and
              node_filesystem_readonly{job="node-exporter",fstype!=""} == 0
            )
          for: 1h
          labels:
            severity: critical
        - alert: NodeFilesystemAlmostOutOfFiles
          annotations:
            description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has
              only {{ printf "%.2f" $value }}% available inodes left.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutoffiles
            summary: Filesystem has less than 5% inodes left.
          expr: |-
            (
              node_filesystem_files_free{job="node-exporter",fstype!=""} / node_filesystem_files{job="node-exporter",fstype!=""} * 100 < 5
            and
              node_filesystem_readonly{job="node-exporter",fstype!=""} == 0
            )
          for: 1h
          labels:
            severity: warning
        - alert: NodeFilesystemAlmostOutOfFiles
          annotations:
            description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has
              only {{ printf "%.2f" $value }}% available inodes left.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutoffiles
            summary: Filesystem has less than 3% inodes left.
          expr: |-
            (
              node_filesystem_files_free{job="node-exporter",fstype!=""} / node_filesystem_files{job="node-exporter",fstype!=""} * 100 < 3
            and
              node_filesystem_readonly{job="node-exporter",fstype!=""} == 0
            )
          for: 1h
          labels:
            severity: critical
        - alert: NodeNetworkReceiveErrs
          annotations:
            description: '{{ $labels.instance }} interface {{ $labels.device }} has encountered
              {{ printf "%.0f" $value }} receive errors in the last two minutes.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodenetworkreceiveerrs
            summary: Network interface is reporting many receive errors.
          expr: rate(node_network_receive_errs_total[2m]) / rate(node_network_receive_packets_total[2m])
            > 0.01
          for: 1h
          labels:
            severity: warning
        - alert: NodeNetworkTransmitErrs
          annotations:
            description: '{{ $labels.instance }} interface {{ $labels.device }} has encountered
              {{ printf "%.0f" $value }} transmit errors in the last two minutes.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodenetworktransmiterrs
            summary: Network interface is reporting many transmit errors.
          expr: rate(node_network_transmit_errs_total[2m]) / rate(node_network_transmit_packets_total[2m])
            > 0.01
          for: 1h
          labels:
            severity: warning
        - alert: NodeHighNumberConntrackEntriesUsed
          annotations:
            description: '{{ $value | humanizePercentage }} of conntrack entries are used.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodehighnumberconntrackentriesused
            summary: Number of conntrack are getting close to the limit.
          expr: (node_nf_conntrack_entries / node_nf_conntrack_entries_limit) > 0.75
          labels:
            severity: warning
        - alert: NodeTextFileCollectorScrapeError
          annotations:
            description: Node Exporter text file collector failed to scrape.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodetextfilecollectorscrapeerror
            summary: Node Exporter text file collector failed to scrape.
          expr: node_textfile_scrape_error{job="node-exporter"} == 1
          labels:
            severity: warning
        - alert: NodeClockSkewDetected
          annotations:
            description: Clock on {{ $labels.instance }} is out of sync by more than 300s.
              Ensure NTP is configured correctly on this host.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodeclockskewdetected
            summary: Clock skew detected.
          expr: |-
            (
              node_timex_offset_seconds{job="node-exporter"} > 0.05
            and
              deriv(node_timex_offset_seconds{job="node-exporter"}[5m]) >= 0
            )
            or
            (
              node_timex_offset_seconds{job="node-exporter"} < -0.05
            and
              deriv(node_timex_offset_seconds{job="node-exporter"}[5m]) <= 0
            )
          for: 10m
          labels:
            severity: warning
        - alert: NodeClockNotSynchronising
          annotations:
            description: Clock on {{ $labels.instance }} is not synchronising. Ensure NTP
              is configured on this host.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodeclocknotsynchronising
            summary: Clock not synchronising.
          expr: |-
            min_over_time(node_timex_sync_status{job="node-exporter"}[5m]) == 0
            and
            node_timex_maxerror_seconds{job="node-exporter"} >= 16
          for: 10m
          labels:
            severity: warning
        - alert: NodeRAIDDegraded
          annotations:
            description: RAID array '{{ $labels.device }}' on {{ $labels.instance }} is
              in degraded state due to one or more disks failures. Number of spare drives
              is insufficient to fix issue automatically.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/noderaiddegraded
            summary: RAID Array is degraded
          expr: node_md_disks_required{job="node-exporter",device=~"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|dasd.+)"}
            - ignoring (state) (node_md_disks{state="active",job="node-exporter",device=~"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|dasd.+)"})
            > 0
          for: 15m
          labels:
            severity: critical
        - alert: NodeRAIDDiskFailure
          annotations:
            description: At least one device in RAID array on {{ $labels.instance }} failed.
              Array '{{ $labels.device }}' needs attention and possibly a disk swap.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/noderaiddiskfailure
            summary: Failed device in RAID array
          expr: node_md_disks{state="failed",job="node-exporter",device=~"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|dasd.+)"}
            > 0
          labels:
            severity: warning
        - alert: NodeFileDescriptorLimit
          annotations:
            description: File descriptors limit at {{ $labels.instance }} is currently at
              {{ printf "%.2f" $value }}%.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodefiledescriptorlimit
            summary: Kernel is predicted to exhaust file descriptors limit soon.
          expr: |-
            (
              node_filefd_allocated{job="node-exporter"} * 100 / node_filefd_maximum{job="node-exporter"} > 70
            )
          for: 15m
          labels:
            severity: warning
        - alert: NodeFileDescriptorLimit
          annotations:
            description: File descriptors limit at {{ $labels.instance }} is currently at
              {{ printf "%.2f" $value }}%.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/node/nodefiledescriptorlimit
            summary: Kernel is predicted to exhaust file descriptors limit soon.
          expr: |-
            (
              node_filefd_allocated{job="node-exporter"} * 100 / node_filefd_maximum{job="node-exporter"} > 90
            )
          for: 15m
          labels:
            severity: critical
      - name: node-exporter.rules
        rules:
        - expr: |-
            count without (cpu, mode) (
              node_cpu_seconds_total{job="node-exporter",mode="idle"}
            )
          record: instance:node_num_cpu:sum
        - expr: |-
            1 - avg without (cpu) (
              sum without (mode) (rate(node_cpu_seconds_total{job="node-exporter", mode=~"idle|iowait|steal"}[5m]))
            )
          record: instance:node_cpu_utilisation:rate5m
        - expr: |-
            (
              node_load1{job="node-exporter"}
            /
              instance:node_num_cpu:sum{job="node-exporter"}
            )
          record: instance:node_load1_per_cpu:ratio
        - expr: |-
            1 - (
              (
                node_memory_MemAvailable_bytes{job="node-exporter"}
                or
                (
                  node_memory_Buffers_bytes{job="node-exporter"}
                  +
                  node_memory_Cached_bytes{job="node-exporter"}
                  +
                  node_memory_MemFree_bytes{job="node-exporter"}
                  +
                  node_memory_Slab_bytes{job="node-exporter"}
                )
              )
            /
              node_memory_MemTotal_bytes{job="node-exporter"}
            )
          record: instance:node_memory_utilisation:ratio
        - expr: rate(node_vmstat_pgmajfault{job="node-exporter"}[5m])
          record: instance:node_vmstat_pgmajfault:rate5m
        - expr: rate(node_disk_io_time_seconds_total{job="node-exporter", device=~"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|dasd.+)"}[5m])
          record: instance_device:node_disk_io_time_seconds:rate5m
        - expr: rate(node_disk_io_time_weighted_seconds_total{job="node-exporter", device=~"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|dasd.+)"}[5m])
          record: instance_device:node_disk_io_time_weighted_seconds:rate5m
        - expr: |-
            sum without (device) (
              rate(node_network_receive_bytes_total{job="node-exporter", device!="lo"}[5m])
            )
          record: instance:node_network_receive_bytes_excluding_lo:rate5m
        - expr: |-
            sum without (device) (
              rate(node_network_transmit_bytes_total{job="node-exporter", device!="lo"}[5m])
            )
          record: instance:node_network_transmit_bytes_excluding_lo:rate5m
        - expr: |-
            sum without (device) (
              rate(node_network_receive_drop_total{job="node-exporter", device!="lo"}[5m])
            )
          record: instance:node_network_receive_drop_excluding_lo:rate5m
        - expr: |-
            sum without (device) (
              rate(node_network_transmit_drop_total{job="node-exporter", device!="lo"}[5m])
            )
          record: instance:node_network_transmit_drop_excluding_lo:rate5m
      - name: node-network
        rules:
        - alert: NodeNetworkInterfaceFlapping
          annotations:
            description: Network interface "{{ $labels.device }}" changing its up status
              often on node-exporter {{ $labels.namespace }}/{{ $labels.pod }}
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/general/nodenetworkinterfaceflapping
            summary: Network interface is often changing its status
          expr: changes(node_network_up{job="node-exporter",device!~"veth.+"}[2m]) > 2
          for: 2m
          labels:
            severity: warning
      - name: node.rules
        rules:
        - expr: |-
            topk by(cluster, namespace, pod) (1,
              max by (cluster, node, namespace, pod) (
                label_replace(kube_pod_info{job="kube-state-metrics",node!=""}, "pod", "$1", "pod", "(.*)")
            ))
          record: 'node_namespace_pod:kube_pod_info:'
        - expr: |-
            count by (cluster, node) (sum by (node, cpu) (
              node_cpu_seconds_total{job="node-exporter"}
            * on (namespace, pod) group_left(node)
              topk by(namespace, pod) (1, node_namespace_pod:kube_pod_info:)
            ))
          record: node:node_num_cpu:sum
        - expr: |-
            sum(
              node_memory_MemAvailable_bytes{job="node-exporter"} or
              (
                node_memory_Buffers_bytes{job="node-exporter"} +
                node_memory_Cached_bytes{job="node-exporter"} +
                node_memory_MemFree_bytes{job="node-exporter"} +
                node_memory_Slab_bytes{job="node-exporter"}
              )
            ) by (cluster)
          record: :node_memory_MemAvailable_bytes:sum
        - expr: |-
            sum(rate(node_cpu_seconds_total{job="node-exporter",mode!="idle",mode!="iowait",mode!="steal"}[5m])) /
            count(sum(node_cpu_seconds_total{job="node-exporter"}) by (cluster, instance, cpu))
          record: cluster:node_cpu:ratio_rate5m
      - name: prometheus
        rules:
        - alert: PrometheusBadConfig
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} has failed to
              reload its configuration.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusbadconfig
            summary: Failed Prometheus configuration reload.
          expr: |-
            # Without max_over_time, failed scrapes could create false negatives, see
            # https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.
            max_over_time(prometheus_config_last_reload_successful{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m]) == 0
          for: 10m
          labels:
            severity: critical
        - alert: PrometheusNotificationQueueRunningFull
          annotations:
            description: Alert notification queue of Prometheus {{$labels.namespace}}/{{$labels.pod}}
              is running full.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusnotificationqueuerunningfull
            summary: Prometheus alert notification queue predicted to run full in less than
              30m.
          expr: |-
            # Without min_over_time, failed scrapes could create false negatives, see
            # https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.
            (
              predict_linear(prometheus_notifications_queue_length{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m], 60 * 30)
            >
              min_over_time(prometheus_notifications_queue_capacity{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            )
          for: 15m
          labels:
            severity: warning
        - alert: PrometheusErrorSendingAlertsToSomeAlertmanagers
          annotations:
            description: '{{ printf "%.1f" $value }}% errors while sending alerts from Prometheus
              {{$labels.namespace}}/{{$labels.pod}} to Alertmanager {{$labels.alertmanager}}.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheuserrorsendingalertstosomealertmanagers
            summary: Prometheus has encountered more than 1% errors sending alerts to a
              specific Alertmanager.
          expr: |-
            (
              rate(prometheus_notifications_errors_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            /
              rate(prometheus_notifications_sent_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            )
            * 100
            > 1
          for: 15m
          labels:
            severity: warning
        - alert: PrometheusNotConnectedToAlertmanagers
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} is not connected
              to any Alertmanagers.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusnotconnectedtoalertmanagers
            summary: Prometheus is not connected to any Alertmanagers.
          expr: |-
            # Without max_over_time, failed scrapes could create false negatives, see
            # https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.
            max_over_time(prometheus_notifications_alertmanagers_discovered{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m]) < 1
          for: 10m
          labels:
            severity: warning
        - alert: PrometheusTSDBReloadsFailing
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} has detected {{$value
              | humanize}} reload failures over the last 3h.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheustsdbreloadsfailing
            summary: Prometheus has issues reloading blocks from disk.
          expr: increase(prometheus_tsdb_reloads_failures_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[3h])
            > 0
          for: 4h
          labels:
            severity: warning
        - alert: PrometheusTSDBCompactionsFailing
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} has detected {{$value
              | humanize}} compaction failures over the last 3h.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheustsdbcompactionsfailing
            summary: Prometheus has issues compacting blocks.
          expr: increase(prometheus_tsdb_compactions_failed_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[3h])
            > 0
          for: 4h
          labels:
            severity: warning
        - alert: PrometheusNotIngestingSamples
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} is not ingesting
              samples.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusnotingestingsamples
            summary: Prometheus is not ingesting samples.
          expr: |-
            (
              rate(prometheus_tsdb_head_samples_appended_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m]) <= 0
            and
              (
                sum without(scrape_job) (prometheus_target_metadata_cache_entries{job="promstack-kube-prometheus-prometheus",namespace="default"}) > 0
              or
                sum without(rule_group) (prometheus_rule_group_rules{job="promstack-kube-prometheus-prometheus",namespace="default"}) > 0
              )
            )
          for: 10m
          labels:
            severity: warning
        - alert: PrometheusDuplicateTimestamps
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} is dropping {{
              printf "%.4g" $value  }} samples/s with different values but duplicated timestamp.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusduplicatetimestamps
            summary: Prometheus is dropping samples with duplicate timestamps.
          expr: rate(prometheus_target_scrapes_sample_duplicate_timestamp_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            > 0
          for: 10m
          labels:
            severity: warning
        - alert: PrometheusOutOfOrderTimestamps
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} is dropping {{
              printf "%.4g" $value  }} samples/s with timestamps arriving out of order.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusoutofordertimestamps
            summary: Prometheus drops samples with out-of-order timestamps.
          expr: rate(prometheus_target_scrapes_sample_out_of_order_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            > 0
          for: 10m
          labels:
            severity: warning
        - alert: PrometheusRemoteStorageFailures
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} failed to send
              {{ printf "%.1f" $value }}% of the samples to {{ $labels.remote_name}}:{{
              $labels.url }}
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusremotestoragefailures
            summary: Prometheus fails to send samples to remote storage.
          expr: |-
            (
              (rate(prometheus_remote_storage_failed_samples_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m]) or rate(prometheus_remote_storage_samples_failed_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m]))
            /
              (
                (rate(prometheus_remote_storage_failed_samples_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m]) or rate(prometheus_remote_storage_samples_failed_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m]))
              +
                (rate(prometheus_remote_storage_succeeded_samples_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m]) or rate(prometheus_remote_storage_samples_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m]))
              )
            )
            * 100
            > 1
          for: 15m
          labels:
            severity: critical
        - alert: PrometheusRemoteWriteBehind
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} remote write is
              {{ printf "%.1f" $value }}s behind for {{ $labels.remote_name}}:{{ $labels.url
              }}.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusremotewritebehind
            summary: Prometheus remote write is behind.
          expr: |-
            # Without max_over_time, failed scrapes could create false negatives, see
            # https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.
            (
              max_over_time(prometheus_remote_storage_highest_timestamp_in_seconds{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            - ignoring(remote_name, url) group_right
              max_over_time(prometheus_remote_storage_queue_highest_sent_timestamp_seconds{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            )
            > 120
          for: 15m
          labels:
            severity: critical
        - alert: PrometheusRemoteWriteDesiredShards
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} remote write desired
              shards calculation wants to run {{ $value }} shards for queue {{ $labels.remote_name}}:{{
              $labels.url }}, which is more than the max of {{ printf `prometheus_remote_storage_shards_max{instance="%s",job="promstack-kube-prometheus-prometheus",namespace="default"}`
              $labels.instance | query | first | value }}.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusremotewritedesiredshards
            summary: Prometheus remote write desired shards calculation wants to run more
              than configured max shards.
          expr: |-
            # Without max_over_time, failed scrapes could create false negatives, see
            # https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.
            (
              max_over_time(prometheus_remote_storage_shards_desired{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            >
              max_over_time(prometheus_remote_storage_shards_max{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            )
          for: 15m
          labels:
            severity: warning
        - alert: PrometheusRuleFailures
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} has failed to
              evaluate {{ printf "%.0f" $value }} rules in the last 5m.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusrulefailures
            summary: Prometheus is failing rule evaluations.
          expr: increase(prometheus_rule_evaluation_failures_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            > 0
          for: 15m
          labels:
            severity: critical
        - alert: PrometheusMissingRuleEvaluations
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} has missed {{
              printf "%.0f" $value }} rule group evaluations in the last 5m.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusmissingruleevaluations
            summary: Prometheus is missing rule evaluations due to slow rule group evaluation.
          expr: increase(prometheus_rule_group_iterations_missed_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            > 0
          for: 15m
          labels:
            severity: warning
        - alert: PrometheusTargetLimitHit
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} has dropped {{
              printf "%.0f" $value }} targets because the number of targets exceeded the
              configured target_limit.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheustargetlimithit
            summary: Prometheus has dropped targets because some scrape configs have exceeded
              the targets limit.
          expr: increase(prometheus_target_scrape_pool_exceeded_target_limit_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            > 0
          for: 15m
          labels:
            severity: warning
        - alert: PrometheusLabelLimitHit
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} has dropped {{
              printf "%.0f" $value }} targets because some samples exceeded the configured
              label_limit, label_name_length_limit or label_value_length_limit.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheuslabellimithit
            summary: Prometheus has dropped targets because some scrape configs have exceeded
              the labels limit.
          expr: increase(prometheus_target_scrape_pool_exceeded_label_limits_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            > 0
          for: 15m
          labels:
            severity: warning
        - alert: PrometheusScrapeBodySizeLimitHit
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} has failed {{
              printf "%.0f" $value }} scrapes in the last 5m because some targets exceeded
              the configured body_size_limit.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusscrapebodysizelimithit
            summary: Prometheus has dropped some targets that exceeded body size limit.
          expr: increase(prometheus_target_scrapes_exceeded_body_size_limit_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            > 0
          for: 15m
          labels:
            severity: warning
        - alert: PrometheusScrapeSampleLimitHit
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} has failed {{
              printf "%.0f" $value }} scrapes in the last 5m because some targets exceeded
              the configured sample_limit.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusscrapesamplelimithit
            summary: Prometheus has failed scrapes that have exceeded the configured sample
              limit.
          expr: increase(prometheus_target_scrapes_exceeded_sample_limit_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            > 0
          for: 15m
          labels:
            severity: warning
        - alert: PrometheusTargetSyncFailure
          annotations:
            description: '{{ printf "%.0f" $value }} targets in Prometheus {{$labels.namespace}}/{{$labels.pod}}
              have failed to sync because invalid configuration was supplied.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheustargetsyncfailure
            summary: Prometheus has failed to sync targets.
          expr: increase(prometheus_target_sync_failed_total{job="promstack-kube-prometheus-prometheus",namespace="default"}[30m])
            > 0
          for: 5m
          labels:
            severity: critical
        - alert: PrometheusHighQueryLoad
          annotations:
            description: Prometheus {{$labels.namespace}}/{{$labels.pod}} query API has
              less than 20% available capacity in its query engine for the last 15 minutes.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheushighqueryload
            summary: Prometheus is reaching its maximum capacity serving concurrent requests.
          expr: avg_over_time(prometheus_engine_queries{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            / max_over_time(prometheus_engine_queries_concurrent_max{job="promstack-kube-prometheus-prometheus",namespace="default"}[5m])
            > 0.8
          for: 15m
          labels:
            severity: warning
        - alert: PrometheusErrorSendingAlertsToAnyAlertmanager
          annotations:
            description: '{{ printf "%.1f" $value }}% minimum errors while sending alerts
              from Prometheus {{$labels.namespace}}/{{$labels.pod}} to any Alertmanager.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheuserrorsendingalertstoanyalertmanager
            summary: Prometheus encounters more than 3% errors sending alerts to any Alertmanager.
          expr: |-
            min without (alertmanager) (
              rate(prometheus_notifications_errors_total{job="promstack-kube-prometheus-prometheus",namespace="default",alertmanager!~``}[5m])
            /
              rate(prometheus_notifications_sent_total{job="promstack-kube-prometheus-prometheus",namespace="default",alertmanager!~``}[5m])
            )
            * 100
            > 3
          for: 15m
          labels:
            severity: critical
      - name: prometheus-operator
        rules:
        - alert: PrometheusOperatorListErrors
          annotations:
            description: Errors while performing List operations in controller {{$labels.controller}}
              in {{$labels.namespace}} namespace.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorlisterrors
            summary: Errors while performing list operations in controller.
          expr: (sum by (controller,namespace) (rate(prometheus_operator_list_operations_failed_total{job="promstack-kube-prometheus-operator",namespace="default"}[10m]))
            / sum by (controller,namespace) (rate(prometheus_operator_list_operations_total{job="promstack-kube-prometheus-operator",namespace="default"}[10m])))
            > 0.4
          for: 15m
          labels:
            severity: warning
        - alert: PrometheusOperatorWatchErrors
          annotations:
            description: Errors while performing watch operations in controller {{$labels.controller}}
              in {{$labels.namespace}} namespace.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorwatcherrors
            summary: Errors while performing watch operations in controller.
          expr: (sum by (controller,namespace) (rate(prometheus_operator_watch_operations_failed_total{job="promstack-kube-prometheus-operator",namespace="default"}[5m]))
            / sum by (controller,namespace) (rate(prometheus_operator_watch_operations_total{job="promstack-kube-prometheus-operator",namespace="default"}[5m])))
            > 0.4
          for: 15m
          labels:
            severity: warning
        - alert: PrometheusOperatorSyncFailed
          annotations:
            description: Controller {{ $labels.controller }} in {{ $labels.namespace }}
              namespace fails to reconcile {{ $value }} objects.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorsyncfailed
            summary: Last controller reconciliation failed
          expr: min_over_time(prometheus_operator_syncs{status="failed",job="promstack-kube-prometheus-operator",namespace="default"}[5m])
            > 0
          for: 10m
          labels:
            severity: warning
        - alert: PrometheusOperatorReconcileErrors
          annotations:
            description: '{{ $value | humanizePercentage }} of reconciling operations failed
              for {{ $labels.controller }} controller in {{ $labels.namespace }} namespace.'
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorreconcileerrors
            summary: Errors while reconciling controller.
          expr: (sum by (controller,namespace) (rate(prometheus_operator_reconcile_errors_total{job="promstack-kube-prometheus-operator",namespace="default"}[5m])))
            / (sum by (controller,namespace) (rate(prometheus_operator_reconcile_operations_total{job="promstack-kube-prometheus-operator",namespace="default"}[5m])))
            > 0.1
          for: 10m
          labels:
            severity: warning
        - alert: PrometheusOperatorNodeLookupErrors
          annotations:
            description: Errors while reconciling Prometheus in {{ $labels.namespace }}
              Namespace.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatornodelookuperrors
            summary: Errors while reconciling Prometheus.
          expr: rate(prometheus_operator_node_address_lookup_errors_total{job="promstack-kube-prometheus-operator",namespace="default"}[5m])
            > 0.1
          for: 10m
          labels:
            severity: warning
        - alert: PrometheusOperatorNotReady
          annotations:
            description: Prometheus operator in {{ $labels.namespace }} namespace isn't
              ready to reconcile {{ $labels.controller }} resources.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatornotready
            summary: Prometheus operator not ready
          expr: min by (controller,namespace) (max_over_time(prometheus_operator_ready{job="promstack-kube-prometheus-operator",namespace="default"}[5m])
            == 0)
          for: 5m
          labels:
            severity: warning
        - alert: PrometheusOperatorRejectedResources
          annotations:
            description: Prometheus operator in {{ $labels.namespace }} namespace rejected
              {{ printf "%0.0f" $value }} {{ $labels.controller }}/{{ $labels.resource }}
              resources.
            runbook_url: https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorrejectedresources
            summary: Resources rejected by Prometheus operator
          expr: min_over_time(prometheus_operator_managed_resources{state="rejected",job="promstack-kube-prometheus-operator",namespace="default"}[5m])
            > 0
          for: 5m
          labels:
            severity: warning
      - name: application-high-error-rate
        rules:
        - alert: ApplicationHighErrorRate
          annotations:
            description: Error rate greater than 3% in {{$labels.server}} application.
            summary: High error rate in application.
          expr: sum(rate(traces_spanmetrics_calls_total{span_status="STATUS_CODE_ERROR"}[1m])) by (service)/sum(rate(traces_spanmetrics_calls_total[1m])) by (service) > 0.03
          for: 1m
          labels:
            severity: warning
  rbac:
    create: false
  alertmanager:
    enabled: true
  kubeStateMetrics:
    enabled: true
  kube-state-metrics:
    prometheus:
      monitor:
        enabled: true
  nodeExporter:
    enabled: true
  pushgateway:
    enabled: false
  server:
    persistentVolume:
      enabled: true
      size: 50Gi
    extraFlags:
      - web.enable-lifecycle
      - web.enable-remote-write-receiver
      - enable-feature=exemplar-storage
    deploymentAnnotations:
      odigos.io/skip: "true"
tempo:
  # persistence:
  #   enabled: true
  annotations: 
    odigos.io/skip: "true"
  config: |
    metrics_generator_enabled: true
    search_enabled: true
    multitenancy_enabled: {{ .Values.tempo.multitenancyEnabled }}
    compactor:
      compaction:
        compacted_block_retention: {{ .Values.tempo.retention }}
    distributor:
      receivers:
        {{- toYaml .Values.tempo.receivers | nindent 8 }}
    ingester:
      {{- toYaml .Values.tempo.ingester | nindent 6 }}
    server:
      {{- toYaml .Values.tempo.server | nindent 6 }}
    storage:
      {{- toYaml .Values.tempo.storage | nindent 6 }}
    overrides:
      per_tenant_override_config: /conf/overrides.yaml
      metrics_generator_processors:
        - service-graphs
        - span-metrics
    metrics_generator:
      storage:
        path: /var/tempo/wal
        remote_write:
          - url: http://${release_name}-prometheus-server.observability/api/v1/write
            send_exemplars: true
loki:
  extraArgs:
    target: all,table-manager
  rbac:
    pspEnabled: false
  annotations:
    odigos.io/skip: "true"
  resources: 
    limits:
      cpu: 2000m
      memory: 2048Mi
    requests:
      cpu: 2000m
      memory: 2048Mi
  config:
    schema_config:
      configs:
      - from: 2020-10-30
        store: aws
        object_store: s3
        schema: v11
        index:
          prefix: ${index_prefix}
          period: 24h
    storage_config:
      aws:
        s3: s3://${aws_region}/${loki_bucket}
        dynamodb:
          dynamodb_url: dynamodb://${aws_region}
    table_manager:
      retention_deletes_enabled: true
      retention_period: 336h
      index_tables_provisioning:
        enable_ondemand_throughput_mode: true
        enable_inactive_throughput_on_demand_mode: true
      chunk_tables_provisioning:
        enable_ondemand_throughput_mode: true
        enable_inactive_throughput_on_demand_mode: true
grafana:
  persistence:
    enabled: true
  image:
    tag: 9.1.2
  rbac:
    pspEnabled: false
  annotations:
    odigos.io/skip: "true"
  grafana.ini:
    paths:
      data: /var/lib/grafana/
      logs: /var/log/grafana
      plugins: /var/lib/grafana/plugins
      provisioning: /etc/grafana/provisioning
    analytics:
      check_for_updates: true
    log:
      mode: console
    grafana_net:
      url: https://grafana.net
    feature_toggles:
      enable: tempoSearch, tempoBackendSearch, tempoApmTable, traceToMetrics
  datasources:
    datasources.yaml:
      apiVersion: 1
      datasources:
      - name: Prometheus
        type: prometheus
        uid: Prometheus
        url: http://${release_name}-prometheus-server.observability
        access: proxy
        isDefault: true
        jsonData:
          httpMethod: POST
          exemplarTraceIdDestinations:
            - datasourceUid: Tempo
              name: traceID
      - name: Loki
        type: loki
        uid: Loki
        access: proxy
        url: "http://${release_name}-loki.observability:3100"
        correlations:
        - targetUID: Tempo
          label: "Tempo traces"
          description: "Related traces stored in Tempo"
        jsonData:
          timeout: 60
          derivedFields:
            - name: "traceID"
              matcherRegex: "trace_id=(\\w+)"
              url: "$${__value.raw}"
              datasourceUid: Tempo
      - name: Tempo
        type: tempo
        uid: Tempo
        access: proxy
        url: "http://${release_name}-tempo.observability:3100"
        jsonData:
          httpMethod: GET
          tracesToMetrics:
            datasourceUid: 'Prometheus'
          tracesToLogs:
            datasourceUid: 'Loki'
            tags: ['k8s.pod.name']
            mappedTags: [{ key: 'k8s.pod.name', value: 'k8s_pod_name' }]
            mapTagNamesEnabled: true
            spanStartTimeShift: '-1h'
            spanEndTimeShift: '1h'
            filterByTraceID: true
            filterBySpanID: false
          serviceMap:
            datasourceUid: 'Prometheus'
          search:
            hide: false
          nodeGraph:
            enabled: true
          lokiSearch:
            datasourceUid: 'Loki'
  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
      - name: 'default'
        orgId: 1
        folder: ''
        type: file
        disableDeletion: true
        editable: false
        options:
          path: /var/lib/grafana/dashboards/default
  dashboards:
    default:
      coresignals:
        json: |
          ${indent(10, file("${pathmodule}/templates/dashboards/coresignals.json"))}
      apiserver:
        json: |
          ${indent(10, file("${pathmodule}/templates/dashboards/apiserver.json"))}
      cluster-total:
        json: |
          ${indent(10, file("${pathmodule}/templates/dashboards/cluster-total.json"))}
      k8s-resources-namespace:
        json: |
          ${indent(10, file("${pathmodule}/templates/dashboards/k8s-resources-namespace.json"))}