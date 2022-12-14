{{- if .secretsProviderClass.enabled }}
secretsProviderClass:
  enabled: true
  secretPath: {{ .secretsProviderClass.secretPath }}
  vaultAddress: {{ .secretsProviderClass.vaultAddress }}
{{- end }}

kong:
  enabled: true

  image:
    repository: kong/kong-gateway
    tag: {{.imageTag}}

  env:
    database: "off"

    lua_ssl_trusted_certificate: /etc/secrets/konnect-certificate/tls.crt,system

    ssl_cert: /etc/secrets/kong-proxy-certificate/tls.crt
    ssl_cert_key: /etc/secrets/kong-proxy-certificate/tls.key

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
  - kong-proxy-certificate

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
      hostname: {{ .ingressDomain }}

  postgresql:
    enabled: false

  ingressController:
    enabled: false
    installCRDs: false
