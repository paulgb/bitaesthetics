
build :
	npm run-script build

publish :
	gsutil rsync -R out gs://www.bitaesthetics.com
	gsutil acl ch -u AllUsers:R -R gs://www.bitaesthetics.com

serve :
	npm run-script serve

