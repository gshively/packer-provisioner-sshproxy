package sshproxy

import (
    "errors"
    "fmt"

    "github.com/gshively/packer-provisioner-sshproxy/provisioner/sshproxy"
	"github.com/hashicorp/packer/packer"
)

type Provisioner struct {
    config sshproxy.Config
    sshproxy.Provisioner
}

func processConfig(raws *([]interface{})) error {
    foundCommand := false
    foundArguments := false
    var errs *packer.MultiError

    for idx, _ := range *raws {
        if raw_map, ok := (*raws)[idx].(map[interface{}]interface{}); ok {
            if _, ok := raw_map["command"]; ok {
                foundCommand = true
            }
            if args, ok := raw_map["arguments"]; ok {
                if v, ok := args.([]interface{}); ok {
                    foundArguments = true
                    raw_map["arguments"] = append(v, "--ssh-config=${SSH_CONFIG_FILE} --hosts=${TARGET_HOSTS}")
                }
            }
            if _, ok := raw_map["ssh_config_env_name"]; ok {
                errs = packer.MultiErrorAppend(errs, fmt.Errorf("ssh_config_env_name is not valid"))
            }
            if _, ok := raw_map["host_alias"]; ok {
                errs = packer.MultiErrorAppend(errs, fmt.Errorf("host_alias is not valid"))
            }
            if _, ok := raw_map["host_alias_env_name"]; ok {
                errs = packer.MultiErrorAppend(errs, fmt.Errorf("host_alias_env_name is not valid"))
            }
        }
    }

    if errs != nil && len(errs.Errors) > 0 {
        return errs
    }

    if !foundCommand {
        *raws = append(*raws, map[string]string{"command": "pytest"})
    }
    if !foundArguments {
        *raws = append(*raws, map[string]interface{}{"arguments": fmt.Sprintf("%s %s",
            "--ssh-config=${SSH_CONFIG_FILE}",
            "--hosts=${TARGET_HOSTS}")})
    }
    return nil
    return errors.New(fmt.Sprintf("%v", raws))
}

func (p *Provisioner) Prepare(raws ...interface{}) error {
    p.ProviderName = "testinfra"
    if err := processConfig(&raws); err != nil {
        return err
    }

    return p.Provisioner.Prepare(raws...)
}

