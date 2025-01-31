## Arch post-install scripts


```bash
python3 -m venv .venv
. .venv/bin/activate
pip install ansible ruamel.yaml
```

```
ansible-playbook -i inventory.yaml site.yml --ask-become-pass
```

This is a proof of concept (PoC) for a complete environment setup using Ansible.

## Pluginless dots (distro-agnostic)

```bash
wget https://raw.githubusercontent.com/spagnoloG/post-install-scripts/refs/heads/main/scripts/setup_pluginless.sh -O setup_pluginless.sh
chmod +x setup_pluginless.sh
./setup_pluginless.sh # --just-dots "to only install dots"
```
