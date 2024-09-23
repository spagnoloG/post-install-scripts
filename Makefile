format:
	yamlfmt -formatter indentless_arrays=true ./playbooks/*.yml
	python ./scripts/add_newlines.py ./playbooks/
	find . -type f -iname "*.lua" -exec lua-format --in-place {} \;

setup-venv:
	python3 -m venv .venv
