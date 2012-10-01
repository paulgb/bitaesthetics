
all: css/style.css css/fonts

css/style.css: less/*
	lessc less/style.less css/style.css

css/fonts: less/fonts/*
	cp -r less/fonts css/

