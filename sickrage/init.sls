
{% from "sickrage/map.jinja" import sickrage with context %}

include:
  - sickrage.package
  - python.set_version27

# start the sickrage process
sickrage:
  service.running:
    - enable: True
    - name: {{ sickrage.service }}
    - require:
      - file: sickrage_service_file
      - sls: sickrage.package
      - sls: python.set_version27
    - watch:
      - file: sickrage_service_config

# create the sickrage service config file (default data to run the service)
sickrage_service_config:
  file.managed:
    - name: {{ sickrage.service_config }}
    - source: {{ sickrage.service_config_src }} 
    - template: jinja
    - require:
      - git: sickrage-git

# create the service init file, load data from the service config file
sickrage_service_file:
  file.managed:
    - name: {{ sickrage.service_file }}
    - source: {{ sickrage.service_file_src }} 
    - template: jinja
    - require:
      - file: sickrage_service_config
      - git: sickrage-git