TESTS = $(shell find test -name "*.test.*" -type f)

tests:
	@mocha -r should --reporter spec $(TESTS)

