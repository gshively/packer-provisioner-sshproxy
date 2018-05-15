#!/usr/bin/env bash
package_name="packer-provisioner-sshproxy"
package="github.com/gshively/$package_name"

platforms=("darwin/amd64" "linux/amd64" )

mkdir -p dist

for platform in "${platforms[@]}"; do
    platform_detail=(${platform//\// })
    GOOS=${platform_detail[0]}
    GOARCH=${platform_detail[1]}

    output_name="${package_name}-${GOOS}-${GOARCH}"
    [ "$GOOS" == "windows" ] && output_name="${output_name}.exe"

    env GOOS="$GOOS" GOARCH="$GOARCH" go build -o dist/$output_name $package


done
