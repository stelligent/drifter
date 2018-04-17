GITHUB_USER ?= stelligent
GITHUB_REPO ?= drifter
GITHUB_BRANCH ?= master
TOOLCHAIN_STACK_NAME ?= drifter-toolchain


default: check

check:
	@aws cloudformation validate-template --template-body file://pipeline.yml

deploy: check
	-@aws cloudformation describe-stacks --stack-name $(TOOLCHAIN_STACK_NAME) > /dev/null 2>&1; \
	if [ $$? -eq 0 ]; then \
		echo "[INFO] Updating cloudformation stack $(TOOLCHAIN_STACK_NAME)"; \
		aws cloudformation update-stack --stack-name $(TOOLCHAIN_STACK_NAME) \
		  --template-body file://pipeline.yml \
          --capabilities CAPABILITY_NAMED_IAM \
          --parameters ParameterKey=GitHubUser,ParameterValue="$(GITHUB_USER)" \
                       ParameterKey=GitHubRepo,ParameterValue="$(GITHUB_REPO)" \
                       ParameterKey=GitHubBranch,ParameterValue="$(GITHUB_BRANCH)" \
                       ParameterKey=GitHubToken,UsePreviousValue=true; \
        if [ $$? -eq 0 ]; then \
			aws cloudformation wait stack-update-complete --stack-name $(TOOLCHAIN_STACK_NAME); \
		fi; \
	else \
		echo "[INFO] Creating cloudformation stack $(TOOLCHAIN_STACK_NAME)"; \
		aws cloudformation create-stack --stack-name $(TOOLCHAIN_STACK_NAME)  \
		  --template-body file://pipeline.yml \
          --capabilities CAPABILITY_NAMED_IAM \
          --parameters ParameterKey=GitHubUser,ParameterValue="$(GITHUB_USER)" \
                       ParameterKey=GitHubRepo,ParameterValue="$(GITHUB_REPO)" \
                       ParameterKey=GitHubBranch,ParameterValue="$(GITHUB_BRANCH)" \
                       ParameterKey=GitHubToken,ParameterValue="$(GITHUB_TOKEN)"; \
        if [ $$? -eq 0 ]; then \
			aws cloudformation wait stack-create-complete --stack-name $(TOOLCHAIN_STACK_NAME); \
		fi; \
	fi
	@aws cloudformation describe-stacks --stack-name $(TOOLCHAIN_STACK_NAME) --output text --query 'Stacks[0].StackStatus' | grep _COMPLETE


.PHONY: default check toolchain
