format:
	yamlfmt -formatter indentless_arrays=true ./playbooks/*.yml
	python ./scripts/add_newlines.py ./playbooks/

setup-venv:
	python3 -m venv .venv
