#!/bin/env coffee

fs        = require 'fs'
cheerio   = require 'cheerio'
moment    = require 'moment'

source = './blog.html'
destination = './blog.json'

content = fs.readFile source, (err, data) ->
  $ = cheerio.load(data)
  total = $('.atomentry').length
  blogs = $('.atomentry').map((index, el) ->
    $el = $(el)
    # title
    title = $el.find('.title').text()
    # Contents
    $content = $el.find('.content > .post_brief > .cnt')
    $content = $el.find('.content > .post_brief') unless $content.length
    # 转译一下内容，因为 cheerio 的 html() 把 unicode 编码了。
    content = unescape($content.html().replace(/&#x/g,'%u').replace(/;/g,''))
    # CreatedAt
    try
      createdAt = moment($el.find('abbr.published').text()).toJSON()
    catch
      console.error "! Moment processed error at #{$el.find('.title').text()}"
      createdAt = $el.find('abbr.published').attr('title')
    {
      id: total - index
      title: title
      slug: encodeURIComponent title
      content: content
      createdAt: createdAt
      category: $el.find('.readmore').text()
      tags: $el.find('.post_tags').map((index, el) -> $(el).text()).get()
    }
  ).get()

  try
    json = JSON.stringify blogs, null, 2
  catch err
    console.error arguments
  fs.writeFile destination, json, (err) ->
    throw err if err?
    console.log "#{total} blogs saved to #{destination}."
