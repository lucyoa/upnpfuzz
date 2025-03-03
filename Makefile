REFORMAT_DIRS:=upnpfuzz

define colorecho
      @tput setaf 6
      @echo $1
      @tput sgr0
endef

.PHONY: package
package: clean
	$(call colorecho, "\n Building package distributions...")
	python setup.py install
	python setup.py bdist_wheel

.PHONY: line
lint:
	$(call colorecho, "\nLinting...")
	isort --check-only --diff $(REFORMAT_DIRS)
	ruff check --diff $(REFORMAT_DIRS)

.PHONY: reformat
reformat:
	$(call colorecho, "\nReformatting...")
	isort $(REFORMAT_DIRS)
	ruff check --fix $(REFORMAT_DIRS)

.PHONY: clean
clean:
	$(call colorecho, "\nRemoving artifacts...")
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f  {} +
	rm -rf build dist pip-wheel-metadata

.PHONY: publish
publish: package
	$(call colorecho, "\nPublishing...")
	twine upload dist/* --verbose