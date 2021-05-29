#!/usr/bin/env python3

import os, sys
import json

mode = sys.argv[1]
api = "http://192.168.64.47:32001/api/v1/users/"

def ret(cmd):
    req = os.popen(cmd)
    res = req.read()
    return res

def show():
    cmd = "curl -s " + api
    res = ret(cmd)
    print(res)

def read():
    res = ret("curl -s " + api + "$(cat /tmp/mini-id)")
    j = json.loads(res)
    print(json.dumps(j))

def update():
    res = ret("./test/update.sh " + api + " $(cat /tmp/mini-id)")
    j = json.loads(res)
    print(json.dumps(j))

def create():
    res = ret("./test/create.sh " + api)
    j = json.loads(res)
    print(json.dumps(j))
    res = ret("echo " + j["id"] + " > /tmp/mini-id")

if mode == 'all':
    show()
if mode == 'read':
    read()
if mode == 'update':
    update()
if mode == 'create':
    create()
