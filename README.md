## Arch post-install scripts (wip)


```bash
python3 -m venv .venv
. .venv/bin/activate
pip install ansible
```

```
ansible-playbook -i inventory.yaml playbooks/* --ask-become-pass
```

Poc: don't use.
