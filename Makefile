
version: version-bump version-clean

version-bump:
	find . -type f -iname version-bump.sh -exec {} \;

version-clean:
	find . -type f -iname version-clean.sh -exec {} \;

