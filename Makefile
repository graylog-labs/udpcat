GO ?= go
AWK ?= awk

BUILD_OPTS = 

.PHONY: all
all: clean build

.PHONY: all prepare-build build build-all build-linux build-linux32 build-darwin build-windows build-windows32 misc fmt clean help
clean: ## Remove binaries
	@rm -rf build/

.PHONY: deps
deps: ## Fetch dependencies
	$(GO) get -t ./...

.PHONY: prepare-build
prepare-build: deps ## Prepare build directory
	@mkdir -p build/

.PHONY: build
build: prepare-build ## Build binary for local target system
	$(GO) build $(BUILD_OPTS) -v -i -o build/udpcat

.PHONY: build-linux
build-linux: prepare-build ## Build binary for Linux
	GOOS=linux GOARCH=amd64 $(GO) build $(BUILD_OPTS) -v -i -o build/udpcat.linux-amd64

.PHONY: build-linux32
build-linux32: prepare-build ## Build binary for Linux 32-bit
	GOOS=linux GOARCH=386 $(GO) build $(BUILD_OPTS) -pkgdir $(GOPATH)/go_linux32  -v -i -o build/udpcat.linux-i386

.PHONY: build-darwin
build-darwin: prepare-build ## Build binary for OSX
	GOOS=darwin GOARCH=amd64 $(GO) build $(BUILD_OPTS) -v -i -o build/udpcat.darwin-amd64

.PHONY: build-freebsd
build-freebsd: prepare-build ## Build binary for FreeBSD 64-bit
	GOOS=freebsd GOARCH=amd64 $(GO) build $(BUILD_OPTS) -v -i -o build/udpcat.freebsd-amd64

.PHONY: build-solaris
build-solaris: prepare-build ## Build binary for Solaris/OmniOS/Illumos
	GOOS=solaris GOARCH=amd64 $(GO) build $(BUILD_OPTS) -v -i -o build/udpcat.solaris-amd64

.PHONY: build-windows
build-windows: prepare-build ## Build binary for Windows 64-bit
	GOOS=windows GOARCH=amd64 CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc $(GO) build $(BUILD_OPTS) -pkgdir $(GOPATH)/go_win -v -i -o build/udpcat-amd64.exe

.PHONY: build-windows32
build-windows32: prepare-build ## Build binary for Windows 32-bit
	GOOS=windows GOARCH=386 CGO_ENABLED=1 CC=i686-w64-mingw32-gcc $(GO) build $(BUILD_OPTS) -pkgdir $(GOPATH)/go_win32 -v -i -o build/udpcat-i386.exe

.PHONY: build-all
build-all: build-linux build-linux32 build-darwin build-freebsd build-solaris build-windows build-windows32 ## Build binaries for all targets

.PHONY: help
help: ## Help message
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | $(AWK) 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

