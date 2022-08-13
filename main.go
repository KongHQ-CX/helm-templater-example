package main

import (
	"fmt"
	"log"
	"os"
	"text/template"

	"gopkg.in/yaml.v3"
)

var j = `  - alias: "konnect-rg-1"
namespace: "konnect-rg-1"
kubeContext: "azure-eu"
konnectCertificateFiles:
  cert: "konnect-certificates/konnect-rg-1.pem"
  key: "konnect-certificates/konnect-rg-1.key"
proxyCertificateFiles:
  cert: "proxy-certificates/konnect-rg-1-proxy.pem"
  key: "proxy-certificates/konnect-rg-1-proxy.key"
variables:
  imageTag: "2.8.1.3-ubuntu"
  ingressURL: "kong.k3s.local"`

type CertPair struct {
	Cert string `yaml:"cert"`
	Key  string `yaml:"key"`
}

type Cluster struct {
	Alias                   string                      `yaml:"alias"`
	Namespace               string                      `yaml:"namespace"`
	KubeContext             string                      `yaml:"kubeContext"`
	KonnectCertificateFiles CertPair                    `yaml:"konnectCertificateFiles"`
	ProxyCertificateFiles   CertPair                    `yaml:"proxyCertificateFiles"`
	Variables               map[interface{}]interface{} `yaml:"variables"`
}

type Clusters struct {
	Clusters []Cluster `yaml:"clusters"`
}

func main() {
	clusters := Clusters{}

	dat, err := os.ReadFile("./clusters.yaml")
	if err != nil {
		log.Fatal(err)
	}

	if err := yaml.Unmarshal([]byte(dat), &clusters); err != nil {
		log.Fatal(err)
	}

	valuesTemplate, err := template.New("values.yaml.tpl").Option("missingkey=error").ParseFiles("chart-template/values.yaml.tpl")
	if err != nil {
		log.Fatal(err)
	}

	installScriptTemplate, err := template.New("install-kong.sh.tpl").Option("missingkey=error").ParseFiles("chart-template/install-kong.sh.tpl")
	if err != nil {
		log.Fatal(err)
	}

	for _, cluster := range clusters.Clusters {
		err = os.MkdirAll(fmt.Sprintf("./workdir/%s", cluster.Alias), os.ModePerm)
		if err != nil {
			log.Fatal(err)
		}

		// First render the values.yaml for this cluster
		valuesFile, err := os.OpenFile(fmt.Sprintf("./workdir/%s/values.yaml", cluster.Alias), os.O_WRONLY|os.O_CREATE, 0600)
		if err != nil {
			panic(err)
		}
		defer valuesFile.Close()

		err = valuesTemplate.Execute(valuesFile, cluster.Variables)

		if err != nil {
			log.Fatal(err)
		}

		// Then render the install script
		installScriptFile, err := os.OpenFile(fmt.Sprintf("./workdir/%s/install-kong.sh", cluster.Alias), os.O_WRONLY|os.O_CREATE, 0700)
		if err != nil {
			panic(err)
		}
		defer installScriptFile.Close()

		err = installScriptTemplate.Execute(installScriptFile, cluster)

		if err != nil {
			log.Fatal(err)
		}
	}
}
