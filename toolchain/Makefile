GITHUB_USER ?= stelligent
GITHUB_REPO ?= drifter
GITHUB_BRANCH ?= master
TOOLCHAIN_STACK_NAME ?= drifter-toolchain


default: check

check:
	@aws cloudformation validate-template --template-body file://pipeline.yml

deploy: check
	@aws cloudformation deploy --template-file pipeline.yml --stack-name $(TOOLCHAIN_STACK_NAME) \
          --capabilities CAPABILITY_NAMED_IAM \
          --parameter-overrides \
        	GitHubUser="$(GITHUB_USER)" \
        	GitHubRepo="$(GITHUB_REPO)" \
        	GitHubBranch="$(GITHUB_BRANCH)" \
            GitHubToken="$(GITHUB_TOKEN)"

.PHONY: default check deploy
