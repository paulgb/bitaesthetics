
build :
	npm run-script build

publish : build
	cd out; cloudpush.py push

serve : build
	npm run-script serve

