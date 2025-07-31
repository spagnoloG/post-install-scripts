format:
	@for file in ./playbooks/*.yml; do \
		uv run ./scripts/ansible_formatter.py $$file; \
		echo "Formatted: $$file"; \
	done
	@for file in ./playbooks/group_vars/*.yml; do \
		uv run ./scripts/ansible_formatter.py $$file; \
		echo "Formatted: $$file"; \
	done
	find . -type f -iname "*.lua" -exec lua-format --in-place {} \;

setup-venv:
	uv venv
