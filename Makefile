
build :
	npm run-script build

publish : build
	cd out; cloudpush.py push

serve :
	npm run-script serve

