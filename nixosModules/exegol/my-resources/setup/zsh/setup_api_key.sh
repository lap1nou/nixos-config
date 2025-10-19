# urlfinder
yq-go -i ".urlscan = [\"${URLSCAN_API_KEY}\"]" /root/.config/urlfinder/provider-config.yaml
yq-go -i ".virustotal = [\"${VIRUSTOTAL_API_KEY}\"]" /root/.config/urlfinder/provider-config.yaml

# subfinder
yq-go -i ".virustotal = [\"${VIRUSTOTAL_API_KEY}\"]" /root/.config/subfinder/provider-config.yaml
yq-go -i ".shodan = [\"${SHODAN_API_KEY}\"]" /root/.config/subfinder/provider-config.yaml
yq-go -i ".censys = [\"${CENSYS_API_KEY}\"]" /root/.config/subfinder/provider-config.yaml
yq-go -i ".dnsdumpster = [\"${DNSDUMPSTER_API_KEY}\"]" /root/.config/subfinder/provider-config.yaml
