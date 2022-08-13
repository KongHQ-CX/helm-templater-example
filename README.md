# Helm Templater Example
Sample repository showing how you can deploy multiple data planes across multiple Kube clusters, from a configuration file.

## Usage
This is all designed to run inside a container specifically, however it can also be run from your computer (if you have Golang installed).

### Setup
Just run:

```sh
make build-tools-image
```

to construct the image.

### Configuration
**Firstly**, you should set up your Helm template for all of your Kong installations exactly as required, inside the `chart-template/` directory.

In here, you can add conditional logic to the `values.yaml.tpl` and `install-kong.sh.tpl` to provide different Helm values and install instructions depending on the environment.

**Secondly**, you should configure all your clusters for installation inside the `cluster.yaml` file, including all variables that will be applied to the `values.yaml` template.

⚠️ IMPORTANT: this process assumes that all required Kubenetes clusters are all already authenticated with. If you need to log in to each one separately, you should set up this logic in the `install-kong.sh.tpl` script template.

### Running
After completing the `values.yaml.tpl`, `install-kong.sh.tpl`, and `clusters.yaml` files to your requirements, you can run the process with:

```sh
make install-kongs
```

The install script for this process is in `utils.sh` and it essentially just iterates through each rendered cluster (from the `clusters.yaml` file) and installs one-by-one.

This can be sped up with threading later.
