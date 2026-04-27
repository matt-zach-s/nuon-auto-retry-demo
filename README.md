# nuon-auto-retry-demo

Minimal Nuon app config that demonstrates component-level
[`max_auto_retries`](https://github.com/nuonco/nuon/blob/main/pkg/config/terraform_module_component.go).

The single component, `always_fail`, runs a Terraform `local-exec` that exits
non-zero on every apply. With `max_auto_retries = 3` set on the component,
Nuon will re-plan + re-apply the component three times before surfacing the
failure.

## Layout

```
.
├── metadata.toml
├── runner.toml                  # AWS runner
├── sandbox.toml                 # nuonco/aws-min-sandbox (VPC + runner only)
├── stack.toml                   # aws-cloudformation
├── permissions/
│   ├── provision.toml
│   ├── provision_boundary.json
│   ├── deprovision.toml
│   └── deprovision_boundary.json
├── components/
│   └── 1-always-fail.toml       # max_auto_retries = 3
└── src/
    └── components/
        └── always_fail/
            └── main.tf          # terraform_data + exit 1
```

## Usage

```sh
# from this dir, with a Nuon app already created
nuon app sync

# install into an AWS account
nuon installs create --app <app_id>
nuon installs deploy
```

After the deploy is triggered, watch the Workflow page for `always_fail`. The
"Apply" step should auto-retry 3 times, then surface as failed.

## Tweaking the retry count

Edit `components/1-always-fail.toml` — set `max_auto_retries` between `1` and
`20`. `0` (or omitted) disables auto-retry entirely.
