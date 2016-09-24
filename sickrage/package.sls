include:
  - git.main
  - python.set_version27

{% from "sickrage/map.jinja" import sickrage with context %}

sickrage_homedir:
  file.directory:
    - name: {{ sickrage.homedir }}
    - user: {{ sickrage.user }}
    - group: {{ sickrage.group }}
    - require:
      - sls: users

sickrage_piddir:
  file.directory:
    - name: {{ sickrage.piddir }}
    - user: {{ sickrage.user }}
    - group: {{ sickrage.group }}
    - require:
      - sls: users
      - git: sickrage-git

sickrage-git:
  git.latest:
    - name: {{ sickrage.git }}
    - target: {{ sickrage.homedir }}
    - require:
      - file: sickrage_homedir
      - pkg: git

sickrage_packages:
  pkg.installed:
    - pkgs:
      {%- for pkg in sickrage.pkgs %}
      - {{ pkg }}
      {%- endfor %}
    - require:
      - git: sickrage-git

#create folders for the app to use
sickrage_datadir:
  file.directory:
    - name: {{ sickrage.datadir }}
    - mode: 777
    - require:
      - sls: nfs.main
      - sls: users

sickrage_configdir:
  file.directory:
    - name: {{ sickrage.configdir }}
    - mode: 777
    - require:
      - sls: nfs.main
      - sls: users