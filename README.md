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
