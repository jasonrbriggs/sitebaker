import os

import docopt

import blog
import db
import emoji
import generator
import init
import pages
import streams
import strutils
import system
import times
import timezones
import utils
import zip/gzipfiles

let doc = """
Baker. Command line static website generator.

Usage:
  baker blog <title> [--taglist <tags>]
  baker compress [--force]
  baker federate <targeturl> <directory> [--days <days>]
  baker generate [--file <filename>] [--force]
  baker indexes [--posts <num>] <directory>
  baker dump <filename>
  baker init [<dir>]
  baker jsonfeed <directory>
  baker micro [-]
  baker rss <directory>
  baker sitemap
  baker test
  baker tags

Options:
  -h --help         Show this screen.
  --days            Number of days to federate (new posts only) [default: 1].
  --file            Generate a specific file.
  --force           Force re-generation, not just new files.
  --tags            Comma-separate list of tags, used for blog entries.
  --version         Show the version.
  --posts=<posts>   Posts per index page [default: 10].
  --taglist <tags>  Comma separated list of tags [default: ""]

Available commands:
  blog              Generate a blog entry with the given title (and optionally tags).
  federate          Federate new posts (within a number of days) to the given target url using webmention.
  compress          Compress resource files (css, jpg).
  generate          Generate/render a file, or if no arguments given, all files with recent changes.
  indexes           Create the index pages for posts in a given directory.
  dump
  init              Setup a directory to use with baker.
  jsonfeed          Generate a json feed file for the given directory.
  micro             Generate a microblog entry (reads from standard-input, two newlines finishes entry).
  rss               Generate an RSS feed file for the given directory.
  sitemap           Generate the sitemap.xml file in the root directory.
  tags              Generate the tag cloud directory.
"""

when isMainModule:
    let args = docopt(doc, version = "Baker " & BakerVersion)

    if args["generate"]:
        if args["--file"]:
            generate($args["<filename>"])
        else:
            generateAll($args["--force"] == "true") 

    elif args["indexes"]:
        let dir = $args["<directory>"]
        var posts = 10
        if args["--posts"]:
            posts = parseInt($args["--posts"])
        generateIndexes(dir, posts)


    elif args["dump"]:
        let page = loadPage(".", $args["<filename>"])

        printPage(page)

    elif args["init"]:
        var dir:string = "."
        if args["<dir>"]:
            dir = $args["<dir>"]

        if not dirExists(dir):
            createDir(dir)

        let makefile = joinPath(dir, "Makefile")
        if fileExists(makefile):
            echo "Already initialised"
            quit(1)
        else:
            initialise(dir)

    elif args["micro"]:
        var contents = ""
        if args["-"]:
            contents = readAll(stdin)
        microBlog(contents)

    elif args["tags"]:
        generateTags()

    elif args["compress"]:
        compressResourceFiles($args["--force"] == "true")

    elif args["rss"]:
        let dir = $args["<directory>"]
        generateFeed(dir)

    elif args["jsonfeed"]:
        let dir = $args["<directory>"]
        generateJsonFeed(dir)

    elif args["blog"]:
        var tags = ""
        if args["tags"]:
            tags = $args["<tags>"]
        blog($args["<title>"], tags)

    elif args["sitemap"]:
        generateSitemap()

    elif args["federate"]:
        var days = 1
        if args["--days"]:
            days = parseInt($args["<days>"])
        let dir = $args["<directory>"]
        federatePages(".", $args["<targeturl>"], dir, days)

