# init project path
HOMEDIR := $(shell pwd)
OUTDIR  := $(HOMEDIR)/output

# init command params
GO      := go
GOPATH  := $(shell $(GO) env GOPATH)
GOMOD   := $(GO) mod
GOBUILD := $(GO) build
GOTEST  := $(GO) test -gcflags="-N -l"
GOPKGS  := $$($(GO) list ./...| grep -vE "vendor" )
export PATH := $(GOPATH)/bin/:$(PATH)

# test cover files
COVPROF := $(HOMEDIR)/covprof.out  # coverage profile
COVFUNC := $(HOMEDIR)/covfunc.txt  # coverage profile information for each function
COVHTML := $(HOMEDIR)/covhtml.html # HTML representation of coverage profile

GIT_COMMIT  = `git rev-parse HEAD`
GIT_DATE    = `date "+%Y-%m-%d %H:%M:%S"`
GIT_VERSION = `git --version`

LD_FLAGS    = " \
    -X 'github.com/tornado404/db_crud_api/pkg/version.GitVersion=${GIT_VERSION}' \
    -X 'github.com/tornado404/db_crud_api/pkg/version.GitCommit=${GIT_COMMIT}' \
    -X 'github.com/tornado404/db_crud_api/pkg/version.BuildDate=${GIT_DATE}' \
    '-extldflags=-static' \
    -w -s"

# make, make all
all: prepare compile package

# make prepare, download dependencies
prepare: gomod

gomod:
	$(GO) env -w GO111MODULE=on
	#$(GO) env -w GOPROXY=https://goproxy.io,direct
	$(GO) env -w CGO_ENABLED=0
	$(GOMOD) download

# make compile
compile: build

build:
	$(GOBUILD) -ldflags ${LD_FLAGS} -trimpath -o $(HOMEDIR)/db-crud-api $(HOMEDIR)/main.go


# make doc
doc:
	$(GO) get -u github.com/swaggo/swag/cmd/swag@v1.7.6
	swag init -g router.go --parseDependency --parseInternal  -o $(HOMEDIR)/docs/api -d $(HOMEDIR)/pkg/apiserver/router/v1/
	mkdir -p $(OUTDIR)/docs
	mv $(HOMEDIR)/docs/api $(OUTDIR)/docs

# make test, test your code
test: prepare mock-gen test-case
mock-gen:
	$(GO) get golang.org/x/tools/go/packages
	$(GO) get github.com/golang/mock/mockgen@v1.4.4
	mockgen -destination=pkg/pipeline/mock_job.go -source=pkg/pipeline/job.go -package=pipeline
test-case:
	$(GOTEST) -v -cover $(GOPKGS)

# make package
package:
	mkdir -p $(OUTDIR)/bin
	mv $(HOMEDIR)/db-crud-api   $(OUTDIR)/bin


# make clean
clean:
	$(GO) clean
	rm -rf $(OUTDIR)

# avoid filename conflict and speed up build
.PHONY: all prepare compile test package clean build
