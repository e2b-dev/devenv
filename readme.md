install nix
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
```

install direnv
```
nix profile install nixpkgs#direnv
```

direnv allow

```
direnv allow 
```

sign in to google cloud
```
gcloud auth login
```

apply the terraform

```
export TF_VAR_username=$USER
terraform apply --auto-approve
```




create the instance

```
gcloud compute instances create --source-instance-template=terraform-instance-template --zone=us-west4-c devenv
```

delete the instance
```
gcloud compute instances delete --quiet --zone=us-west4-c devenv
```

stream logs
```
gcloud compute instances get-serial-port-output devenv --zone=us-west4-c
```

configure ssh config
```
gcloud compute config-ssh
```

ssh into the instance
```
gcloud compute ssh devenv --zone=us-west4-c
```




