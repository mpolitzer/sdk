# sdk

SDK is a set of scripts to aid in cross compilation.
To use the SDK, either fetch a prebuild image from the registry or [build](#build) it yourself.

## Build

Requirements:
- Docker 20.x
- GNU Make >= 3.81

Example:
```
make config host=riscv64-lp64d-linux-musl # config
make build                                # build
make run                                  # use
```

Use `make help` to list commands, `make list` to list configs.

## Run

```
make run
```

## Tricks

1. Override `.config`:
```
make run IMAGE=riscv64-lp64d-linux-musl:latest
```

2. run with a different directory:
```
cd /path/to/src
make -srC /path/to/sdk/ run
```
