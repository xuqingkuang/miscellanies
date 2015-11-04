#!/usr/local/bin/coffee

fs      = require 'fs'
request = require 'request'

url = 'http://[troll].com'

readDict = ->
  # OS X dictionary path
  dict = fs.readFileSync('/usr/share/dict/web2').toString().split('\n')
  dict = dict.filter((d) -> d isnt '').map((d) -> d.toLowerCase())
  dict

randomQQ = ->
  randomNum = Math.random()
  length = Math.floor(Math.random() * 12)
  while randomNum < 0.1
    randomNum = Math.random()
  while length < 7
    length = Math.floor(Math.random() * 12)
  randomNum = Math.random().toString().substring(2)
  randomNum.slice(0, length)

randomPassword = (dict) ->
  first = Math.floor(Math.random() * dict.length)
  second = Math.floor(Math.random() * dict.length)
  randomNum = Math.floor(Math.random() * 999).toString()
  initialPasword = [dict[first], dict[second]].join('')
  randomIndex = Math.floor(Math.random() * initialPasword.length)
  splitedPassword = initialPasword.split('')
  first = splitedPassword.slice(0, randomIndex)
  second = splitedPassword.slice(randomIndex, splitedPassword.length)
  splitedPassword.splice(randomIndex, 0, randomNum)
  splitedPassword.join('')


bullet = (qq, password, next)->
  params =
    qq: qq
    password: password
  request.post
    url: url
    form: params
    headers:
      'Referer': 'http://[troll-referer].com'
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36'
    (err, httpResponse, body) ->
      return console.error err if err
      res = JSON.parse body
      console.log "FIRED - #{qq}:#{password}"
      next()

fire = ->
  dict = readDict()
  gun = -> bullet(randomQQ(), randomPassword(dict), gun)
  gun()

fire()
