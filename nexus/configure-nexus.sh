#/bin/bash
set -x
nexus_url=http://localhost:8081
until curl -ksf "${nexus_url}/service/rest/v1/status" ; do sleep 10 ; done
nexus_user="admin:$(cat /opt/nexus/nexus-data/admin.password)"
sleep 120
until \
      curl "${nexus_url}/service/rest/v1/security/realms/active" \
      -XPUT -sfu "${nexus_user}" \
      -H 'Content-Type: application/json' \
      -d '["NexusAuthenticatingRealm","DockerToken"]'
    do sleep 10; done
curl -sfu "${nexus_user}" "${nexus_url}/service/rest/v1/repositories/yum/proxy" \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'accept: application/json' \
  -H 'X-Nexus-UI: true' \
  -d '{"name":"yum-proxy3","online":true,"storage":{"blobStoreName":"default","strictContentTypeValidation":true},"cleanup":{"policyNames":["string"]},"proxy":{"remoteUrl":"https://nexus.draszi.fintech.ru/repository/devolopment-dump/t.okhanov/","contentMaxAge":"-1","metadataMaxAge":"1"},"negativeCache":{"enabled":false,"timeToLive":"1440"},"httpClient":{"blocked":false,"autoBlock":true,"connection":{"retries":"0","userAgentSuffix":"string","timeout":"60","enableCircularRedirects":false,"enableCookies":false,"useTrustStore":false},"authentication":{"type":"username","username":"string","password":"string","ntlmHost":"string","ntlmDomain":"string"}},"routingRule":"string","replication":{"preemptivePullEnabled":false,"assetPathRegex":"string"},"yumSigning":{"keypair":"string","passphrase":"string"}}'