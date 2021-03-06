import os
import streams
import strformat

import utils


const
    TEMPLATE_FOOT = staticRead("resources/templates/foot.html")
    TEMPLATE_HEAD = staticRead("resources/templates/head.html")
    TEMPLATE_HEADER = staticRead("resources/templates/header.html")
    TEMPLATE_MICROPAGE = staticRead("resources/templates/micro-page.html")
    TEMPLATE_MICROPOSTCONTENT = staticRead("resources/templates/micro-post-content.html")
    TEMPLATE_MICROPOST = staticRead("resources/templates/micro-post.html")
    TEMPLATE_PAGECONTENT = staticRead("resources/templates/page-content.html")
    TEMPLATE_PAGE = staticRead("resources/templates/page.html")
    TEMPLATE_POSTCONTENT = staticRead("resources/templates/post-content.html")
    TEMPLATE_POST = staticRead("resources/templates/post.html")
    TEMPLATE_RSS = staticRead("resources/templates/rss.xml")
    TEMPLATE_SITEMAP = staticRead("resources/templates/sitemap.xml")
    TEMPLATE_TAG = staticRead("resources/templates/tag.html")
    TEMPLATE_TAGS = staticRead("resources/templates/tags.html")
    GRAVATAR_IMAGE = staticRead("resources/gravatar.png")


proc writeFileContent(dir:string, name:string, content:string) =
    if not dirExists(dir):
        createDir(dir)

    let fname = joinPath(dir, name)
    var fs = newFileStream(fname, fmWrite)
    fs.write(content)
    fs.close()


proc initialise*(dir:string) =
    writeFileContent(dir, "Makefile", MAKEFILE)

    let cssDir = joinPath(dir, "css")
    createDir(cssDir)
    let imgDir = joinPath(dir, "img") 
    createDir(imgDir)
    createDir(joinPath(dir, "js"))
    createDir(joinPath(dir, "tags"))
    createDir(joinPath(dir, "css"))
    let blogDir = joinPath(dir, "blog")
    createDir(blogDir)
    let microDir = joinPath(dir, "micro") 
    createDir(microDir)

    let templateDir = joinPath(dir, "templates")
    writeFileContent(templateDir, "foot.html", TEMPLATE_FOOT)
    writeFileContent(templateDir, "head.html", TEMPLATE_HEAD)
    writeFileContent(templateDir, "header.html", TEMPLATE_HEADER)
    writeFileContent(templateDir, "micro-page.html", TEMPLATE_MICROPAGE)
    writeFileContent(templateDir, "micro-post-content.html", TEMPLATE_MICROPOSTCONTENT)
    writeFileContent(templateDir, "micro-post.html", TEMPLATE_MICROPOST)
    writeFileContent(templateDir, "page-content.html", TEMPLATE_PAGECONTENT)
    writeFileContent(templateDir, "page.html", TEMPLATE_PAGE)
    writeFileContent(templateDir, "post-content.html", TEMPLATE_POSTCONTENT)
    writeFileContent(templateDir, "post.html", TEMPLATE_POST)
    writeFileContent(templateDir, "rss.xml", TEMPLATE_RSS)
    writeFileContent(templateDir, "sitemap.xml", TEMPLATE_SITEMAP)
    writeFileContent(templateDir, "tag.html", TEMPLATE_TAG)
    writeFileContent(templateDir, "tags.html", TEMPLATE_TAGS)

    writeFileContent(imgDir, "gravatar.png", GRAVATAR_IMAGE)

    let now = getCurrentDateTime()
    let postedTime = formatDateTime(now)
    writeFileContent(microDir, "index-page.text", fmt"""title: [Microblog title]
posted-time: {postedTime}
type: micro-post
url: http://example.org/micro
description: [Microblog feed description]
tags: 

""")

    writeFileContent(blogDir, "index-page.text", fmt"""title: [Blog title]
posted-time: {postedTime}
tags: 
url: http://example.org/blog
description: [Blog description]

""")

    writeFileContent(dir, "index.text", fmt"""title: [Site title here]
posted-time: {postedTime}
meta-description: [meta description goes here]
banner-image: /img/banner.jpg
url: http://example.org
type: page

""")

    writeFileContent(cssDir, "stylesheet.css", """
.pageheaderimg {
width: 100%;
}

.microblog {
width:650px;
margin-left:auto;
margin-right:auto;
margin-top:1.5em;
line-height:25px;
}

.micro-content {
margin-bottom:2em;
}

.micro-username {
font-weight:bold;
}

.micro-username a {
color:black;
text-decoration:none;
}

.micro-username a:hover {
text-decoration:underline;
}

.avatar img {
width:48px;
height:48px;
display:inline-block;
vertical-align:top;
padding-top:5px;
padding-right:6px;
float:left;
}

.micro-post-text {
word-wrap:break-word;
display:inline-block;
vertical-align:top;
padding:0;
margin:0;
line-height:25px;
width:85%;
}

.micro-post-text p {
margin:0;
padding:0;
}

.micro-post-text h4 {
padding-top:0;
margin-top:0;
border-top:0;
}

.micro-post-text ul {
list-style:none
}

.micro-post-text li::before {
content:"•";
color:dimgrey;
display:inline-block;
width:1em;
margin-left:-1em
}

.micro-post-text li {
line-height:1em;
margin:0;
padding-bottom:0.3em;
}

.micro-footer {
margin-top:1.5em;
margin-bottom:2em;
}

.micro-footer a {
text-decoration:none;
padding-right: 1em;
}

.micro-footer a:hover {
text-decoration:underline;
}

.micro-link {
color:grey;
font-size:12px;
}

.micro-single-post {
width:650px;
margin-left:auto;
margin-right:auto;
margin-top:5em;
line-height:25px;
}

.micro-meta {
padding-top:.75em;
padding-bottom:2em;
color:grey;
font-size:12px;
}
""")