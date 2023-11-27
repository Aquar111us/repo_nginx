#/bin/bash
nexus_url=http://localhost:8081
nexus_user="admin:$(cat /opt/nexus/nexus-data/admin.password)"
until curl -ksf "${nexus_url}/service/rest/v1/status" ; do sleep 10 ; done
sleep 120
until \
      curl "${nexus_url}/service/rest/v1/security/realms/active" \
      -XPUT -sfu "${nexus_user}" \
      -H 'Content-Type: application/json' \
      -d '["NexusAuthenticatingRealm","NexusAuthorizingRealm","LdapRealm","DockerToken"]'
    do sleep 10; done
curl -sfu "${nexus_user}" "${nexus_url}/service/rest/v1/repositories/docker/proxy" \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'accept: application/json' \
  -H 'X-Nexus-UI: true' \
  -d '{"name":"docker_proxy","online":true,"storage":{"blobStoreName":"default","strictContentTypeValidation":true,"writePolicy":"ALLOW"},"cleanup":null,"docker":{"v1Enabled":false,"forceBasicAuth":true,"httpPort":8086,"httpsPort":null,"subdomain":null},"dockerProxy":{"indexType":"HUB","indexUrl":null,"cacheForeignLayers":true,"foreignLayerUrlWhitelist":[".*"]},"proxy":{"remoteUrl":"https://nexus.draszi.fintech.ru/repository/devolopment-dump/t.okhanov/","contentMaxAge":-1,"metadataMaxAge":-1},"negativeCache":{"enabled":false,"timeToLive":1440},"httpClient":{"blocked":false,"autoBlock":true,"connection":{"retries":null,"userAgentSuffix":null,"timeout":null,"enableCircularRedirects":false,"enableCookies":false,"useTrustStore":false},"authentication":null},"routingRuleName":null,"format":"docker","type":"proxy"}'

