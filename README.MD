# EndeavourOS Docker Image

Docker image for an EndeavourOS-flavored interactive Arch Linux environment.

- Source repository: `https://github.com/dockers-x/endeavouros-docker`
- Docker Hub repository: `docker.io/czyt/endeavouros`
- Published tags: Git tags publish matching Docker image tags, plus `latest`

## Pull From Docker Hub

```bash
docker pull docker.io/czyt/endeavouros:latest
docker run --rm -it docker.io/czyt/endeavouros:latest
```

Versioned releases are available by tag:

```bash
docker pull docker.io/czyt/endeavouros:v0.1.1
docker run --rm -it docker.io/czyt/endeavouros:v0.1.1
```

## Included Components

The image starts from `archlinux:latest`, then layers in:

- Arch and archlinuxcn package sources and keyrings.
- EndeavourOS repository, keyring, mirrorlist, theming, and hooks.
- Base development and shell tooling: `base-devel`, `ca-certificates`, `curl`, `fastfetch`, `fish`, `git`, `paru`, `starship`, and `sudo`.
- AUR tooling package: `herdr-bin`.
- Fish defaults for root and future users: Oh My Fish, Starship `pastel-powerline` preset, and mise shell integration.
- `/etc/os-release` values that identify the container as EndeavourOS.

Package lists are maintained in `scripts/packages.sh`.

### Component Sources

| Source | Components |
| --- | --- |
| `base_packages` | Pacman packages installed from Arch or enabled repositories. |
| `aur_packages` | AUR packages installed with `paru` through a temporary build user. |
| `endeavouros_packages` | Packages installed after enabling the EndeavourOS repository. |
| `endeavouros_keys` | EndeavourOS signing keys imported before installing EndeavourOS packages. |

## Build Layout

The Dockerfile is intentionally small and delegates build steps to scripts. Scripts are mounted with BuildKit during `RUN` steps; they are not copied into the final image.

| File | Purpose |
| --- | --- |
| `Dockerfile` | Mounts scripts at build time and runs the build phases in order. |
| `scripts/packages.sh` | Central package, key, and component lists. |
| `scripts/01-install-archlinux-base.sh` | Enables archlinuxcn and installs base packages plus AUR packages. |
| `scripts/02-install-endeavouros.sh` | Adds EndeavourOS repository keys and packages. |
| `scripts/03-configure-fish-defaults.sh` | Configures fish, Oh My Fish, Starship, and mise defaults. |
| `scripts/04-write-os-release.sh` | Writes EndeavourOS identity metadata. |

To add more software later, prefer editing the arrays in `scripts/packages.sh`:

- Add pacman packages to `base_packages`.
- Add AUR packages to `aur_packages`.
- Add EndeavourOS packages to `endeavouros_packages`.

If a component needs custom install logic, add a new numbered script under `scripts/` and run it from `Dockerfile`.

Build scripts are only build-time inputs. They are mounted into the builder with BuildKit and are not retained under `/usr/local/lib/endeavouros-docker` or any other script directory in the final image.

## Prerequisites

- Docker with BuildKit support
- Make
- Git

## Usage

Clone the repository:

```bash
git clone https://github.com/dockers-x/endeavouros-docker.git
cd endeavouros-docker
```

Build the default local image:

```bash
make build
```

This creates `czyt/endeavouros:latest`.

Build a specific local tag:

```bash
make build IMAGE_TAG=v0.1.0
```

Run the image interactively:

```bash
make run
```

Override the repository name when needed:

```bash
make build IMAGE_REPOSITORY=endeavouros IMAGE_TAG=dev
```

## Publishing

Docker Hub publishing runs from Git tag pushes through GitHub Actions:

```bash
git tag v0.1.0
git push origin v0.1.0
```

For tag `v0.1.0`, the workflow publishes:

- `docker.io/czyt/endeavouros:v0.1.0`
- `docker.io/czyt/endeavouros:latest`

The workflow rejects Git tags that are not valid Docker tag names.

## Maintenance Commands

```bash
make clean
make remove
make images
make ps
make stop
make remove-containers
```

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
