# Prisma Cloud Compute Sandbox Analysis VM

This is to create a VM to perform Prisma Cloud Compute Sandbox Analysis. The twistcli tool will be downloaded from the specified Prisma Cloud Compute Console and placed in /use/local/bin directory.

Reference: https://docs.paloaltonetworks.com/prisma/prisma-cloud/21-08/prisma-cloud-compute-edition-admin/runtime_defense/image_analysis_sandbox.html


## Prequisites:
1. Terraform v1.0 and above

2. Create a custom role on the Prisma Cloud Compute Console
    - https://docs.paloaltonetworks.com/prisma/prisma-cloud/21-08/prisma-cloud-compute-edition-admin/runtime_defense/image_analysis_sandbox.html#_setup_the_sandbox_user
    - Under Monitor
        - CI Results: Read
        - Container Runtime Results: Read, Write
    - Under Manage
        - Utilities: Read  (This is to allow download of twistcli tool)

3. Create a user on the Prisma Cloud Compute Console and assign the custom role to the new user



## Deployment
1. Update the "terraform.tfvars" file with the necessary information.

2. Run "terraform init"

3. Run "terraform apply"

4. VM will be deployed. It takes about 5-10 minutes for it to be fully ready.

5. The public IP of the VM will be shown in the terraform outputs.



## Removing The VM

1. Run "terraform destroy"