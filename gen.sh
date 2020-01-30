#!/bin/bash

if [ -f mocs ]; then
    rm -rf mocs
fi

if [ -d protobuf ]; then
    rm -rf protobuf
fi

mkdir -p  protobuf mocks/mock_messaging

# Generate protos
./protogen

# Update import paths on generated protos
repourl=github.com/hyperledger/sawtooth-sdk-go
grep -rl '"protobuf/' protobuf/ | while IFS= read -r file; do
    sed -i "" "s|\"protobuf/|\"${repourl}/protobuf/|" "$file"
done

(
cd messaging || exit
sed -i "" "s|\"protobuf/|\"${repourl}/protobuf/|" connection.go
mockgen -source connection.go >../mocks/mock_messaging/connection.go
)
