# lima

[Lima](https://lima-vm.io/) setup for using Docker on macOS.

## Prerequisites

- macOS
- [Homebrew](https://brew.sh/)

## Setup

1. Clone this repository
2. (Optional) Create a `.env` file to override default settings in `.env_default`

## Usage

Note that default configuration uses Ubuntu 24.04 (Noble Numbat). See [Lima Templates](https://lima-vm.io/docs/templates/) for other options.

Start the machine based on the configuration in `machine.yaml`:

```bash
make machine-start
```

Stop the machine:

```bash
make machine-stop
```

Delete the machine:

```bash
make machine-delete
```

Connect to the machine with a shell:

```bash
make machine-shell
```

