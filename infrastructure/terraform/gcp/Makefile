apply:
	terraform apply

checkFmt:
	@if [ `terraform fmt | wc -c` -ne 0 ]; then echo "files need be formatted"; exit 1; fi

fmt:
	terraform fmt

validate:
	terraform validate
