kong:
  enabled: true

  image:
    repository: kong/kong-gateway
    tag: {{var:imageTag}}

  env:
    database: "off"

    lua_ssl_trusted_certificate: /etc/secrets/konnect-certificate/tls.crt,system

    role: data_plane
    cluster_mtls: pki
    cluster_control_plane: 1315ce7884.us.cp0.konghq.com:443
    cluster_server_name: 1315ce7884.us.cp0.konghq.com
    cluster_telemetry_endpoint: 1315ce7884.us.tp0.konghq.com:443
    cluster_telemetry_server_name: 1315ce7884.us.tp0.konghq.com
    cluster_cert: /etc/secrets/kong-cluster-cert-tysoe-1/tls.crt
    cluster_cert_key: /etc/secrets/kong-cluster-cert-tysoe-1/tls.key

  secretVolumes:
  - konnect-certificate

  proxy:
    enabled: true
    type: ClusterIP
    http:
      enabled: false
      servicePort: 8000
      containerPort: 8000
    tls:
      enabled: true
      containerPort: 8443
      servicePort: 8443
      parameters:
      - http2
    ingress:
      enabled: true
      hostname: {{var:ingressDomain}}

  postgresql:
    enabled: false

  ingressController:
    enabled: false
    installCRDs: false
