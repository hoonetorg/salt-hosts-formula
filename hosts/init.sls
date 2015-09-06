# vim: sts=2 ts=2 sw=2 et ai
{% from "hosts/map.jinja" import hosts with context %}

{% for host, host_data in hosts.present.items()|sort -%}

### !!!! problem names will be reordered randomly, but if an order should be ensured - no chance
#hosts__entry_{{host}}_present:
#  host.present:
#    - ip: {{ host.ip }}
#    - names: {{ host.names }}
hosts__entry_{{host}}_present:
  file.replace:
    - name: /etc/hosts
    - pattern: ^\s*{{host.ip|replace('.','\.')}}\s+.*$
    - repl: "{{host.ip}} {{host.names}}"
    - count: 1
    - append_if_not_found: True

{% endfor -%}

#FIXME: implement host removal
#inspired by conversation with mpanetta on freenode #salt irc channel http://irclog.perlgeek.de/salt/2015-09-03
# cat /etc/hosts |sed -r "/\b{{host|replace('.','\.')}}\b/d"
# pattern: ^\s*[0-9]{1,3}\.){3}[0-9]{1,3}.*\b{{host|replace('.','\.')}}\b

{% for host, host_data in hosts.absent.items()|sort -%}
hosts__entry_{{host}}_absent:
  file.replace:
    - name: /etc/hosts
    - pattern: \b{{host|replace('.','\.')}}\b.*\n
    - repl: ''
    - count: 1
    - bufsize: file

{% endfor -%}

