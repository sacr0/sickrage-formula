
{% from "sickrage/map.jinja" import sickrage with context %}

include:
  - sickrage.package

sickrage:
  service.running:
    - enable: True
    - name: {{ sickrage.service }}
    - require:
      - file: sickrage_service_file
      - sls: sickrage.package
    - watch:
      - file: sickrage_service_config

sickrage_service_config:
  file.managed:
    - name: {{ sickrage.service_config }}
    - source: {{ sickrage.service_config_src }} 
    - template: jinja
    - require:
      - git: sickrage-git

sickrage_service_file:
  file.managed:
    - name: {{ sickrage.service_file }}
    - source: {{ sickrage.service_file_src }} 
    - template: jinja
    - require:
      - file: sickrage_service_config
      - git: sickrage-git