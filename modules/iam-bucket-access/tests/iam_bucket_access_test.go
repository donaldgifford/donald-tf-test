package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// An example of how to test the simple Terraform module in examples/terraform-basic-example using Terratest.
func TestIamBucketAccess(t *testing.T) {
	t.Parallel()

	// expectedText := "us-east-1"
	expectedRegion := "us-east-1"
	expectedPrefix := "donald"
	expectedAwsProfile := "localstack"
	expectedBucketName := "donald-secure"
	expectedRoleName := "donald-donald-Assume-Role-for-Lambda"

	// expectedList := []string{expectedText}
	// expectedMap := map[string]string{"expected": expectedText}

	terraformOptions := terraform.WithDefaultRetryableErrors(
		t,
		&terraform.Options{
			// website::tag::1::Set the path to the Terraform code that will be tested.
			// The path to where our Terraform code is located
			TerraformDir: "../../iam-bucket-access/",

			// Variables to pass to our Terraform code using -var options
			Vars: map[string]interface{}{
				// "example":     expectedText,
				"region":      expectedRegion,
				"prefix":      expectedPrefix,
				"aws_profile": expectedAwsProfile,
				"bucket_name": expectedBucketName,

				// We also can see how lists and maps translate between terratest and terraform.
				// "example_list": expectedList,
				// "example_map":  expectedMap,
			},

			// Variables to pass to our Terraform code using -var-file options
			// VarFiles: []string{"varfile.tfvars"},

			// Disable colors in Terraform commands so its easier to parse stdout/stderr
			NoColor: true,
		},
	)

	// website::tag::4::Clean up resources with "terraform destroy". Using "defer" runs the command at the end of the test, whether the test succeeds or fails.
	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2::Run "terraform init" and "terraform apply".
	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	// actualTextExample := terraform.Output(t, terraformOptions, "bucket_name")
	actualRoleName := terraform.Output(t, terraformOptions, "role_name")
	actualPolicyArn := terraform.Output(t, terraformOptions, "policy_arn")
	actualPolicyJson := terraform.Output(t, terraformOptions, "policy_json")
	// actualTextExample2 := terraform.Output(t, terraformOptions, "example2")
	// actualExampleList := terraform.OutputList(
	// 	t,
	// 	terraformOptions,
	// 	"example_list",
	// )
	// actualExampleMap := terraform.OutputMap(t, terraformOptions, "example_map")

	generatedPolicay := aws.GetIamPolicyDocument(
		t,
		expectedRegion,
		actualPolicyArn,
	)
	// website::tag::3::Check the output against expected values.
	// Verify we're getting back the outputs we expect
	// assert.Equal(t, expectedBucketName, actualTextExample)
	assert.Equal(t, expectedRoleName, actualRoleName)
	assert.Equal(t, expectedRoleName, actualRoleName)
	assert.Equal(t, actualPolicyJson, generatedPolicay)
	// assert.Equal(t, expectedText, actualTextExample2)
	// assert.Equal(t, expectedList, actualExampleList)
	// assert.Equal(t, expectedMap, actualExampleMap)
}
