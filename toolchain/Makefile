TOOLCHAIN_STACK_NAME ?= drifter-toolchain

PARAMETER_OVERRIDES += $(if $(GITHUB_TOKEN),GitHubToken="$(GITHUB_TOKEN)")
PARAMETER_OVERRIDES += $(if $(GITHUB_USER),GitHubUser="$(GITHUB_USER)")
PARAMETER_OVERRIDES += $(if $(GITHUB_REPO),GitHubRepo="$(GITHUB_REPO)")
PARAMETER_OVERRIDES += $(if $(GITHUB_BRANCH),GitHubBranch="$(GITHUB_BRANCH)")

default: check

check:
	@aws cloudformation validate-template --template-body file://pipeline.yml

deploy: check
	aws cloudformation deploy \
		--template-file pipeline.yml \
		--stack-name $(TOOLCHAIN_STACK_NAME) \
        --capabilities CAPABILITY_NAMED_IAM \
        $(if $(strip $(PARAMETER_OVERRIDES)),--parameter-overrides $(PARAMETER_OVERRIDES))

.PHONY: default check deploy
