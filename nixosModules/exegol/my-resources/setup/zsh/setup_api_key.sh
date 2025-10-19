# urlfinder
yq-go ".urlscan = [${URLSCAN_API_KEY}]" /root/.config/urlfinder/provider-config.yaml
yq-go ".virustotal = [${VIRUSTOTAL_API_KEY}]" /root/.config/urlfinder/provider-config.yaml

# subfinder
yq-go ".virustotal = [${VIRUSTOTAL_API_KEY}]" /root/.config/subfinder/provider-config.yaml
yq-go ".shodan = [${SHODAN_API_KEY}]" /root/.config/subfinder/provider-config.yaml
yq-go ".censys = [${CENSYS_API_KEY}]" /root/.config/subfinder/provider-config.yaml
yq-go ".dnsdumpster = [${DNSDUMPSTER_API_KEY}]" /root/.config/subfinder/provider-config.yaml
