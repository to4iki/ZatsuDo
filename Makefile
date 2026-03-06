setup:
	mise trust
	mise install
	lefthook install

swiftformat:
	swift format \
		--ignore-unparsable-files \
		--in-place \
		--recursive \
		./App \
		./AppPackage \
		./AppLibrary
