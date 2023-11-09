package default_variables

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestDefaultVariablesExample(t *testing.T) {
	example := tft.NewTFBlueprintTest(t)
	projectID := example.GetTFSetupStringOutput("project_id")
	prefix := "test-prefix"
	machine_type := "n1-standard-4"
	scope := "https://www.googleapis.com/auth/cloud-platform"
	email := "default"

	example.DefineVerify(func(assert *assert.Assertions) {
		example.DefaultVerify(assert)
		op1 := gcloud.Run(t, fmt.Sprintf("compute instance-groups managed describe %s --project %s --region us-central1", example.GetStringOutput("mig"), projectID))
		assert.Contains(op1.Get("baseInstanceName").String(), "test-prefix", "mig with the template instances created")
		op2 := gcloud.Run(t, fmt.Sprintf("compute forwarding-rules describe %s --project %s --region us-central1", example.GetStringOutput("forwarding_rule"), projectID))
		assert.Contains(op2.Get("network").String(), prefix, "forwarding rule network verified")
		assert.Contains(op2.Get("subnetwork").String(), prefix, "forwarding rule subnet verified")
		op3 := gcloud.Run(t, fmt.Sprintf("compute instance-templates describe %s --project %s", example.GetStringOutput("instance_template"), projectID))
		assert.Contains(op3.Get("properties.machineType").String(), machine_type, "instance template with given machine type created")
		assert.Equal(len(op3.Get("properties.serviceAccounts").Array()), 1, "instance template has one service account")
		assert.Equal(op3.Get("properties.serviceAccounts").Array()[0].Get("email").String(), email, "instance template SA with a default email created")
		assert.Contains(op3.Get("properties.serviceAccounts").Array()[0].Get("scopes").Array()[0].String(), scope, "instance template with given SA scopes created")
		assert.Equal(len(op3.Get("properties.disks").Array()), 2, "instance template with additional disk created")
	})
	example.Test()
}
