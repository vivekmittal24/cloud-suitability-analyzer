#!/bin/bash

LINUX="L"
OSX="O"
WINDOWS="W"

echo "~~~> Will build the following executables:"

if [[ "$OS" == *"$OSX"* ]]; then
    echo "     OSX"
fi

if [[ "$OS" == *"$WINDOWS"* ]]; then
    echo "     WINDOWS"
fi

if [[ "$OS" == *"$LINUX"* ]]; then
    echo "     LINUX"
fi

#---  fail if any command returns a non-zero result
set -e

cd src/github.com/vmware-samples/cloud-suitability-analyzer/



#--- this corrects and issue with go mod tidy
export GOSUMDB=off

#--- set module mode
export G0111MODULE=on
export GOBIN=/go/bin
export PATH=$GOPATH/bin:$PATH
export WORKING_DIR=$GOPATH/src/github.com/vmware-samples/cloud-suitability-analyzer
export OUTPUT_DIR="$WORKING_DIR/go/exe"

pushd ${WORKING_DIR}/go



  #--- build the requested platform executables

  #--- version needs to be automated, using command line for now.
  export LD_FLAGS="-X \"main.Version=$VERSION\"" 


  if [[ "$OS" == *"$OSX"* ]]; then
    echo "~~~> Building osx version"
    #buildCommand="env CGO_ENABLED=1 CC=o64-clang GOOS=darwin GOARCH=amd64 go build -ldflags ${LD_FLAGS} -o ${OUTPUT_DIR}/csa csa.go"
    #echo "~~~> OSX build: $buildCommand"
    env CGO_ENABLED=1 CC=o64-clang GOOS=darwin GOARCH=amd64 go build -ldflags "${LD_FLAGS}" -o ${OUTPUT_DIR}/csa csa.go
    chmod +x ${OUTPUT_DIR}/csa
  fi

  if [[ "$OS" == *"$WINDOWS"* ]]; then
    echo "~~~> Building windows version"
    #buildCommand="env CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc GOOS=windows GOARCH=amd64 go build -ldflags ${LD_FLAGS}  -o ${OUTPUT_DIR}/csa.exe csa.go"
    #echo "~~~> Windows build: $buildCommand"
    env CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc GOOS=windows GOARCH=amd64 go build -ldflags "${LD_FLAGS}" -o ${OUTPUT_DIR}/csa.exe csa.go
    chmod +x ${OUTPUT_DIR}/csa.exe
  fi 

  if [[ "$OS" == *"$LINUX"* ]]; then
    echo "~~~> Building linux version"
    #buildCommand="env CGO_ENABLED=1 CC=musl-gcc go build -extldflags \"-static\"' -o ${OUTPUT_DIR}/csa-l csa.go"
    #echo "~~~> Linux build: $buildCommand"
    env CGO_ENABLED=1 CC=musl-gcc go build --ldflags '-linkmode external -extldflags "-static"'  -o ${OUTPUT_DIR}/csa-l csa.go
    chmod +x ${OUTPUT_DIR}/csa-l  
  fi

  echo
  echo
  echo "Native time: $NATIVETIME seconds"