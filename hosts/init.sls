# vim: sts=2 ts=2 sw=2 et ai
{% from "hosts/map.jinja" import hosts with context %}

{% if hosts.present is defined %}
{% for host, host_data in hosts.present.items()|sort -%}

hosts__entry_{{host}}_present:
  file.replace:
    - name: /etc/hosts
    - pattern: ^\s*{{host_data.ip|replace('.','\.')}}\s+.*$
    - repl: "{{host_data.ip}} {{host_data.names|join(' ')}}"
    - count: 1
    - append_if_not_found: True

{% endfor -%}
{% endif -%}


{% if hosts.absent is defined %}
{% for host, host_data in hosts.absent.items()|sort -%}
hosts__entry_{{host}}_absent:
  file.replace:
    - name: /etc/hosts
    - pattern: ^.*\b{{host|replace('.','\.')}}\b.*$\n
    - repl: ''
    - bufsize: file

{% endfor -%}
{% endif -%}

