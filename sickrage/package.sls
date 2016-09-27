include:
  # external formula
  - git

{% from "sickrage/map.jinja" import sickrage with context %}

# create sickrage user
sickrage_user:
  user.present:
    - name: {{ sickrage.user }}
    - createhome: False
    - shell: /bin/false

# create directory to store the application
sickrage_homedir:
  file.directory:
    - name: {{ sickrage.homedir }}
    - user: {{ sickrage.user }}
    - group: {{ sickrage.group }}
    - require:
      - user: sickrage_user

# create directory to store the pid file
sickrage_piddir:
  file.directory:
    - name: {{ sickrage.piddir }}
    - user: {{ sickrage.user }}
    - group: {{ sickrage.group }}
    - require:
      - user: sickrage_user

# clone the sickrage git repo
sickrage-git:
  git.latest:
    - name: {{ sickrage.git }}
    - target: {{ sickrage.homedir }}
    - require:
      - file: sickrage_homedir
      - pkg: git

# install all required packages 
sickrage_packages:
  pkg.installed:
    - pkgs:
      {%- for pkg in sickrage.pkgs %}
      - {{ pkg }}
      {%- endfor %}

# use python pip to install additional python libaries 
sickrage_packages_pip:
  pip_state.installed:
    - requirements: {{ sickrage.homedir }}requirements.txt
    - require:
      - git: sickrage-git
      - pkg: sickrage_packages

#create folders for the app to use for database and configuration
sickrage_datadir:
  file.directory:
    - name: {{ sickrage.datadir }}
    - mode: 777

sickrage_configdir:
  file.directory:
    - name: {{ sickrage.configdir }}
    - mode: 777