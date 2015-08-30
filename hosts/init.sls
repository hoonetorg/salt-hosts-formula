# vim: sts=2 ts=2 sw=2 et ai
{% from "hosts/map.jinja" import hosts with context %}

{% for datasource, datasource_data in hosts.datasources.items()|sort -%}
{% for host, host_data in salt['pillar.get'](datasource, {}).items()|sort -%}
{% set hostip = salt['pillar.get'](datasource + ":" + host + ":" + datasource_data.ipsource) %}
{% set hostcnames = salt['pillar.get'](datasource + ":" + host + ":" + datasource_data.cnamessource, []) %}

### !!!! problem names will be reordered randomly, but if an order should be ensured - no chance
#hosts__entry_{{host}}:
#  host.present:
#    - ip: {{ hostip }}
#    - names:
#      - {{host}}
#      - {{host.split('.')[0]}}
#      -  {{hostcnames|join(' ')}}
hosts__entry_{{host}}:
  file.replace:
    - name: /etc/hosts
    - pattern: ^\s*{{hostip}}\s+.*$
    - repl: "{{hostip}} {{host}} {{host.split('.')[0]}}  {{hostcnames|join(' ')}}"
    - count: 1
    - append_if_not_found: True

{% endfor -%}
{% endfor -%}

