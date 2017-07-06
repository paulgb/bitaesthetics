---
title: Make for Data Scientists
date: 2012-10-15
---

_This is a follow-up to [Chris Clark's](http://blog.untrod.com/) post, [Engineering Practices in Data Science](http://blog.kaggle.com/2012/10/04/engineering-practices-in-data-science/), and is [cross-posted to the Kaggle blog](http://blog.kaggle.com/2012/10/15/make-for-data-scientists/)._

Any reasonably complicated data analysis or visualization project will involve a number of stages. Typically, the data starts in some raw form and must be extracted and cleaned. Then there are a few transformation stages to get the data in the right shape, merge it with secondary data sources, or run it against a model. Finally, the results get converted into the output format desired.

When I first started working with data, I did the transformations on the data sequentially, using a variety of tools and scripts. When a client came back with more source data, I would have to manually run it through the steps from beginning to end. As my projects got more complex, I noticed I was spending less time coding and more time manually managing the data pipeline. Worse still, I found myself returning to old projects with all the scripts and data intact, only to realize that I hadn't documented the pipeline and had to figure out from clues how to re-run it. I realized I needed to start automating the process to make my projects manageable.

Fortunately, I'm not the first person to want to automate a computation pipeline. Way back in 1977, Stuart Feldman at Bell Labs realized that the tasks required to compile a program could be abstracted out into a general-purpose pipeline tool. The command-line tool, called Make, is still widely used for building software, and it works just as well for data processing jobs.

Make is easy to obtain, with free versions available for all common operating systems. In this post I will be discussing [GNU Make](http://www.gnu.org/software/make/), which is included with [XCode](https://developer.apple.com/xcode/) on Mac OS and either pre-installed or easy to obtain on most Linux systems. Windows users will want to look into [Nmake](http://msdn.microsoft.com/en-us/library/ms930369.aspx), which is included with the [Windows SDK](http://www.microsoft.com/en-ca/download/details.aspx?id=8279).

To use make, all you need is a file in the base directory of your project, typically named `Makefile` with no file extension. This file is plain text and will describe all the data transformation stages in your project. For example, suppose your project uses data from a [Hive](http://hive.apache.org/) data warehouse and a JSON file available through a web API. You could create two rules for fetching the data by putting the following text in your makefile.

    some_data.tsv :
    	hive -e "select * from my_data" > some_data.tsv
    
    other_data.json :
    	curl example.com/some_data_file.json > other_data.json

You can think of makefile rules as stages of computation. The first line of a rule shows the output file (called a target) of the computation, followed by a colon. The second line is indented by a tab character (`make` doesn't like spaces) and indicates the command used to generate the target file. This is run through your system shell, so you can use shell features like redirecting output into files as shown above.

Now if you run `make some_data.tsv`, it will run the Hive query and store the result in `some_data.tsv`. Likewise, you can run `make other_data.json` to fetch the JSON file using `curl`, a command-line tool for downloading files from the web. If you then run either command again, `make` will simply tell you that nothing needs to be done. That's because `make` sees that the target file already exists.

Now suppose you want to convert the `JSON` and `TSV` files to `CSV`, and you have python scripts in your `src/` folder to do this. I'm using `src/` as an example; make is totally agnostic towards directory structure. You could add these rules anywhere in your makefile.

    some_data.csv : some_data.tsv src/tsv_to_csv.py
    	src/tsv_to_csv.py some_data.tsv some_data.csv
    
    other_data.csv : other_data.json src/json_to_csv.py
    	src/json_to_csv.py other_data.json other_data.csv

This looks similar to the rules above, but notice now that we have two filenames after each colon. These are called components and tell make what files that stage of computation depends on. Now if you run `make some_data.csv`, it will run the conversion script `tsv_to_csv.py` with the argument list given in the rule.

Here's the cool part: now you delete `some_data.tsv` and run `make some_data.csv` again. Instead of failing because a required component (`some_data.tsv`) doesn't exist, make runs the rule for `some_data.tsv` first and then runs the rule for `some_data.csv` once the requirement is satisfied.

It's not just data files, either. If we change `src/json_to_csv.py` to, say, fix a bug, Make will know that `other_data.csv` is out of date and recreate it with the new version of the script. Make doesn't do anything magical, it just traces the path of the data and figures out what's missing or out of date based on the "Last Modified" attribute of the file. Note that `src/json_to_csv.py` is listed as a component of `other_data.csv` in the rule above.

Makefiles are easy to use but scale well to a more complicated workflow. For example, I've used make to automate the entire flow of data from a raw source to a polished visualization, from gathering and transforming the data to rendering and compositing layers of the image. In general, make will support any workflow as long as it doesn't require writing to the same file from multiple stages.

One limitation of this approach is that intermediate data (the data made available from one stage to the next) can't be stored in an external database. This is because make relies on the existence and age of files to know what needs to be recomputed, and database tables don't always map to individual files stored in predictable locations. You can get around this by using an embedded database like SQLite and storing the database file within the data directory, as long as you create the database in one stage and restrict yourself to read-only access afterwards.

A `make` workflow can play nicely with version control systems like Git. My habit is to keep data files (both source and derived) out of the repository and instead add rules to fetch them directly from their source. This not only reduces the amount of data in the repo, it creates implicit documentation of the entire build process from source to final product. If you're dealing with collaborators, you can use environment variables to deal with the fact that different collaborators may have slightly different build environments.

Make may not be the best pipeline tool for every situation, but I've yet to find a tool that beats it on simplicity and versatility.
