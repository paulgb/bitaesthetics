
publish :
	./docpad generate
	mkdir -p cloudmount
	#cloudfuse cloudmount
	cp -r out/* cloudmount/bitaesthetics/

serve :
	npm run-script build
	npm run-script serve

