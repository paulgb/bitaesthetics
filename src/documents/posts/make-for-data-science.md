Any reasonably complicated data analysis or visualization project will involve a number of stages. Typically, the data starts in some raw form and must be extracted and cleaned. Then there are generally a few transformation stages to get the data in the right shape, merge it with secondary data sources, or run it against a model. Finally, the results have to be converted into the format needed.

When I first started working with data, I did the transformations on the data sequentially, using a variety of tools or scripts. When a client came back with more source data, I would have to manually run it through the steps from beginning to end. As my projects got more complex, I noticed I was spending less time coding and more time manually managing the data pipeline. Worse still, I found myself returning to old projects with all the scripts and data in tact, only to realize that I hadn't documented the pipeline and had to figure out from clues how to re-run it.

Fortunately, I'm not the first person to want to automate a computation pipeline. Way back in 1977, Stuart Feldman at Bell Labs realized that the tasks required to compile a program could be abstracted out into a general-purpose pipeline tool. The tool, called `make`, is still widely used for compiling software, but as you'll see, it works just as well for data processing jobs.

Make is easy to obtain, with freely-available versions available for all common operating systems. In this post I will be discussing GNU Make, which is included with XCode on Mac OS and either pre-installed or easy to obtain on most Linux systems. Windows users will want to look into Nmake, which is included with the Windows SDK.

To use make, all you need is a file (typically named `Makefile` with no file extension) in the base directory of your project. This file is plain text and will describe all the data transformation stages in your project. For example, supposed your project uses data from a Hive data warehouse and a JSON file available through a web API. You could create two rules for fetching the data by putting the following rules in your makefile.

    some_data.tsv :
    	hive -e "select * from my_data" > some_data.tsv
    
    other_data.json :
    	curl example.com/some_data_file.json > other_data.json


You can think of makefile rules as stages of computation. The first line shows the output file (called a "target") of the computation, followed by a colon. The second line is indented by a tab character (alas, spaces won't do) shows the command used to obtain that file. There can actually be multiple targets and multiple commands, but that's beyond the scope of this post.

Now if you run `make some_data.tsv`, it will run the hive script and store the data in `some_data.tsv`. If you then run the same command again, it won't do anything. That's because `make` sees that the file `some_data.tsv` already exists. Likewise, you can run `make other_data.json` to fetch the JSON file (assuming you've installed `curl`, a tool for downloading files from the web).

Now suppose you want to convert the `JSON` and `TSV` files to `CSV`, and you have python scripts in your src/ folder to do this (I'm using src/ as an example; make is totally agnostic to directory structure).


some_data.csv : some_data.tsv src/tsv_to_csv.py
	src/tsv_to_csv.py some_data.tsv some_data.csv

other_data.csv : other_data.json src/json_to_csv.py
	src/json_to_csv.py other_data.json other_data.csv
```

This looks similar to the rules above, but notice now that we have two filenames after each colon. These are called components and tell make what files that stage of computation depends on. Now if you run `make some_data.csv`, it will run the conversion script tsv_to_csv.py with the argument list "some_data.tsv some_data.csv", as specifified in the rule.

Here's the cool part: suppose you delete `some_data.tsv` and run `make some_data.csv` again. Rather than failing because a required source file (`some_data.tsv`) doesn't exist, make runs the rule for `some_data.tsv` first and then runs the rule for `some_data.csv` once the requirement is satisfied.

Note that we didn't just add the input data file after the colon, but the conversion script as well. This means if we change the conversion script (say to fix a bug), it will regenerate `some_data.csv` again the next time we ask for it, either by calling `make some_data.csv` directly or by running a rule which lists `some_data.csv` as a requirement. This is where the power of make comes in: you just have to describe the flow of data, and make figures out what needs to update when you change the data automatically.

It's important to note that make isn't doing anything magical here, it's just tracing the path of the data and figuring out what's missing or out of date based on the "Last Modified" attribute of the file.

Makefiles are simple to get started with but it scales well to a more complicated workflow. For example, I've used it to automate the entire flow of data from a raw source to a polished visualization, from transforming the data to rendering and composing layers of the image. In general, make will support any workflow as long as it doesn't require writing to the same file from multiple stages, as there's no way for make to know from the "Last Modified" date which stages have been run. Unfortunately this precludes storing the results of each stage in database tables, as make can't look inside the database file to know which tables exist or need to be computed.

One limitation of this approach is that intermediate data (the data made available from one stage to the next) can't be stored in an external database. This is because make relies on the existance and age of files to know what needs to be computed, and database tables don't always map to individual files stored in predictable locations. You can get around this by using an embedded database like SQLite and storing the database file within the data directory, but only if you 

The make workflow plays nicely with version control systems like Git. My habit is to keep data files (both source and derived) out of the repository and instead add rules to fetch them directly from their source. This not only reduces the amount of data in the repo, it creates implicit documentation of the entire build process from source to final product. If you're dealing with collaborators, you can use environment variables to deal with the fact that different collaborators may have different build environments.




