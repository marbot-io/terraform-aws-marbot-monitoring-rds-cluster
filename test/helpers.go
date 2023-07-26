package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func configRDScluster(t *testing.T) *terraform.Options {
	path := test_structure.CopyTerraformFolderToTemp(t, "../", "examples/rds-cluster")

	return terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: path,
	})
}
