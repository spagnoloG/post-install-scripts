## Arch post-install scripts


```bash
python3 -m venv .venv
. .venv/bin/activate
pip install ansible
```

```
ansible-playbook -i inventory.yaml playbooks/*yml --ask-become-pass
```

PoC: don't use.

## Pluginless dots (distro-agnostic)

```bash
wget https://raw.githubusercontent.com/spagnoloG/post-install-scripts/refs/heads/main/scripts/setup_pluginless.sh -O setup_pluginless.sh
chmod +x setup_pluginless.sh
./setup_pluginless.sh # --just-dots "to only install dots"
```
