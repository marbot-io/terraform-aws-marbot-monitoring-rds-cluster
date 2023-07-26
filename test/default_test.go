package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestDefault(t *testing.T) {
	t.Parallel()

	terraformPath := test_structure.CopyTerraformFolderToTemp(t, "../", "examples/default")

	rdsOptions := configRDScluster(t)

	defer terraform.Destroy(t, rdsOptions)
	terraform.InitAndApply(t, rdsOptions)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: terraformPath,
		Vars: map[string]interface{}{
			"endpoint_id": os.Getenv("MARBOT_ENDPOINT_ID"),
			"db_cluster_identifier": terraform.Output(t, rdsOptions, "db_cluster_identifier"),
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
