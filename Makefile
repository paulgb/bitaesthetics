
publish :
	./docpad generate
	mkdir -p cloudmount
	#cloudfuse cloudmount
	cp -r out/* cloudmount/bitaesthetics/

serve :
	./docpad generate
	./docpad server

