format:
	@for file in ./playbooks/*.yml; do \
		./.venv/bin/python3 ./scripts/format_file.py $$file; \
		echo "Formatted: $$file"; \
	done
	find . -type f -iname "*.lua" -exec lua-format --in-place {} \;

setup-venv:
	python3 -m venv .venv
