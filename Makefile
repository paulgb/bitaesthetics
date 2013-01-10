
build :
	npm run-script build

publish : build
	cd out; s3cmd sync ./ s3://bitaesthetics.com/

serve :
	npm run-script serve

